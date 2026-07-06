pragma Singleton
import QtQuick

QtObject {
	property string title: "GlyphForge"
	property int width: 1600
	property int height: 1100

	property bool isDarkMode: true

	property color background:			isDarkMode ? "#1e2227" : "#f7fafc"
	property color backgroundAlt:		isDarkMode ? "#20252a" : "#f0f3f5"
	property color backgroundMutetd:	isDarkMode ? "#23282e" : "#eaedef"
	property color border:				isDarkMode ? "#262c32" : "#e4e7e9"
	property color foreground:			isDarkMode ? "#f7fafc" : "#1e2227"

	property QtObject fontSize: QtObject {
		property int small: 8
		property int control: 10
		property int medium: 12
		property int header: 16
		property int title: 18
		property int large: 24
		property int huge: 32
	}
}
