import QtQuick 2.4
import QtQuick.Controls 2.5

TabButton {
    id: btn
    text: "Button"
    property alias imageSource: image.source
    Image {
        id: image
        height: parent.height * 0.7
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: height
        source: "icons/check.svg"
    }
}

