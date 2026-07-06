import QtQuick

import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Pane {
    id: menuPane
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 8
    width: 1107
    height: 68
    topPadding: 0
    bottomPadding: 0
    rightPadding: 8
    leftPadding: 8

    NumberAnimation on anchors.rightMargin { from: 300; to: 8; duration: 750; easing.type: "InOutQuad" }
    NumberAnimation on anchors.leftMargin { from: -300; to: 8; duration: 750; easing.type: "InOutQuad" }
    NumberAnimation on opacity { from: 0; to: 1; duration: 750; easing.type: "InOutQuad" }
    
    Material.background: Theme.backgroundAlt
    Material.elevation: 6
    
    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 4
        
        RoundButton {
            checked: settings.sideBarVisbile
            checkable: true
            icon.source: Icons.menu_open
            display: AbstractButton.IconOnly
            flat: true
            rotation: checked ? 180 : 0
            icon.color: checked ? Material.accent : Material.foreground
            onCheckedChanged: settings.sideBarVisbile = checked;
        }
        
        RoundButton {
            enabled: !menuPaneSettings.visible
            icon.source: Icons.settings
            display: AbstractButton.IconOnly
            flat: true
            rotation: checked ? 180 : 0
            onClicked: {
                if ( menuPaneSettings.visible )
                    return;

                menuPaneSettings.y = height + 2
                menuPaneSettings.open()
            }

            MenuPaneSettings { id: menuPaneSettings }
        }
        
        Item { Layout.fillWidth: true }

        IconInfoView { id: iconInfoView }
    }
}
