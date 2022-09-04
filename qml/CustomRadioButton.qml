import QtQuick 2.15
import QtQuick.Controls 2.15

RadioButton
{
    property color mainColor: 'darkturquoise'
    property color hoveredColor: 'gray'

    id: control

    indicator: Rectangle
    {
        implicitWidth: 26
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        border.color: control.hovered ? hoveredColor : mainColor

        Rectangle
        {
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 7
            color: control.hovered ? hoveredColor : mainColor
            visible: control.checked
        }
    }

    contentItem: Text
    {
        text: control.text
        font: control.font
        color: mainColor
        opacity: enabled ? 1.0 : 0.3
        //color: control.down ? '#17a81a' : '#21be2b'
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
