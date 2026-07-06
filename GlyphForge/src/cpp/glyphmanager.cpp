#include "fileutils.h"
#include "glyphmanager.h"
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QImageReader>
#include <QTimer>
#include <QUrl>
GlyphManager::GlyphManager(QObject *parent)
    : QObject{parent}
{

}

bool GlyphManager::folderPathExists() const { return m_folderPathExists; }
QString GlyphManager::folderPath() const { return m_folderPath; }
void GlyphManager::setFolderPath(const QString &folderPath)
{
    if (m_folderPath == folderPath)
        return;

    const QString path = QUrl(folderPath).toLocalFile();
    const bool exists = QDir(path).exists();

    if ( m_folderPathExists != exists ) {
        m_folderPathExists = exists;
        emit folderPathExistsChanged();
    }

    if ( !exists )
        return;

    m_folderPath = path;
    emit folderPathChanged();
}

bool GlyphManager::iconFilePathExists() const { return m_iconFilePathExists; }
QString GlyphManager::iconFilePath() const { return m_iconFilePath; }
void GlyphManager::setIconFilePath(const QString &iconFilePath)
{
    if (m_iconFilePath == iconFilePath)
        return;

    const QString filePath = QUrl(iconFilePath).toLocalFile();
    const bool exists = QFile::exists(filePath);

    if ( m_iconFilePathExists != exists ) {
        m_iconFilePathExists = exists;
        emit iconFilePathExistsChanged();
    }
    if ( !exists ){
        return;
    }

    m_iconFilePath = filePath;
    emit iconFilePathChanged();
}

GlyphModel *GlyphManager::model() { return &m_model; }

void GlyphManager::addGlyph(const QString &sourcePath)
{
    if ( !m_folderPathExists ) {
        return;
    }

    const QString localFile = QUrl(sourcePath).toLocalFile();
    QFileInfo sourceInfo(localFile);

    QDir destinationDir(m_folderPath);
    const QString destinationPath = destinationDir.filePath(sourceInfo.fileName());

    if ( QFile::exists(destinationPath ) ) {

        return;
    }

    if ( !QFile::copy(sourceInfo.absoluteFilePath(), destinationPath) ) {

        return;
    }

    QFileInfo destinationInfo(destinationPath);
    Glyph glyph = createGlyph(destinationInfo);

    if ( m_model.append(glyph) ) {
        m_iconsContent += iconString(glyph);
    }
}

void GlyphManager::removeGlyph(int index)
{
    if ( index < 0 || index >= m_model.count() )
        return;

    const Glyph glyph = m_model.glyphAt(index);
    m_model.remove(index);

    const QString content = FileUtils::read(m_iconFilePath);

    if ( content.isEmpty() ) {
        return;
    }

    QString newContent = content;

    const QString pattern = QString(
        R"(readonly\s+property\s+url\s+%1\s*:\s+Qt.resolvedUrl\(['"][^'"]+['"]\)\s*\n?)"
        ).arg(QRegularExpression::escape(glyph.baseName));

    newContent.remove(QRegularExpression(pattern));

    if ( newContent == content ) {
        return;
    }

    FileUtils::write(m_iconFilePath, newContent);

    if ( QFile::exists(glyph.absoluteFilePath)) {
        QFile::remove(glyph.absoluteFilePath);
    }
}

void GlyphManager::refresh()
{
    QDir iconsDir(m_folderPath);
    const auto entryInfoList = iconsDir.entryInfoList( {"*.png", "*.svg" } );

    m_iconsContent.clear();
    m_model.clear();

    if ( entryInfoList.isEmpty() ) {
        return;
    }

    m_refreshing = true;
    emit refreshingChanged();
    m_qmlDir = QFileInfo(m_iconFilePath).absolutePath();

    for ( const auto &entry : entryInfoList ) {
        m_glyphs.append(createGlyph(entry));
    }

    preloadGlyphs();
}

void GlyphManager::preloadGlyphs()
{
    int count = 0;

    while (count < m_batchSize && m_preloadIndex < m_glyphs.size()) {
        const auto &glypth = m_glyphs.at(m_preloadIndex);
        if ( m_model.append(glypth) ) {
            m_iconsContent += iconString(glypth);
        }
        ++m_preloadIndex;
        ++count;
    }

    if ( m_preloadIndex < m_glyphs.size() ) {
        QTimer::singleShot(10, this, &GlyphManager::preloadGlyphs);
    } else {
        writeInIconsFile(QString("pragma Singleton\nimport QtQuick\n\nQtObject {\n%1}\n").arg(m_iconsContent));
        m_glyphs.clear();
        m_iconsContent.clear();
        m_preloadIndex = 0;
        m_refreshing = false;
        emit refreshingChanged();
    }
}

void GlyphManager::writeInIconsFile(const QString &content)
{
    if ( !m_iconFilePathExists ) {
        return;
    }

    FileUtils::write(m_iconFilePath, content);
}

QString GlyphManager::iconString(const Glyph &glyph) const
{
    return QString("\treadonly property url %1: Qt.resolvedUrl('%2')\n")
        .arg(glyph.baseName, glyph.relativePath);
}

Glyph GlyphManager::createGlyph(const QFileInfo &entry)
{
    Glyph glyph;

    QImageReader reader(entry.absoluteFilePath());
    const QSize resolution = reader.size();
    const double kb = entry.size() / 1024.0;
    const QString relativePath = m_qmlDir.relativeFilePath(entry.absoluteFilePath());

    glyph.baseName = entry.baseName();
    glyph.fileName = entry.fileName();
    glyph.relativePath = relativePath;
    glyph.format = QString::fromLatin1(reader.format());
    glyph.absoluteFilePath = entry.absoluteFilePath();
    glyph.fileSize = kb;
    glyph.resolutionWidth = resolution.width();
    glyph.resolutionHeight = resolution.height();

    return glyph;
}

bool GlyphManager::refreshing() const { return m_refreshing; }
QUrl GlyphManager::fromLocalFile(const QString &absoluteFilePath) const { return QUrl::fromLocalFile(absoluteFilePath); }

void GlyphManager::writeCollectedIconsContent()
{
    if ( !m_iconFilePathExists ) {
        return;
    }

    if ( m_iconsContent.isEmpty() ) {
        return;
    }

    QString content = FileUtils::read(m_iconFilePath);
    const int insertIndex = content.lastIndexOf("}");

    if ( insertIndex < 0 ) {
        return;
    }

    content.insert(insertIndex, m_iconsContent);

    FileUtils::write(m_iconFilePath, content);

    m_iconsContent.clear();
}

































