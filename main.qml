import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import 'qml'
import Constants

Window
{
    property color textColor: backend.viewType ? Const.kTouchesColor : Const.kGesturesColor
    property color textHoveredColor: backend.viewType ? Const.kTouchesHoveredColor : Const.kGesturesHoveredColor

    id: root
    width: Const.kWidth
    height: Const.kHeight
    minimumWidth: Const.kWidth
    minimumHeight: Const.kHeight
    maximumWidth: Const.kWidth * 1.2
    maximumHeight: Const.kHeight * 1.2
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2
    visible: true
    title: Const.kWindowTitle

    Column
    {
        id: main
        anchors.fill: parent
        spacing: Const.kSpacing
        padding: Const.kSpacing

        Label
        {
            text: Const.kTitleText
            topPadding: Const.kSpacing
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: Const.kBigLabelFontSize
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: textColor
        }

        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter

            CustomRadioButton
            {
                id: touchesButton
                checked: backend.viewType
                text: Const.kTouchesText
                mainColor: textColor
                hoveredColor: textHoveredColor
                font.pointSize: Const.kBigLabelFontSize
                anchors.left: parent.left

                onClicked: backend.viewType = true
            }

            CustomRadioButton
            {
                id: gesturesButton
                checked: !backend.viewType
                text: Const.kGesturesText
                mainColor: textColor
                hoveredColor: textHoveredColor
                font.pointSize: Const.kBigLabelFontSize
                anchors.left: parent.left

                onClicked: backend.viewType = false
            }
        }

        Label
        {
            text: backend.feedback
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: Const.kSmallLabelFontSize
            topPadding: Const.kSpacing
            anchors.horizontalCenter: parent.horizontalCenter
            color: textColor
        }
    }
}
