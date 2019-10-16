import QtQuick 2.4
import QtQuick.Controls 2.13

Dial {
    id: dial
    property alias fontColor: element.color
    property alias backgroundColor: rectangle.color
    property alias label: element.text
    property alias rectangle: rectangle
    height: width
    value: to / 2

    background: Rectangle {
        id: rectangle
        color: "#000000"
        radius: width / 2
        border.width: 3
        anchors.fill: parent
        border.color: "#cc02e392"
    }

    Text {
        id: element
        color: "#7e7c7c"
        font.underline: false
        font.family: "Arial"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
    }
}
