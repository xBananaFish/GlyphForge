import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import QtCore

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
}
