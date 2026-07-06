import QtQuick

import QtQuick.Controls
import QtQuick.Layouts


GridLayout {
    id: iconInfoCounts
    property int total: 0
    property int used: 0
    property int unused: 0
    property int pngCount: 0
    property int svgCount: 0

    Behavior on total { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on used { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on unused { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on pngCount { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on svgCount { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    rowSpacing: 8
    columnSpacing: 8
    columns: 2
    
    Label {
        text: qsTr("Gesamt")
        font.bold: true
        Layout.fillWidth: true
        Layout.columnSpan: 2
    }
    
    Label {
        opacity: 0.747
        text: qsTr("Anzahl")
        font.pointSize: 10
        Layout.leftMargin: 16
        Layout.fillWidth: true
    }
    
    Label {
        id: total
        text: iconInfoCounts.total
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.bold: true
        font.pointSize: 10
    }
    
    
    Label {
        opacity: 0.747
        text: qsTr("davon benutzt")
        font.pointSize: 10
        leftPadding: 16
        Layout.fillWidth: true
    }
    
    Label {
        id: used
        text: iconInfoCounts.used
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.pointSize: 10
    }
    
    Label {
        opacity: 0.747
        text: qsTr("davon nicht benutzt")
        font.pointSize: 10
        leftPadding: 16
        Layout.fillWidth: true
    }
    
    Label {
        id: unused
        text: iconInfoCounts.unused
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.pointSize: 10
    }
    
    
    Label {
        opacity: 0.747
        text: qsTr("davon PNG's")
        font.pointSize: 10
        leftPadding: 16
        Layout.fillWidth: true
    }
    
    Label {
        id: pngCount
        text: iconInfoCounts.pngCount
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.pointSize: 10
        font.bold: false
    }
    
    Label {
        opacity: 0.747
        text: qsTr("davon SVG's")
        font.pointSize: 10
        leftPadding: 16
        Layout.fillWidth: true
    }
    
    Label {
        id: svgCount
        text: iconInfoCounts.svgCount
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.pointSize: 10
        font.bold: false
    }
}
