import QtQuick 2.4

ConnectionButtonForm {
    property string activeColor: "#FFFFFF"
    property string color: "white"

    mouseArea.onPressed: {
        button.color = activeColor
    }
    mouseArea.onReleased: {
        button.color = color
    }
    onColorChanged: {
        button.color = color
    }
}


