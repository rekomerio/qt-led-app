import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import QtWebSockets 1.1
import "scripts.js" as Js

ApplicationWindow {
    id: window
    visible: true
    width: 400
    height: 720
    title: qsTr("LED Control Panel")
    menuBar: Rectangle {
        width: parent.width
        height: 45
        color: "#353637"
        ConnectionButton {
            id: connectionButton
            width: height
            height: 35
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            color: "#7e7f81"
            anchors.topMargin: 5
            activeColor: "#FFAA00"
            icon: "icons/plus.svg"
            mouseArea.onClicked: {
                socket.active = !socket.active
            }
        }
        Text {
            id: connectionStatus
            width: 184
            color: "#747272"
            text: qsTr("Connect")
            anchors.topMargin: 15
            anchors.top: parent.top
            anchors.left: connectionButton.right
            anchors.leftMargin: 6
            font.family: "Arial"
            font.pixelSize: 12
        }
    }

    WebSocket {
        id: socket
        url: "ws://192.168.4.1:81"
        active: false
        property string message: "#000000"
        property string previous: ""
        property string confirmedAddress: ""

        onStatusChanged: {
            switch (socket.status) {
            case WebSocket.Open:
                socket.confirmedAddress = socket.url
                spinner.running = false
                connectionButton.icon = "icons/minus.svg"
                connectionStatus.text = "Disconnect"
                break
            case WebSocket.Closed:
                spinner.running = false
                connectionButton.icon = "icons/plus.svg"
                connectionStatus.text = "Connect"
                break
            case WebSocket.Closing:
                connectionStatus.text = "Closing..."
                break
            case WebSocket.Connecting:
                spinner.running = true
                connectionButton.icon = "icons/minus.svg"
                connectionStatus.text = "Connecting..."
                break
            case WebSocket.Error:
                connectionButton.icon = "icons/alert.svg"
                connectionStatus.text = "Error"
                break
            }
            messageSender.running = socket.status === WebSocket.Open
            infoFetcher.running = messageSender.running
        }

        function sendMessageSafely(msg) {
            if(status === WebSocket.Open) {
                sendTextMessage(msg)
            }
        }

        onTextMessageReceived: {
            if (message === "Connected") {
                socket.sendTextMessage('-*') // Ask server for effect names
            }
            switch (message[0]) {
            case '*':
                Js.addEffect(message)
                effectList.model = Js.effects // Update effects list
                break
            case '!':
                const msg = Js.parseMessage(message)
                sleep.text = msg.sleep === "0" ? "Sleep not set" : "Sleep: " + Js.millisToTime(msg.sleep)
                effectSpeed.value       = msg.speed
                effectList.activeEffect = msg.effect
                brightnessDial.value    = msg.brightness
                hueDial.value           = msg.hue
                socket.message          = msg.hue // Set message and previous to be the same, so received hue value wont be sent back
                socket.previous         = msg.hue
               break
            }
        }
    }

    Timer {
        id: messageSender
        running: false
        interval: 50
        repeat: true

        onTriggered: {
            if (socket.message !== socket.previous) {
                socket.sendTextMessage(socket.message)
                socket.previous = socket.message
            }
        }
    }

    Timer {
        id: infoFetcher
        running: false
        interval: 50
        repeat: true

        onTriggered: {
           socket.sendTextMessage("-!")
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0

        onCurrentIndexChanged: {
            footerButtons.currentIndex = currentIndex
        }

        Page {
            Background {
                id: background
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                Column {
                    id: column
                    spacing: 35
                    width: parent.width
                    height: 580
                    anchors.top: parent.top
                    anchors.topMargin: 40
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    ColoredDial {
                        id: brightnessDial
                        width: parent.width * 0.65
                        height: width
                        anchors.horizontalCenterOffset: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        backgroundColor: "#0a0a0a"
                        stepSize: 1
                        to: 255
                        label: "Brightness"

                        onValueChanged: {
                            const hue        = Js.reScale(hueDial.value, 0, 255, 0, 1)
                            const brightness = Js.reScale(value, 0, 255, 0, 0.5)
                            borderColor      = Js.hslToRgb(hue, 1, brightness)
                            socket.message   = "-b" + Math.floor(value).toString(16)
                        }
                        MouseArea {
                            width: parent.width * 0.4
                            height: parent.width * 0.4
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            onDoubleClicked: {
                                brightnessDial.value = brightnessDial.value ? 0 : 255
                            }
                        }
                    }

                    ColoredDial {
                        id: hueDial
                        width: parent.width * 0.65
                        height: width
                        anchors.horizontalCenterOffset: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        backgroundColor: "#0a0a0a"
                        stepSize: 1
                        to: 255
                        label: "Hue"

                        onValueChanged: {
                            const hue                  = Js.reScale(value, 0, 255, 0, 1)
                            const brightness           = Js.reScale(brightnessDial.value, 0, 255, 0, 0.5)
                            borderColor                = Js.hslToRgb(hue, 1, 0.5)
                            brightnessDial.borderColor = Js.hslToRgb(hue, 1, brightness)
                            socket.message             = "-h" + Math.floor(value).toString(16)
                        }
                        MouseArea {
                            width: parent.width * 0.4
                            height: parent.width * 0.4
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            onDoubleClicked: {
                                socket.sendMessageSafely("-a")
                            }
                        }
                    }
                }
                BusyIndicator {
                    id: spinner
                    running: false
                    width: parent.width / 2
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
        Page {
            Background {
                id: background2
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                ListView {
                    id: effectList
                    property int activeEffect: -1
                    anchors.bottomMargin: 20
                    anchors.topMargin: 80
                    anchors.fill: parent
                    spacing: 10
                    model: 1
                    clip: true
                    delegate:
                        EffectItem {
                        text: modelData ? modelData : "No connection"
                        width: parent.width * 0.9
                        selected: effectList.activeEffect === index
                        mouseArea.onClicked: {
                            socket.sendMessageSafely("-e" + index)
                        }
                    }
                }

                Slider {
                    id: effectSpeed
                    width: parent.width  * 0.9
                    height: 40
                    stepSize: 1
                    anchors.horizontalCenterOffset: 0
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    value: 20
                    from: 10
                    to: 80

                    onValueChanged: {
                        socket.message = "-t" + value.toString(16)
                    }
                }
            }
        }
        Page {
            id: page
            Background {
                id: background1
                clip: false
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
            }
            Text {
                id: sleep
                color: "#b1b1b1"
                text: "Sleep"
                font.pixelSize: 20
                font.family: "Arial"
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
            ListView {
                id: listView
                anchors.bottomMargin: 20
                clip: true
                spacing: 5
                anchors.topMargin: 70
                anchors.fill: parent
                model: sleepModel
                delegate:
                    EffectItem {
                    text: Js.getFormattedInterval(intervalMin)
                    width: parent.width * 0.9
                    mouseArea.onClicked: {
                        socket.sendMessageSafely("-s" + (intervalMin * 60 * 1000).toString(16))
                    }
                }
            }
        }
    }
    footer: TabBar {
        id: footerButtons
        width: parent.width
        currentIndex: swipeView.currentIndex

        onCurrentIndexChanged: {
            swipeView.currentIndex = currentIndex
        }

        CustomTabButton {
            text:""
            imageSource: "icons/home.svg"
        }
        CustomTabButton {
            text:""
            imageSource: "icons/list.svg"
        }
        CustomTabButton {
            text:""
            imageSource: "icons/clock.svg"
        }
    }
    ListModel {
        id: sleepModel
        ListElement { intervalMin: 0 }
        ListElement { intervalMin: 0.166 }
        ListElement { intervalMin: 1 }
        ListElement { intervalMin: 5 }
        ListElement { intervalMin: 15 }
        ListElement { intervalMin: 30 }
        ListElement { intervalMin: 45 }
        ListElement { intervalMin: 60 }
        ListElement { intervalMin: 90 }
        ListElement { intervalMin: 120 }
        ListElement { intervalMin: 180 }
        ListElement { intervalMin: 240 }
        ListElement { intervalMin: 300 }
        ListElement { intervalMin: 360 }
        ListElement { intervalMin: 720 }
    }
}
