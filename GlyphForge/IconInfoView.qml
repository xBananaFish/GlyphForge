import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Controls"

RowLayout {
    id: iconInfoView
    spacing: 8
    width: 432

    MaterialFlatButton {
        text: qsTr("auswählen")
        icon.source: Icons.check
        enabled: iconsView.view.selectionCount < iconsView.view.count && iconsView.view.count > 0
        onClicked: {
            iconsView.view._buttons( (b, _) => b.checked = true )
        }
    }

    MaterialFlatButton {
        text: qsTr("abwählen")
        icon.source: Icons.x
        enabled: iconsView.view.selectionCount > 0 && iconsView.view.count > 0
        onClicked: {
            iconsView.view._buttons( (b, _) => b.checked = false )
        }
    }


    RoundButton {
        icon.source: Icons.trash_01
        display: AbstractButton.IconOnly
        flat: true
        Material.foreground:  Material.Red
        onClicked: {
            if ( menu.visible )
                return;
            menu.y = height + 2
            menu.open()
        }

        Menu {
            id: menu
            width: 300
            leftPadding: 8
            rightPadding: 8
            Material.elevation: 12
            Material.roundedScale: Material.SmallScale
            Material.background: Theme.background

            property var dialogRef: null

            function openDialog( title, text, callback ) {
                if ( dialogRef )
                    return;

                const component = Qt.createComponent( "SimpleDialog.qml" );
                if ( !component.status === Component.Ready ) {
                    console.log(component.errorString())
                    return;
                }

                const dialog = component.createObject( glyphForge );
                dialogRef = dialog;
                dialog.text = text;
                dialog.title = title;

                dialog.onAccepted.connect( function() {
                    callback();
                    dialog.destroy();
                    dialogRef = null;
                });

                dialog.onClosed.connect( function() {
                    dialog.destroy();
                    dialogRef = null;
                });

            }

            MenuItem {
                text: "Nicht benutzte entfernen"
                icon.source: Icons.trash_01
                height: 42
                font.pointSize: 10
                Material.foreground: Material.Red
                enabled: glyphScanner.unused > 0 && iconsView.view.count > 0
                onClicked: {
                    menu.openDialog(
                                "Nicht benutzte Icons entfernen",
                                "Sollen wirklich alle nicht benutzten Icons entfernt werden?",
                                function() {
                                    iconsView.view._buttons( function( btn, index) {
                                        if ( !btn.used ) {
                                            glyphManager.removeGlyph( index );
                                            --iconsView.view.selectionCount;
                                        }
                                    } );
                                    glyphScanner.scan();
                                }
                                );
                }
            }

            MenuItem {
                text: "ausgewählte entfernen"
                icon.source: Icons.trash_01
                height: 42
                font.pointSize: 10
                Material.foreground: Material.Red
                enabled: iconsView.view.selectionCount > 0 && iconsView.view.count > 0
                onClicked: {
                    menu.openDialog(
                                "Ausgewählte Icons entfernen",
                                "Sollen wirklich alle ausgewählten Icons entfernt werden?",
                                function() {
                                    iconsView.view._buttons( function( btn, index) {
                                        if ( btn.checked ) {
                                            glyphManager.removeGlyph( index );
                                            --iconsView.view.selectionCount;
                                        }
                                    } );
                                    glyphScanner.scan();
                                }
                                );
                }
            }

            MenuItem {
                text: "Alle entfernen"
                icon.source: Icons.trash_01
                height: 42
                font.pointSize: 10
                Material.foreground: Material.Red
                enabled: iconsView.view.count > 0
                onClicked: {
                    menu.openDialog(
                                "Alle Icons entfernen",
                                "Sollen wirklich alle Icons entfernt werden?",
                                function() {
                                    iconsView.view._buttons( function( btn, index) {
                                        glyphManager.removeGlyph( index );
                                        --iconsView.view.selectionCount;
                                    } );
                                }
                                );
                }
            }
        }
    }
}
