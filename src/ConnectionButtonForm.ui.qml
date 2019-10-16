import QtQuick 2.4

Item {
    id: element
    width: 200
    height: 200
    property alias mouseArea: mouseArea
    property alias button: button
    property alias icon: icon.source

    Rectangle {
        id: button
        color: "#ffffff"
        radius: width / 2
        anchors.fill: parent

        Image {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: "icons/exit.svg"
            fillMode: Image.PreserveAspectFit
            width: parent.width * 0.8
            height: width
        }
    }

    MouseArea {
        id: mouseArea
        width: parent.width
        height: parent.height
    }
}

/*##^##
Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:100;anchors_y:100}
}
##^##*/

