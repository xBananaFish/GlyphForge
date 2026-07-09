import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore
import Glyphs


Rectangle {
    id: glyphForge
    width: Theme.width
    height: Theme.height

    color: Theme.background

    Material.accent: settings.accent
    GlyphForgeSettings { id: settings }

    IconsView { id: iconsView }
    SideBar { id: sideBar }
    MenuPane { id: menuPane }

    GlyphManager {
        id: glyphManager
        folderPath: settings.iconsFolderPath
        iconFilePath: settings.qmlSelectedFilePath

        Component.onCompleted: { refresh(); }

        onRefreshingChanged: {
            if ( !refreshing ) {
                glyphScanner.scan();
            }
        }
    }

    GlyphScanner {
        id: glyphScanner
        manager: glyphManager
        projectScanPath: settings.projectScanPath
        onScanningChanged:   {
            settings.scanElapsedMs = glyphScanner.scanElapsedMs;
        }
    }
}























