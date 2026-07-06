import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


GridLayout {
    id: iconInfoScan
    rowSpacing: 8
    columnSpacing: 8
    columns: 2
    
    
    Label {
        text: qsTr("Letzter Scan")
        Layout.columnSpan: 2
        font.bold: true
        Layout.fillWidth: true
    }
    
    Label {
        opacity: 0.751
        text: "Startzeipunkt"
        Layout.leftMargin: 16
        Layout.fillWidth: true
        font.pointSize: 10
    }
    
    Label {
        text: Qt.formatDateTime(settings.lastScanTime)
        horizontalAlignment: Text.AlignRight
        Layout.leftMargin: 16
        Layout.fillWidth: true
        font.pointSize: 10
        font.bold: true
    }
    
    Label {
        opacity: 0.751
        text: "Dauer"
        Layout.leftMargin: 16
        Layout.fillWidth: true
        font.pointSize: 10
    }
    
    Label {
        text: `${settings.scanElapsedMs} ms`
        horizontalAlignment: Text.AlignRight
        Layout.leftMargin: 16
        Layout.fillWidth: true
        
        font.pointSize: 10
        font.bold: true
    }
    
}
