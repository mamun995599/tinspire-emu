import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import Firebird.UIComponents 1.0

Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    Rectangle {
        anchors.fill: parent
        color: Theme.paper
    }

    Rectangle {
        id: header
        anchors { left: parent.left; right: swipeBar.left; top: parent.top }
        height: 56
        color: "transparent"

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            spacing: 10

            IconButton {
                width: 34
                height: 34
                icon: "qrc:/icons/resources/icons/ic_settings.png"
                tint: Theme.accent
                onClicked: listView.openDrawer()
            }

            FBLabel {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Configuration")
                font.pixelSize: TextMetrics.title2Size * 1.1
                font.bold: true
            }
        }
    }

    Rectangle {
        id: sheet
        anchors {
            left: parent.left
            right: swipeBar.left
            top: header.bottom
            bottom: autoSaveLabel.top
            leftMargin: 10
            rightMargin: 6
            bottomMargin: 6
        }
        radius: 16
        color: Theme.card
        border.color: Theme.line
        border.width: 1
        clip: true

        TabView {
            id: tabView
            anchors.fill: parent
            anchors.margins: 6

            property var model: ConfigPagesModel {}

            style: TabViewStyle {
                frameOverlap: 0
                tabOverlap: 0
                tabsAlignment: Qt.AlignHCenter

                frame: Rectangle { color: "transparent" }
                tabBar: Rectangle {
                    color: "transparent"
                }

                tab: Item {
                    implicitWidth: Math.max(60, control.width / Math.max(1, control.count))
                    implicitHeight: 42

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 3
                        radius: 11
                        color: styleData.selected ? Theme.accent : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            width: parent.width - 8
                            text: styleData.title
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            color: styleData.selected ? "white" : Theme.inkDim
                            font.pixelSize: TextMetrics.normalSize * 0.95
                            font.bold: styleData.selected
                        }
                    }
                }
            }

            Repeater {
                id: rep
                model: tabView.model

                Tab {
                    title: qsTranslate("ConfigPagesModel", rep.model.get(index).title)
                    source: file
                }
            }
        }
    }

    FBLabel {
        id: autoSaveLabel

        anchors {
            left: parent.left
            leftMargin: 14
            right: swipeBar.left
            bottom: parent.bottom
            bottomMargin: 6
        }

        text: qsTr("Changes are saved automatically")
        font.italic: true
        font.pixelSize: TextMetrics.normalSize * 0.9
        color: Theme.inkDim
    }

    VerticalSwipeBar {
        id: swipeBar

        direction: -1
        tint: Theme.inkDim

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        onClicked: {
            listView.openDrawer();
        }
    }
}
