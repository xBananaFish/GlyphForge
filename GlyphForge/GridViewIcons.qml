import QtQuick

import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import "Controls"

GridView {
    id: gridViewIcons
    width: 757
    height: 536
    model: glyphManager.model
    currentIndex: -1
     property int selectionCount: 0
    function _buttons( callback  ) {
        for (let i = gridViewIcons.count - 1; i >= 0; --i ) {
            const b = gridViewIcons.itemAtIndex(i);
            if ( callback && b )
                callback( b, i )
        }
    }

    DropArea {
        anchors.fill: parent

        onEntered: function(drag) { drag.accepted = drag.hasUrls }

        onDropped: function(drop) {
            for ( let i = 0; i < drop.urls.length; ++i ) {

                const url = drop.urls[i].toString();
                const lowerUrl = url.toLowerCase();

                if ( !lowerUrl.endsWith(".png") && !lowerUrl.endsWith(".svg") )
                    continue;

                glyphManager.addGlyph(url)
            }

            glyphManager.writeCollectedIconsContent();
        }
    }


    delegate: MaterialButton {
        id: btn
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight
        Material.roundedScale: Material.SmallScale
        checkable: true
        rightInset: 4
        bottomInset: 4
        topInset: 0
        spacing: 8
        //Material.background: used ? Material.Green : Material.Red// Qt.lighter(Material.color(Material.Red), 1) // Theme.background
        font.pointSize: 8
        display: "TextUnderIcon"
        icon.width: width * 0.45
        icon.height: height * 0.45
        icon.source: glyphManager.fromLocalFile(absoluteFilePath)

        text: baseName

        required property int index
        required property bool used
        required property string baseName
        required property string fileName
        required property string format
        required property string relativePath
        required property string absoluteFilePath
        required property int resolutionWidth
        required property int resolutionHeight
        required property real fileSize
        required property var usedInFiles

        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: function(ev){
                gridViewIcons.currentIndex = index;
                const pos = btn.mapToItem(gridViewIcons, ev.position.x, ev.position.y)
                openMenu( btn, pos, index );
            }
        }

        onCheckedChanged: {
            const c = checked ? ++gridViewIcons.selectionCount : --gridViewIcons.selectionCount
            gridViewIcons.selectionCount = Math.max(0, Math.min(c, gridViewIcons.count))
        }

        onClicked: {
            gridViewIcons.currentIndex = index;
        }

        Rectangle {
            width: 16; height: 16; radius: 8;
            x: btn.width - width - 12; y: 8
            color: used ? Material.color(Material.Green) : Material.color(Material.Red)
            Behavior on color {  ColorAnimation {  duration: 200 } }
        }

        ToolTip {
            enabled: settings.showIconDetails
            visible: btn.hovered && settings.showIconDetails
            delay: 500
            opacity: 1
            padding: 16
            Material.background: Theme.backgroundAlt
            Material.elevation: 12
            Material.foreground: Theme.isDarkMode ? "white" : "black"




            contentItem: GridLayout {
                rowSpacing: 8
                columnSpacing: 8
                columns: 2
                Label { text: "Name" }
                Label { text: baseName; }

                Label { text: "Status" }
                Label {
                    text: used ? "wird verwendet" : "wird nicht verwendet"
                    Material.foreground: used ? Material.Green : Material.Red
                }

                Label { text: "Dateiname" }
                Label { text: fileName }

                Label { text: "Format" }
                Label { text: format }

                Label { text: "Ausflösung" }
                Label { text: `${resolutionWidth} x ${resolutionHeight}` }

                Label { text: "Dateigröße" }
                Label { text: `${fileSize.toFixed(2)} KB` }

                Label { text: "Relativer Pfad" }
                Label { text: relativePath }

                Label { text: "Pfad" }
                Label { text: absoluteFilePath; elide: "ElideLeft" }

                Label { text: "verwendet in"; Layout.columnSpan: 2}

                Repeater {
                    model: usedInFiles
                    Label { text: modelData
                    Layout.columnSpan: 2
                    }
                }

            }
        }
    }
    
    cellWidth: 120
    cellHeight: 120

    function openMenu( control, pos, index ) {
        if ( control.dialogRef )
            return;

        const component = Qt.createComponent( "GridViewIconsMenu.qml" );
        if ( component.status !== Component.Ready ) {
            console.log(component.errorString())
            return;
        }
        const menu = component.createObject( gridViewIcons );
        control.dialogRef = menu;
        menu.x = pos.x;
        menu.y = pos.y;
        menu.open();

        menu.onRemoved.connect( function() {
            glyphManager.removeGlyph( index )

            menu.destroy(0);
            control.dialogRef = null;
        } );

        menu.onClosed.connect( function() {
            menu.destroy(0);
            control.dialogRef = null;
        } );
    }


}

































