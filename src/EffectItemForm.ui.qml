import QtQuick 2.4

Rectangle {
    property alias listItem: listItem
    property alias text: element.text
    property alias mouseArea: mouseArea
    id: listItem
    width: 400
    height: 50
    radius: 10
    gradient: Gradient {
        GradientStop {
            position: 0
            color: mouseArea.pressed || selected ? "#cc208e" : "#65379b"
        }

        GradientStop {
            position: 0.53
            color: "#886aea"
        }

        GradientStop {
            position: 1
            color: mouseArea.pressed ? "#cc208e" : (selected ? "#6713d2" : "#6457c6")
        }
    }
    anchors.horizontalCenter: parent.horizontalCenter
    color: "#43e97b"
    border.color: "#7c7e7c"
    Text {
        id: element
        color: "#f1f0f0"
        text: ""
        font.family: "Arial"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }
}
