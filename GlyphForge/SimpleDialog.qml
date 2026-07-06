import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Controls"

Popup {
    id: questionDialog
    width: 370
    padding: 16
    Material.background: Theme.background
    Material.elevation: 12
    modal: true
    visible: true
    anchors.centerIn: Overlay.overlay

    property string title: "Title"
    property string text: "Text"

    signal accepted

    contentItem: ColumnLayout {
        spacing: 16
        Label {
            text: questionDialog.title
            Layout.fillWidth: true
            elide: "ElideRight"
            font.bold: true
            font.pointSize: Theme.fontSize.medium
        }

        Label {
            text: questionDialog.text
            Layout.fillWidth: true
            wrapMode: "WordWrap"
            font.pointSize: Theme.fontSize.control
        }

        RowLayout {
            Layout.topMargin: 8
            Layout.alignment: Qt.AlignRight
            MaterialFlatButton {
                text: "Abbrechen"
                onClicked: { questionDialog.close(); }
            }

            MaterialFlatButton {
                text: "Ok"
                onClicked: {
                    questionDialog.accepted()
                    questionDialog.close();
                }
            }
        }
    }
}
