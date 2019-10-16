import QtQuick 2.4

ColoredDialForm {
    property string borderColor: rectangle.border.color

    onBorderColorChanged: {
        rectangle.border.color = borderColor
    }
}
