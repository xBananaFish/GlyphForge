import QtQuick
import QtQuick.Controls.Material

Button {
    text: qsTr("Material-Flat-Button")
    spacing: 16
    display: AbstractButton.TextBesideIcon
    topPadding: 0
    rightPadding: display === AbstractButton.TextBesideIcon && String(icon.source).length > 0 ? 24 : 16
    bottomPadding: 0
    leftPadding: 16
    implicitHeight: 42
    topInset: 0; bottomInset: 0; leftInset: 0; rightInset: 0
    flat: true
}
