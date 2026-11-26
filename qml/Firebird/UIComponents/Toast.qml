import QtQuick 2.0

import Firebird.UIComponents 1.0

Rectangle {
    property int maxWidth: parent.width * 0.9
    height: message.contentHeight + 20
    width: message.contentWidth + 36

    radius: height / 2
    color: "#F2171C27"
    border.color: Theme.outline
    border.width: 1

    opacity: 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 200 } }

    function showMessage(str) {
        message.text = str;
        opacity = 1;
        timer.restart();
    }

    FBLabel {
        id: message
        text: "Text"
        color: Theme.text
        width: Math.min(contentWidth, parent.maxWidth)

        anchors.centerIn: parent

        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: TextMetrics.normalSize * 1.1
        wrapMode: Text.WordWrap

        Timer {
            id: timer
            interval: 2000
            onTriggered: parent.parent.opacity = 0;
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            timer.stop();
            parent.opacity = 0;
        }
    }
}
