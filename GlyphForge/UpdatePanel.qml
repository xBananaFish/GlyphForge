import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import "Controls"

Pane {
    id: updatePanel
    Layout.fillWidth: true
    height: 180
    padding: 16
    Material.background: Theme.backgroundAlt
    Material.elevation: 6
    
    contentItem: Item {
        implicitHeight: columnLayout.implicitHeight
        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            spacing: 0
            Label {
                id: label1
                text: qsTr("Aktualisierungen")
                font.bold: true
                Layout.fillWidth: true
                font.pointSize: 18
                Layout.bottomMargin: 16
                background: Rectangle { height: 4; radius: 2; y: parent.height; width: 50; color: Material.accent }
            }

            Label {
                opacity: 0.5
                text: qsTr("Aktualisiert die Icons, wenn ein Pfad festgelegt und eine **Icons.qml**-Datei ausgewählt wurde.")
                wrapMode: Text.WordWrap
                font.pointSize: 10
                Layout.fillWidth: true
                textFormat: Text.MarkdownText
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            MaterialButton {
                text: qsTr("Aktualisieren")
                Layout.topMargin: 16
                icon.source: Icons.sync
                Layout.fillWidth: true
                enabled: !glyphManager.refreshing
                onClicked: {
                    glyphManager.refresh();
                }
            }
        }
        
        RoundButton {
            icon.source: Icons.more_vert
            flat: true
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: -8
            width: 50
            height: 50
            onClicked: {
                if ( updatePanelMenu.visible ) {
                    return;
                }

                updatePanelMenu.y = Qt.binding( () => height + 2 )
                updatePanelMenu.open()
            }

            UpdatePanelMenu {
                id: updatePanelMenu
            }
        }
    }



}
