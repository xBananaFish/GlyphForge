import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "Controls"

Item {
    id: iconsView
    width: Theme.width
    height: Theme.height
    anchors.left: sideBar.right
    anchors.right: parent.right
    anchors.top: menuPane.bottom
    anchors.bottom: parent.bottom
    anchors.margins: 8

    property alias view: gridViewIcons

    NumberAnimation on anchors.leftMargin { from: 300; to: 8; duration: 750; easing.type: "InOutQuad" }
    NumberAnimation on anchors.rightMargin { from: -300; to: 8; duration: 750; easing.type: "InOutQuad" }
    NumberAnimation on opacity { from: 0; to: 1; duration: 750; easing.type: "InOutQuad" }
    
    GridViewIcons {
        id: gridViewIcons
        anchors.fill: parent
    }

    MaterialButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        rightPadding: 4
        bottomPadding: 4
        topPadding: 4
        leftPadding: 4
        bottomInset: 0
        topInset: 0
        icon.source: Icons.add
        Material.background: Material.LightGreen
        icon.width: 32
        icon.height: 32
        Material.roundedScale: Material.SmallScale
        display: "IconOnly"
        icon.color: "#1e2227"
        width: 48
        height: 48
        onClicked: {
            fileDialog.open();
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["*.png", "*.svg"]
        currentFolder: settings.iconsPath
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            settings.iconsPath = currentFolder;
            const files = selectedFiles;


            for( let i = 0; i < files.length; ++i ) {
                const url = files[i].toString();
                const lowerUrl = url.toLowerCase();

                if ( !lowerUrl.endsWith(".png") && !lowerUrl.endsWith(".svg") )
                    continue;
                glyphManager.addGlyph(url)
            }
            glyphManager.writeCollectedIconsContent();
        }
    }
}
