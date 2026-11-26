import QtQuick 2.7
import QtQuick.Layouts 1.0

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

        // Own tab bar + page loaders (more reliable than a styled TabView)
        property int currentTab: 0

        ConfigPagesModel { id: pagesModel }

        Row {
            id: tabBar
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 6 }
            height: 42

            Repeater {
                model: pagesModel

                Rectangle {
                    width: tabBar.width / Math.max(1, pagesModel.count)
                    height: tabBar.height
                    radius: 11
                    color: index === sheet.currentTab ? Theme.accent : "transparent"
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        width: parent.width - 8
                        text: qsTranslate("ConfigPagesModel", title)
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        color: index === sheet.currentTab ? "white" : Theme.inkDim
                        font.pixelSize: TextMetrics.normalSize * 0.95
                        font.bold: index === sheet.currentTab
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: sheet.currentTab = index
                    }
                }
            }
        }

        Item {
            id: pages
            anchors {
                left: parent.left; right: parent.right
                top: tabBar.bottom; bottom: parent.bottom
                margins: 8
            }

            Repeater {
                model: pagesModel

                Loader {
                    anchors.fill: parent
                    visible: index === sheet.currentTab
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
