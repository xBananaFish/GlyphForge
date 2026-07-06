#ifndef GLYPHMODEL_H
#define GLYPHMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "glyph.h"

class GlyphModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count  NOTIFY countChanged FINAL)
public:
    enum GlyphRoles {
        BaseNameRole = Qt::UserRole + 1,
        FileNameRole,
        RelativePathRole,
        FormatRole,
        AbsoluteFilePathRole,
        FileSizeRole,
        ResolutionWidthRole,
        ResolutionHeightRole,
        UsedRole,
        UsedInFilesRole
    };

    explicit GlyphModel(  QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int count() const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    bool append( const Glyph &glyph );
    Q_INVOKABLE bool append( const QVariantMap &glyph );
    Q_INVOKABLE bool remove(int index);
    Q_INVOKABLE void setUsed(int index, bool used);
    Q_INVOKABLE bool clearUsedInFiles(int index);
    Q_INVOKABLE bool addUsedInFile(int index, const QString &absoluteFilePath);

    Q_INVOKABLE QVariantMap get(int index) const;
    Glyph glyphAt(int index) const;
    Q_INVOKABLE bool contains(const QString &baseName) const;
    Q_INVOKABLE void clear();

signals:
    void countChanged();

private:
    QVariantMap toMap( const Glyph &glyph) const;
    Glyph fromMap(const QVariantMap &glyph) const;
private:
    QList<Glyph> m_glyphs;
    QSet<QString> m_basesNames;
};

#endif // GLYPHMODEL_H
