import QtQuick 2.0
import QtQuick.Layouts 1.0
import Firebird.UIComponents 1.0

/* Modern drawer row: colored icon badge, title, optional subtitle and switch. */
Item {
    id: root
    property alias icon: image.source
    property alias title: label.text
    property alias subtitle: sub.text
    property alias font: label.font
    property color accent: Theme.accent
    property bool disabled: false
    property bool toggle: false
    property bool toggleState: false
    property bool chevron: false

    signal clicked()

    opacity: disabled ? 0.4 : 1.0

    implicitHeight: sub.text !== "" ? 56 : 50
    implicitWidth: 14 + 36 + 12 + Math.max(label.implicitWidth, sub.implicitWidth)
                   + 14 + (toggle ? 52 : 0)

    Layout.fillWidth: true

    Rectangle {
        id: card
        anchors.fill: parent
        radius: Theme.radius
        color: (mouseArea.pressed && !root.disabled) ? Theme.surfaceHi
               : (root.toggle && root.toggleState ? "#1F2A47" : Theme.surface)
        border.width: 1
        border.color: (root.toggle && root.toggleState) ? Theme.accent : Theme.outline
        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }
    }

    Rectangle {
        id: badge
        width: 36
        height: 36
        radius: 11
        color: root.accent
        x: 12
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: image
            width: 20
            height: 20
            sourceSize: Qt.size(96, 96)
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }
    }

    Column {
        anchors {
            left: badge.right
            leftMargin: 12
            right: toggleSwitch.visible ? toggleSwitch.left : parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        spacing: 1

        Text {
            id: label
            width: parent.width
            color: Theme.text
            elide: Text.ElideRight
            font.pixelSize: TextMetrics.title1Size
            font.weight: Font.DemiBold
        }

        Text {
            id: sub
            width: parent.width
            visible: text !== ""
            color: Theme.textDim
            elide: Text.ElideRight
            font.pixelSize: TextMetrics.normalSize * 0.85
        }
    }

    // Pill switch for toggle rows
    Rectangle {
        id: toggleSwitch
        visible: root.toggle
        width: 40
        height: 22
        radius: 11
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        color: root.toggleState ? Theme.accent : Theme.outline
        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            width: 16
            height: 16
            radius: 8
            y: 3
            x: root.toggleState ? parent.width - width - 3 : 3
            color: "white"
            Behavior on x { NumberAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(root.disabled)
                return;

            root.clicked();

            if(root.toggle)
                root.toggleState = !root.toggleState;
        }
    }
}
