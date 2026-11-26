import QtQuick 2.0
import Firebird.UIComponents 1.0

// Digit keys: lighter grey with big white numerals, like the real calculator
NButton {
    width: 30
    height: 20
    back_color: Theme.keyDigit
    active_color: Theme.keyDigitActive
    font_color: "#FFFFFF"
    edge_color: "#38393D"
    fontScale: 0.72
    boldText: false
}
