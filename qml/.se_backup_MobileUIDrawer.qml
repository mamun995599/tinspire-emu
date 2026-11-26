import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.0

import Firebird.Emu 1.0
import Firebird.UIComponents 1.0

Rectangle {
    color: "white"

    implicitWidth: layout.implicitWidth

    function closeDrawer() {
        listView.closeDrawer();
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 5

        Image {
            id: logo
            source: "qrc:/icons/resources/tinspire-emu.png"

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width * 0.5
            Layout.maximumHeight: parent.width * 0.7
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            smooth: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: -1 // Collapse borders

            DrawerButton {
                 id: restartButton

                 title: qsTr("Start")
                 icon: "qrc:/icons/resources/icons/edit-bomb.png"

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
                 icon: "qrc:/icons/resources/icons/system-reboot.png"

                 onClicked: {
                     Emu.reset();
                     closeDrawer();
                 }
             }

             DrawerButton {
                 id: resumeButton

                 title: qsTr("Resume")
                 icon: "qrc:/icons/resources/icons/system-suspend-hibernate.png"

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
                 icon: "qrc:/icons/resources/icons/media-floppy.png"

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
                Layout.minimumHeight: 60
            }

            DrawerButton {
                id: desktopUIButton
                visible: !Emu.isMobile()

                title: qsTr("Desktop UI")
                icon: "qrc:/icons/resources/icons/video-display.png"

                onClicked: Emu.switchUIMode(false);
            }

            DrawerButton {
                id: configButton

                title: qsTr("Configuration")
                icon: "qrc:/icons/resources/icons/preferences-other.png"

                onClicked: listView.openConfiguration();
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: -1 // Collapse borders

            DrawerButton {
                id: speedButton
                toggle: true
                toggleState: Emu.turboMode

                title: qsTr("Speed: %1 %").arg(Math.round(100*Emu.speed))
                font.pixelSize: TextMetrics.normalSize
                onToggleStateChanged: {
                    Emu.turboMode = toggleState
                    toggleState = Qt.binding(function() { return Emu.turboMode })
                }
            }

            DrawerButton {
                id: aboutButton

                borderBottomVisible: false

                title: qsTr("Ti Nspire CX CAS Emulator v" + Emu.version)

                font.pixelSize: TextMetrics.normalSize

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
