import QtQuick
import QtQuick.Controls

Menu {
    id: menu
    leftPadding: 8
    rightPadding: 8
    Material.elevation: 12
    Material.roundedScale: Material.SmallScale
    Material.background: Theme.background
    signal removed()
    MenuItem {
        text: "Icon entfernen"
        icon.source: Icons.trash_01
        height: 42
        font.pointSize: 10
        Material.foreground: Material.Red
        onClicked: { menu.removed(); }
    }
}