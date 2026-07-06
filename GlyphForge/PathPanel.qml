import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Pane {
    id: pathPanel
    height: columnLayout.implicitHeight + padding * 2
    Layout.fillWidth: true
    padding: 16
    Material.background: Theme.backgroundAlt
    Material.elevation: 6

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: 0
        Label {
            id: label
            text: qsTr("Pfade festlegen")
            Layout.fillWidth: true
            font.bold: true
            font.pointSize: Theme.fontSize.title

            Layout.bottomMargin: 16
            background: Rectangle { height: 4; radius: 2; y: parent.height; width: 50; color: Material.accent }
        }

        Label {
            opacity: 0.5
            text: qsTr("Setzt die Pfade für den **Icon**-Ordner in dem sich die Icons befinden und die **Icons.qml**-Datei, in der hineingeschrieben wird.")
            wrapMode: Text.WordWrap
            textFormat: Text.MarkdownText
            font.pointSize: Theme.fontSize.control
            Layout.fillWidth: true
            Layout.maximumWidth: rlayout.width
        }


        ColumnLayout {
            id: rlayout
            Layout.topMargin: 16
            spacing: 16
            RowLayout {
                id: rowLayout1
                spacing: 16

                TextField {
                    id: textField
                    font.pointSize: Theme.fontSize.control
                    placeholderText: qsTr("Icons - Ordner")
                    Layout.preferredHeight: 42
                    Layout.fillWidth: true
                    readOnly: true
                    text: settings.iconsFolderPath.replace("file:///", "")
                    Material.accent: glyphManager.folderPathExists ? Material.Green : Material.Red
                }

                RoundButton {
                    icon.source: Icons.folder
                    flat: true
                    icon.color: glyphManager.folderPathExists ? Material.color(Material.Green) : Material.color(Material.Red)
                    onClicked: {
                        folderDialog.open()
                    }

                    FolderDialog {
                        id: folderDialog
                        currentFolder: settings.iconsFolderPath
                        onAccepted: {
                            settings.iconsFolderPath = selectedFolder;
                        }
                    }
                }

            }

            RowLayout {
                id: rowLayout
                spacing: 16

                TextField {
                    id: textField1
                    font.pointSize: Theme.fontSize.control
                    placeholderText: qsTr("Icons.qml - Datei")
                    Layout.preferredHeight: 42
                    Layout.fillWidth: true
                    text: settings.qmlSelectedFilePath.replace("file:///", "")
                    readOnly: true
                    Material.accent: glyphManager.iconFilePathExists ? Material.Green : Material.Red
                }

                RoundButton {
                    icon.source: Icons.folder
                    flat: true
                    icon.color: glyphManager.iconFilePathExists ? Material.color(Material.Green) : Material.color(Material.Red)

                    onClicked: {
                        fileDialog.open()
                    }

                    FileDialog {
                        id: fileDialog
                        nameFilters: ["*.qml"]
                        currentFolder: settings.qmlFilePath

                        onAccepted: {
                            settings.qmlFilePath = currentFolder;
                            settings.qmlSelectedFilePath = selectedFile;

                        }
                    }
                }

            }
        }
    }

    
}




























