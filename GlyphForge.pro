QT += quick quickcontrols2

SOURCES += \
        GlyphForge/src/cpp/fileutils.cpp \
        GlyphForge/src/cpp/glyphmanager.cpp \
        GlyphForge/src/cpp/glyphmodel.cpp \
        GlyphForge/src/cpp/glyphscanner.cpp \
        main.cpp

RESOURCES += GlyphForge.qrc
RC_ICONS = GlyphForge/icons/icon.ico
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += "."

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH += "."

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    GlyphForge/src/cpp/fileutils.h \
    GlyphForge/src/cpp/glyph.h \
    GlyphForge/src/cpp/glyphmanager.h \
    GlyphForge/src/cpp/glyphmodel.h \
    GlyphForge/src/cpp/glyphscanner.h
