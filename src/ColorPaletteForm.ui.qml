import QtQuick 2.4

Item {
    width: 400
    height: 400
    Grid {
        width: parent.width
        height: parent.height
        rows: 5
        columns: 5
        Repeater {
            id: repeater
            anchors.fill: parent
            model: 25
            Rectangle {
                id: rectangle
                width: parent.width / 5
                height: parent.width / 5
                color: "#"
                border.width: 1
            }

        }
    }
}
