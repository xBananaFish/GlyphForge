import QtQuick

import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Popup {
    id: menuPaneSettings
    width: 370
    padding: 16
    Material.background: Theme.background
    Material.elevation: 12
    modal: true
    anchors.centerIn: Overlay.overlay
    
    contentItem: ColumnLayout {
        spacing: 0
        Label {
            text: qsTr("Einstellungen")
            font.bold: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            font.pointSize: 18
            Layout.bottomMargin: 16
            background: Rectangle { height: 4; radius: 2; y: parent.height; width: 50; color: Material.accent }
        }
        
        Label {
            opacity: 0.5
            text: qsTr("Basis-Veränderungen können hier vorgenommen werden, um Inhalte anders darzustellen.")
            wrapMode: Text.WordWrap
            font.pointSize: 10
            Layout.fillWidth: true
            textFormat: Text.MarkdownText
        }
        
        ColumnLayout {
            spacing: 8
            Layout.topMargin: 16
            
            Switch {
                LayoutMirroring.enabled: true
                Layout.fillWidth: true
                checked: settings.isDarkMode
                text: checked ? "Heller Modus" : "Dunkler Modus"
                onCheckedChanged: {
                    settings.isDarkMode = checked;
                    Theme.isDarkMode = checked;
                }
            }

            Switch {
                LayoutMirroring.enabled: true
                Layout.fillWidth: true
                checked: settings.showIconDetails
                text: `Icon-Details ${checked ? "aus" : "an"}`
                onCheckedChanged: {
                    settings.showIconDetails = checked;
                }
            }

            SpacerRectH{}
            Label {
                text: "Akzent-Farbe"
            }
            RowLayout {
                Repeater {
                    model: [Material.Blue, Material.Indigo, Material.Green, Material.Yellow, Material.Red, Material.Purple]
                    
                    RoundButton {
                        Material.background: modelData
                        scale: settings.accent === Material.color(modelData).toString() ? 1.35 : 1
                        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

                        onClicked: {
                            settings.accent = Material.color(modelData)
                        }
                    }
                }
            }
        }
        
    }
}
