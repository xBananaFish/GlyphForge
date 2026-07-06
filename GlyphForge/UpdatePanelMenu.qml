import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import QtCore

import "Controls"

Popup {
    id: updatePanelMenu
    width: 280
    padding: 16
    Material.background: Theme.background
    Material.elevation: 12

    Timer {
        running: settings.autoUpdateEnabled
        interval: settings.autoUpdateInterval * 1000
        repeat: true
        onTriggered: {
            if ( glyphManager.refreshing )
                return;
            glyphManager.refresh()
        }
    }

    contentItem: ColumnLayout {
        spacing: 8
        CheckBox {
            id: cbUpdate
            text: qsTr("automatisch aktualisieren")
            Layout.fillWidth: true
            checked: settings.autoUpdateEnabled
            onCheckedChanged: {
                settings.autoUpdateEnabled = checked
            }
        }
        
        ColumnLayout {
            spacing: 4
            enabled: cbUpdate.checked
            Label {
                text: "Interval"
                wrapMode: "WordWrap"
                font.pointSize: 8
                font.bold: true
                Layout.fillWidth: true
            }
            
            SpinBox {
                id: sbInterval
                wheelEnabled: true
                Layout.fillWidth: true
                from: 1; to: 120;
                value: settings.autoUpdateInterval
                onValueChanged: { settings.autoUpdateInterval = value; }
            }
            
            Label {
                text: "Legt den Interval fest, in welchen Abständen aktualisiert wird. Die Angabe ist in Sekunden."
                wrapMode: "WordWrap"
                font.pointSize: 8
                Layout.fillWidth: true
            }
        }
        
        MaterialButton {
            text: qsTr("schließen")
            icon.source: Icons.x
            flat: true
            Layout.fillWidth: true
            onClicked: {  updatePanelMenu.close(); }
        }
    }
}
