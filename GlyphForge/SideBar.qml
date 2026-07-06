import QtQuick

import QtQuick.Controls
import QtQuick.Layouts
import QtCore

ScrollView {
    id: sideBar
    anchors.left: parent.left
    anchors.top: menuPane.bottom
    anchors.bottom: parent.bottom
    anchors.leftMargin: settings.sideBarVisbile ? 8 : -width
    anchors.topMargin: 8
    anchors.bottomMargin: 8

    Behavior on anchors.leftMargin { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    
    NumberAnimation on anchors.topMargin { from: 300; to: 8; duration: 750; easing.type: "InOutQuad" }
    NumberAnimation on anchors.bottomMargin { from: -300; to: 8; duration: 750; easing.type: "InOutQuad" }
    NumberAnimation on opacity { from: 0; to: 1; duration: 750; easing.type: "InOutQuad" }

    width: glyphForge.width < 1200 ? 320 :  444
    contentHeight: columnLayout.implicitHeight + 8
    contentWidth: columnLayout.width
    ScrollBar.vertical: ScrollBar {
        width: 12
        policy: "AsNeeded"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
    
    ColumnLayout {
        id: columnLayout
        x: 0
        y: 0
        width: sideBar.width - 12
        spacing: 8
        PathPanel { id: pathPanel }
        UpdatePanel { id: updatePanel }
        IconInfo { id: iconInfo }
    }
}
