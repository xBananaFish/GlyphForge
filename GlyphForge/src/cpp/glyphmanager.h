#ifndef GLYPHMANAGER_H
#define GLYPHMANAGER_H

#include "glyphmodel.h"

#include <QDir>
#include <QObject>
#include <QUrl>

class GlyphManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString folderPath READ folderPath WRITE setFolderPath NOTIFY folderPathChanged FINAL)
    Q_PROPERTY(QString iconFilePath READ iconFilePath WRITE setIconFilePath NOTIFY iconFilePathChanged FINAL)

    Q_PROPERTY(bool folderPathExists READ folderPathExists NOTIFY folderPathExistsChanged FINAL)
    Q_PROPERTY(bool iconFilePathExists READ iconFilePathExists NOTIFY iconFilePathExistsChanged FINAL)
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged FINAL)

    Q_PROPERTY(GlyphModel* model READ model CONSTANT FINAL)

public:
    explicit GlyphManager(QObject *parent = nullptr);

    bool folderPathExists() const;
    QString folderPath() const;
    void setFolderPath(const QString &folderPath);

    bool iconFilePathExists() const;
    QString iconFilePath() const;
    void setIconFilePath(const QString &iconFilePath);
    GlyphModel *model();

    Q_INVOKABLE void addGlyph( const QString &sourcePath );
    Q_INVOKABLE void removeGlyph( int index );
    Q_INVOKABLE void refresh();
    Q_INVOKABLE QUrl fromLocalFile( const QString &absoluteFilePath ) const;
    Q_INVOKABLE void writeCollectedIconsContent();

    bool refreshing() const;

signals:
    void folderPathExistsChanged();
    void folderPathChanged();
    void iconFilePathExistsChanged();
    void iconFilePathChanged();
    void refreshingChanged();
    void refreshFinished();

private:
    void preloadGlyphs();
    void writeInIconsFile( const QString &content);
    QString iconString(const Glyph &glyph) const;
    Glyph createGlyph(const QFileInfo &entry);

private:
    QList<Glyph> m_glyphs;
    QString m_folderPath;
    QString m_iconFilePath;
    QString m_iconsContent;
    QDir m_qmlDir;
    GlyphModel m_model;
    int m_batchSize = 1;
    int m_preloadIndex = 0;
    bool m_folderPathExists = false;
    bool m_iconFilePathExists = false;
    bool m_refreshing = false;
};

#endif // GLYPHMANAGER_H
