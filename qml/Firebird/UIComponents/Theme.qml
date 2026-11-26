pragma Singleton
import QtQuick 2.0

/* Central place for all colors and sizes of the modern UI. */
QtObject {
    // Dark surfaces (drawer, keypad, window)
    property color bg: "#0E1117"
    property color bgTop: "#171C27"
    property color surface: "#1A1F2B"
    property color surfaceHi: "#252B3A"
    property color outline: "#2C3445"
    property color text: "#EEF1F8"
    property color textDim: "#8F99AE"

    // Light surfaces (configuration sheet)
    property color paper: "#EEF1F8"
    property color card: "#FFFFFF"
    property color ink: "#1B2130"
    property color inkDim: "#6B7488"
    property color line: "#DDE3EF"

    // Accents
    property color accent: "#5B8CFF"
    property color accentDeep: "#7A5CFF"
    property color ok: "#22C55E"
    property color warn: "#F59E0B"
    property color danger: "#EF4444"
    property color violet: "#8B5CF6"
    property color teal: "#14B8A6"
    property color pink: "#EC4899"

    // Keypad (real TI-Nspire CX II CAS look: black body, grey digit keys, blue rails)
    property color keypadBg: "#18191B"
    property color keypadTop: "#141517"
    property color keyBase: "#1E1F22"
    property color keyBig: "#1E1F22"
    property color keyAlpha: "#27282B"
    property color keyDigit: "#4C4D51"
    property color keyDigitActive: "#8A8C93"
    property color keyBorder: "#45474C"
    property color keyActive: "#3AA7F2"
    property color keyLight: "#6B6C70"
    property color legend: "#3AA7F2"
    property color padRing: "#C3C6CC"

    property int radius: 14
}
