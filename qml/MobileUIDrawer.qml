import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1

import Firebird.Emu 1.0
import Firebird.UIComponents 1.0

Rectangle {
    color: Theme.bg

    implicitWidth: Math.max(layout.implicitWidth + 28, 270)

    Rectangle {
        // Soft header glow
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: parent.height * 0.4
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#232B45" }
            GradientStop { position: 1.0; color: Theme.bg }
        }
    }

    function closeDrawer() {
        listView.closeDrawer();
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 6
            spacing: 12

            Image {
                id: logo
                source: "qrc:/icons/resources/tinspire-emu.png"
                Layout.preferredHeight: 84
                Layout.preferredWidth: 38
                sourceSize: Qt.size(160, 350)
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
                mipmap: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "TI-Nspire CX CAS"
                    color: Theme.text
                    font.pixelSize: TextMetrics.title2Size
                    font.weight: Font.Bold
                }

                Text {
                    text: qsTr("Emulator")
                    color: Theme.textDim
                    font.pixelSize: TextMetrics.normalSize
                }

                Rectangle {
                    Layout.topMargin: 4
                    radius: 10
                    implicitHeight: 22
                    implicitWidth: chipText.implicitWidth + 26
                    color: Emu.isRunning ? "#143323" : Theme.surface
                    border.color: Emu.isRunning ? Theme.ok : Theme.outline

                    Rectangle {
                        width: 8; height: 8; radius: 4
                        x: 9
                        anchors.verticalCenter: parent.verticalCenter
                        color: Emu.isRunning ? Theme.ok : Theme.textDim
                    }

                    Text {
                        id: chipText
                        x: 22
                        anchors.verticalCenter: parent.verticalCenter
                        text: Emu.isRunning ? qsTr("Running") : qsTr("Stopped")
                        color: Emu.isRunning ? Theme.ok : Theme.textDim
                        font.pixelSize: TextMetrics.normalSize * 0.85
                        font.weight: Font.DemiBold
                    }
                }
            }
        }

        Item { Layout.minimumHeight: 4 }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            DrawerButton {
                 id: restartButton

                 title: qsTr("Start")
                 icon: "qrc:/icons/resources/icons/ic_play.png"
                 accent: Theme.ok

                 onClicked: {
                     Emu.useDefaultKit();
                     Emu.restart();
                     closeDrawer();
                 }
             }

             DrawerButton {
                 id: resetButton

                 disabled: !Emu.isRunning

                 title: qsTr("Reset")
                 icon: "qrc:/icons/resources/icons/ic_reset.png"
                 accent: Theme.warn

                 onClicked: {
                     Emu.reset();
                     closeDrawer();
                 }
             }

             DrawerButton {
                 id: resumeButton

                 title: qsTr("Resume")
                 icon: "qrc:/icons/resources/icons/ic_resume.png"
                 accent: Theme.accent

                 onClicked: {
                     Emu.useDefaultKit();
                     Emu.resume()
                     closeDrawer();
                 }
             }

             DrawerButton {
                 id: saveButton

                 disabled: !Emu.isRunning

                 title: qsTr("Save")
                 icon: "qrc:/icons/resources/icons/ic_save.png"
                 accent: Theme.violet

                 MessageDialog {
                     id: saveFailedDialog
                     title: qsTr("Error")
                     text: qsTr("Failed to save changes!")
                     icon: StandardIcon.Warning
                 }

                 MessageDialog {
                     id: snapWarnDialog
                     title: qsTr("Warning")
                     text: qsTr("Flash saved, but no snapshot location configured.\nYou won't be able to resume.")
                     icon: StandardIcon.Warning
                 }

                 onClicked: {
                     var flash_path = Emu.getFlashPath();
                     var snap_path = Emu.getSnapshotPath();

                     if(flash_path === "" || !Emu.saveFlash())
                         saveFailedDialog.visible = true;
                     else
                     {
                         if(snap_path)
                             Emu.suspend();
                         else
                             snapWarnDialog.visible = true;
                     }

                     closeDrawer();
                }
            }

            Item {
                Layout.minimumHeight: 2
            }

            DrawerButton {
                id: desktopUIButton
                visible: !Emu.isMobile()

                title: qsTr("Desktop UI")
                icon: "qrc:/icons/resources/icons/ic_monitor.png"
                accent: Theme.teal

                onClicked: Emu.switchUIMode(false);
            }

            DrawerButton {
                id: configButton

                title: qsTr("Configuration")
                icon: "qrc:/icons/resources/icons/ic_settings.png"
                accent: "#64748B"

                onClicked: listView.openConfiguration();
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            DrawerButton {
                id: speedButton
                toggle: true
                toggleState: Emu.turboMode

                icon: "qrc:/icons/resources/icons/ic_speed.png"
                accent: Theme.pink
                title: qsTr("Turbo · %1 %").arg(Math.round(100*Emu.speed))
                onToggleStateChanged: {
                    Emu.turboMode = toggleState
                    toggleState = Qt.binding(function() { return Emu.turboMode })
                }
            }

            DrawerButton {
                id: aboutButton

                icon: "qrc:/icons/resources/icons/ic_info.png"
                accent: "#475569"
                title: qsTr("About")
                subtitle: qsTr("Ti Nspire CX CAS Emulator v" + Emu.version)

                MessageDialog {
                    id: aboutDialog
                    title: qsTr("About")
                    text: qsTr("<b>Developer</b><br>
                               Abdullah Al Mamun<br>
                               Phone: +8801945120109<br>
                               Email: mamun995599@gmail.com<br>
                               Address: Siddhirganj- 1428, Narayanganj, Bangladesh.")
                }

                onClicked: {
                    aboutDialog.visible = true;
                }
            }
        }
    }
}
