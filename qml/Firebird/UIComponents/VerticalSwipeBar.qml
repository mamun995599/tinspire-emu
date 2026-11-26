import QtQuick 2.0
import Firebird.UIComponents 1.0

/* Slim edge handle with a grab pill and a chevron.
 * direction: 1 = chevron points right (drawer is on the left),
 *           -1 = chevron points left. */
Item {
    id: bar
    signal clicked

    property int direction: 1
    property color tint: Theme.textDim

    implicitWidth: 22

    Rectangle {
        id: pill
        width: 4
        height: Math.min(48, bar.height * 0.5)
        radius: 2
        color: bar.tint
        opacity: mouseArea.pressed ? 0.9 : 0.45
        anchors.centerIn: parent
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    MouseArea {
        id: mouseArea
        property point orig;
        anchors.fill: parent

        onPressed: {
            orig.x = mouse.x;
            orig.y = mouse.y;
        }

        onReleased: {
            if(Math.abs(orig.x - mouse.x) < 5
               && Math.abs(orig.y - mouse.y) < 5)
                bar.clicked();
        }
    }
}
