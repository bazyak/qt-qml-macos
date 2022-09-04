pragma Singleton
import QtQuick 2.15

QtObject
{
    readonly property int kWidth: 500
    readonly property int kHeight: 200
    readonly property string kWindowTitle: qsTr('Qt + QML + macOS native API example')

    readonly property int kSpacing: 10

    readonly property int kBigLabelFontSize: 16
    readonly property int kSmallLabelFontSize: 14

    readonly property color kTouchesColor: 'darkturquoise'
    readonly property color kGesturesColor: 'orange'
    readonly property color kTouchesHoveredColor: 'gray'
    readonly property color kGesturesHoveredColor: 'orangered'

    property string kTitleText: qsTr('Shows a NSCustomTouchBarItem using a NSView')
    property string kTouchesText: qsTr('Using Touch Events')
    property string kGesturesText: qsTr('Using Gesture Recognizers')
}
