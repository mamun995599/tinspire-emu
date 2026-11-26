import QtQuick 2.0
import Firebird.Emu 1.0
import Firebird.UIComponents 1.0

Rectangle {
    property string active_color: Theme.keyActive
    property string back_color: Theme.keyBase
    property string font_color: "#fff"
    property string edge_color: Theme.keyBorder
    property real fontScale: 0.55
    property bool boldText: true
    property alias text: label.text
    property bool active: pressed || mouseArea.containsMouse
    property bool pressed: false
    // Pressing the right mouse button "locks" the button in enabled state
    property bool fixed: false
    property int keymap_id: 1

    signal clicked()

    border.width: 1
    border.color: active ? "#8FD0FF" : edge_color
    radius: 6
    color: active ? active_color : back_color

    onPressedChanged: {
        if(pressed)
            clicked();

        if(!pressed)
            fixed = false;

        Emu.setButtonState(keymap_id, pressed);
    }

    Connections {
        target: Emu
        function onButtonStateChanged(id, state) {
            if(id === keymap_id)
                pressed = state;
        }
    }

    // Key depth: dark edge below the key
    Rectangle {
        z: -1
        y: active ? 0 : 1
        width: parent.width
        height: parent.height
        radius: parent.radius
        color: "#000000"
    }

    // Dome shading: light top edge, darker lower part
    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 1 }
        height: parent.height * 0.4
        radius: parent.radius
        color: active ? "#10FFFFFF" : "#08FFFFFF"
    }

    Text {
        id: label
        text: "Foo"
        anchors.fill: parent
        anchors.centerIn: parent
        font.pixelSize: height*fontScale
        color: font_color
        font.bold: boldText
        // Workaround: Text.AutoText doesn't seem to work for properties (?)
        textFormat: text.indexOf(">") == -1 ? Text.PlainText : Text.RichText
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    // This is needed to support pressing multiple buttons at once on multitouch
    MultiPointTouchArea {
        id: multiMouseArea

        mouseEnabled: Qt.platform.os === "android" || Qt.platform.os === "ios"
        maximumTouchPoints: 1
        minimumTouchPoints: 1

        anchors.centerIn: parent
        width: parent.width * 1.3
        height: parent.height * 1.3

        onTouchUpdated: {
            var newState = false;
            for(var i in touchPoints)
            {
                var tp = touchPoints[i];
                if(tp.pressed
                   && tp.x >= 0 && tp.x < width
                   && tp.y >= 0 && tp.y < height)
                {
                    newState = true;
                    break;
                }
            }

            parent.pressed = newState;
        }
    }

    MouseArea {
        id: mouseArea

        enabled: !multiMouseArea.mouseEnabled

        preventStealing: true

        anchors.centerIn: parent
        width: parent.width * 1.3
        height: parent.height * 1.3
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        hoverEnabled: !Emu.isMobile()

        onPressed: {
            mouse.accepted = true;

            if(mouse.button == Qt.LeftButton)
            {
                if(!fixed)
                    parent.pressed = true;
            }
            else if(fixed === parent.pressed) // Right button
            {
                fixed = !fixed;
                parent.pressed = !parent.pressed;
            }
        }

        onReleased: {
            mouse.accepted = true;

            if(mouse.button == Qt.LeftButton
                    && !fixed)
                parent.pressed = false;
        }
    }
}
