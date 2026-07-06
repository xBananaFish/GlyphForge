#include "GlyphForge/src/cpp/glyphmanager.h"
#include "GlyphForge/src/cpp/glyphscanner.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/GlyphForge/icons/icon.png"));
    QQuickStyle::setStyle("Material");

    qmlRegisterType<GlyphManager>("Glyphs", 1, 0, "GlyphManager");
    qmlRegisterType<GlyphScanner>("Glyphs", 1, 0, "GlyphScanner");

    QQmlApplicationEngine engine;

    engine.addImportPath(":/");
    const QUrl url(QStringLiteral("qrc:/main.qml"));


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}
