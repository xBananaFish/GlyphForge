import QtQuick

import QtQuick.Controls
import QtQuick.Layouts


GridLayout {
    id: iconInfoSizes
    rowSpacing: 8
    columnSpacing: 8
    columns: 2

    property real sizeTotal: 0
    property real sizeUnused: 0
    
    Behavior on sizeTotal { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    Behavior on sizeUnused { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    Label {
        text: qsTr("Größen")
        font.bold: true
        Layout.columnSpan: 2
        Layout.fillWidth: true
    }
    
    Label {
        opacity: 0.751
        text: qsTr("Gesamt")
        font.pointSize: 10
        leftPadding: 16
        Layout.fillWidth: true
    }
    Label {
        id: sizeTotal
        text: parseFloat( iconInfoSizes.sizeTotal.toFixed(2) ) + " KB"
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.pointSize: 10
        font.bold: true
    }
    
    Label {
        opacity: 0.751
        text: qsTr("Größe der unbenutzten Icons")
        font.pointSize: 10
        leftPadding: 16
        Layout.fillWidth: true
    }
    
    Label {
        id: sizeUnused
        text: parseFloat( iconInfoSizes.sizeUnused.toFixed(2) ) + " KB"
        horizontalAlignment: Text.AlignRight
        Layout.preferredWidth: 50
        font.pointSize: 10
        font.bold: false
    }    
}
