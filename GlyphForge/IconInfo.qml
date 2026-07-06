import QtQuick

import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import "Controls"

Pane {
    id: iconInfo
    height: 822

    Layout.fillWidth: true
    padding: 16
    Material.background: Theme.backgroundAlt
    Material.elevation: 6
    
    ColumnLayout {
        id: clayout
        anchors.fill: parent
        spacing: 0
        Label {
            text: qsTr("Icon-Info")
            font.bold: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            font.pointSize: 18
            Layout.bottomMargin: 16
            background: Rectangle { height: 4; radius: 2; y: parent.height; width: 50; color: Material.accent }
        }

        Label {
            opacity: 0.5
            text: qsTr("Scan **starten** und Informationen einsehen, die den aktuellen Inhalt umfassen.")
            wrapMode: Text.WordWrap
            font.pointSize: 10
            Layout.fillWidth: true
            textFormat: Text.MarkdownText
        }

        SpacerRectH { }

        RowLayout {
            id: rowLayout1
            spacing: 16

            TextField {
                id: textField
                font.pointSize: 10
                placeholderText: qsTr("Icons - Ordner")
                Layout.preferredHeight: 42
                Layout.fillWidth: true
                readOnly: true
                text: settings.projectScanPath.replace("file:///", "")
                Material.accent: glyphScanner.projectScanPathExists && glyphScanner.isValidProjectPath ? Material.Green : Material.Red
            }

            RoundButton {
                icon.source: Icons.folder
                flat: true
                icon.color: glyphScanner.projectScanPathExists && glyphScanner.isValidProjectPath ? Material.color(Material.Green) : Material.color(Material.Red)
                onClicked: { folderDialog.open() }

                FolderDialog {
                    id: folderDialog
                    currentFolder: settings.projectScanPath
                    onAccepted: {
                        settings.projectScanPath = selectedFolder;
                    }
                }
            }

        }

        MaterialButton {
            text: qsTr("Scan starten")
            icon.source: Icons.troubleshoot
            Layout.columnSpan: 2
            Layout.fillWidth: true
            enabled: glyphScanner.isValidProjectPath && !glyphScanner.scanning && !glyphManager.refreshing
            onClicked: {
                settings.lastScanTime = new Date();
                glyphScanner.scan();
            }
        }

        SpacerRectH { }

        IconInfoCounts {
            id: iconInfoCounts
            total: iconsView.view.count
            used: glyphScanner.used
            unused: glyphScanner.unused
            pngCount: glyphScanner.pngCount
            svgCount: glyphScanner.svgCount
        }

        SpacerRectH { }

        IconInfoSizes {
            id: iconInfoSizes
            sizeTotal: glyphScanner.sizeTotal
            sizeUnused: glyphScanner.sizeUnused
        }

        SpacerRectH { }

        IconInfoScan {
            id: iconInfoScan
        }

    }
}
