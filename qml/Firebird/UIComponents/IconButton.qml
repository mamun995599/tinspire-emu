import QtQuick 2.0
import Firebird.UIComponents 1.0

/* Rounded gradient-free badge button with a white glyph. */
Item {
    id: root
    property alias icon: image.source
    property color tint: Theme.accent
    property bool pressed: mouseArea.pressed
    signal clicked()

    implicitHeight: Math.max(36, TextMetrics.normalSize * 2.5)
    implicitWidth: implicitHeight

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: width * 0.3
        color: root.tint
        opacity: root.pressed ? 0.7 : 1.0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    Image {
        id: image
        width: Math.round(parent.height * 0.52)
        height: width
        sourceSize: Qt.size(128, 128)
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
