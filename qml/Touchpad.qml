import QtQuick 2.0
import Firebird.Emu 1.0
import Firebird.UIComponents 1.0

Rectangle {
    id: rectangle2
    width: 100
    height: 70
    color: "#141517"
    radius: 22
    border.width: 3
    border.color: Theme.keyBorder

    Rectangle {
        id: rectangle1
        x: 29
        y: 18
        width: 35
        height: 35
        color: "#00000000"
        radius: 10
        border.width: 2
        border.color: "#8E9299"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        // Soft top light on the pad
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 2 }
        height: parent.height * 0.45
        radius: parent.radius
        color: "#08FFFFFF"
    }

    Text { text: "\u25B2"; color: "#9AA0A8"; font.pixelSize: 9; anchors.horizontalCenter: parent.horizontalCenter; y: 4 }
    Text { text: "\u25BC"; color: "#9AA0A8"; font.pixelSize: 9; anchors.horizontalCenter: parent.horizontalCenter; y: parent.height - height - 4 }
    Text { text: "\u2039"; color: "#9AA0A8"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter; x: 6 }
    Text { text: "\u203A"; color: "#9AA0A8"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter; x: parent.width - width - 6 }

    Rectangle {
        id: highlight
        x: 0
        y: 0
        width: 10
        height: 10
        color: "#B34ADE80"
        radius: 10
        visible: false
    }

    /* Click and hold at same place -> Down
       Click and quick release -> Down
       Click and move -> Contact */
    MouseArea {
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        preventStealing: true

        property int origX
        property int origY
        property int moveThreshold: 5
        property bool isDown

        Connections {
            target: Emu
            function onTouchpadStateChanged(x, y, contact, down) {
                if(contact || down)
                {
                    highlight.x = x*width - highlight.width/2;
                    highlight.y = y*height - highlight.height/2;
                    highlight.color = down ? "#B34ADE80" : "#B35B8CFF";
                }

                highlight.visible = contact || down;
            }
        }

        Timer {
            id: clickOnHoldTimer
            interval: 200
            running: false
            repeat: false
            onTriggered: {
                parent.isDown = true;
                parent.submitState();
            }
        }

        Timer {
            id: clickOnReleaseTimer
            interval: 100
            running: false
            repeat: false
            onTriggered: {
                parent.isDown = false;
                parent.submitState();
            }
        }

        function submitState() {
            Emu.setTouchpadState(mouseX/width, mouseY/height, isDown || pressed, isDown);
        }

        onMouseXChanged: {
            if(Math.abs(mouseX - origX) > moveThreshold)
                clickOnHoldTimer.stop();

            submitState();
        }

        onMouseYChanged: {
            if(Math.abs(mouseY - origY) > moveThreshold)
                clickOnHoldTimer.stop();

            submitState();
        }

        onReleased: {
            if(clickOnHoldTimer.running)
            {
                clickOnHoldTimer.stop();
                isDown = true;
                clickOnReleaseTimer.restart();
            }
            else
                isDown = false;

            submitState();
        }

        onPressed: {
            origX = mouse.x;
            origY = mouse.y;
            isDown = false;
            clickOnHoldTimer.restart();
        }
    }
}

