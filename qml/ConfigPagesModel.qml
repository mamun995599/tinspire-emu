import QtQuick 2.0

ListModel {
    ListElement {
        title: QT_TR_NOOP("Flash & Boot1")
        icon: "qrc:/icons/resources/icons/ic_chip.png"
        file: "qrc:/qml/qml/ConfigPageKits.qml"
    }
    ListElement {
        title: QT_TR_NOOP("Emulation")
        icon: "qrc:/icons/resources/icons/ic_bolt.png"
        file: "qrc:/qml/qml/ConfigPageEmulation.qml"
    }
    ListElement {
        title: QT_TR_NOOP("File Transfer")
        icon: "qrc:/icons/resources/icons/ic_transfer.png"
        file: "qrc:/qml/qml/ConfigPageFileTransfer.qml"
    }
    ListElement {
        title: QT_TR_NOOP("Debugging")
        icon: "qrc:/icons/resources/icons/ic_bug.png"
        file: "qrc:/qml/qml/ConfigPageDebug.qml"
    }
}
