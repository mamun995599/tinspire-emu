import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import Firebird.UIComponents 1.0

Item {
    property alias text: label.text
    property alias iconSource: icon.source

    width: parent.width * 0.9
    height: width
    anchors.horizontalCenter: parent.horizontalCenter

    MouseArea {
        anchors.fill: parent
        onClicked: function() {
            parent.ListView.view.currentIndex = index
            parent.forceActiveFocus()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Rectangle {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: Math.min(parent.width, parent.height * 0.6)
            Layout.preferredHeight: Layout.preferredWidth
            radius: width * 0.28
            color: Theme.accent

            Image {
                id: icon
                anchors.centerIn: parent
                width: parent.width * 0.55
                height: width
                sourceSize: Qt.size(128, 128)
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
            }
        }

        FBLabel {
            id: label
            Layout.fillWidth: true
            text: "Text"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: TextMetrics.normalSize
        }
    }
}
