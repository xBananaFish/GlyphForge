import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Settings {
    id: settings
    property var initSettings: {
        Qt.application.organization = "glyphForge"
        Qt.application.domain = "glyphForge.de"
        Qt.application.name = "GlyphForge"
    }

    property string qmlIconFilePath: ""
    property string qmlIconsFolder: ""

    property bool autoUpdateEnabled: false
    property int autoUpdateInterval: 6

    property bool sideBarVisbile: true

    property bool isDarkMode: true

    property date lastScanTime: new Date()

    property string accent: Material.color(Material.Red)

    property string qmlFilePath: ""
    property string qmlSelectedFilePath: ""
    property string iconsFolderPath: ""
    property string projectScanPath: ""
    property string iconsPath: ""
    property bool showIconDetails: true
    property int scanElapsedMs: 0

    Component.onCompleted: {
        Theme.isDarkMode = isDarkMode;
    }
}
