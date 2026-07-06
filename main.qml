import QtQuick
import QtQuick.Controls
import "GlyphForge"
Window {
    id: window
    width: Theme.width
    height: Theme.height
    minimumWidth: 584
    minimumHeight: 600

    visible: true
    title: Theme.title

    Material.theme: Theme.isDarkMode ? Material.Dark : Material.Light

    GlyphForge { anchors.fill: parent }

}

