import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts


Button {
    text: "Material-Button"
    height: 64
    Layout.preferredHeight: height
    property color __bgColor: checked ? Material.color(Material.Blue) : Theme.background
    Material.background: __bgColor
    Material.elevation: elevationValue

    Material.accent: checked ? Theme.background : Theme.foreground
    Material.foreground:  Theme.foreground
    property real elevationValue: hovered ? 12 : 6
    Behavior on elevationValue { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on __bgColor { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    property var dialogRef: null
}
