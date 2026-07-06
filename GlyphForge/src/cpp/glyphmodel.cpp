#include "glyphmodel.h"

GlyphModel::GlyphModel(QObject *parent)
    : QAbstractListModel{parent}
{}

int GlyphModel::rowCount(const QModelIndex &parent) const
{
    if ( parent.isValid() )
        return 0;
    return m_glyphs.size();
}

int GlyphModel::count() const { return m_glyphs.size(); }

QVariant GlyphModel::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() ) {
        return {};
    }

    if ( index.row() < 0 || index.row() >= m_glyphs.size() ) {
        return {};
    }

    const Glyph &glyph = m_glyphs.at(index.row());

    switch (role) {
    case BaseNameRole:          return glyph.baseName;
    case FileNameRole:          return glyph.fileName;
    case RelativePathRole:      return glyph.relativePath;
    case FormatRole:            return glyph.format;
    case AbsoluteFilePathRole:  return glyph.absoluteFilePath;
    case FileSizeRole:          return glyph.fileSize;
    case ResolutionWidthRole:   return glyph.resolutionWidth;
    case ResolutionHeightRole:  return glyph.resolutionHeight;
    case UsedRole:              return glyph.used;
    case UsedInFilesRole:       return glyph.usedInFiles;
    default:                    return {};
    }
}

QHash<int, QByteArray> GlyphModel::roleNames() const
{
    return {
             { BaseNameRole, "baseName" },
             { FileNameRole, "fileName" },
             { RelativePathRole, "relativePath" },
             { FormatRole, "format" },
             { AbsoluteFilePathRole, "absoluteFilePath" },
             { FileSizeRole, "fileSize" },
             { ResolutionWidthRole, "resolutionWidth" },
             { ResolutionHeightRole, "resolutionHeight" },
             { UsedRole, "used" },
             { UsedInFilesRole, "usedInFiles" },

             };
}

bool GlyphModel::append(const QVariantMap &glyph)
{
    return append(fromMap( glyph ) );
}

bool GlyphModel::append(const Glyph &glyph)
{
    if ( glyph.baseName.isEmpty() )
        return false;

    if ( m_basesNames.contains(glyph.baseName))
        return false;

    const int row = m_glyphs.size();

    beginInsertRows(QModelIndex(), row, row);
    m_glyphs.append( glyph );
    m_basesNames.insert(glyph.baseName);
    endInsertRows();

    emit countChanged();
    return true;
}

bool GlyphModel::remove(int index)
{
    if ( index < 0 || index >= m_glyphs.size() )
        return false;

    beginRemoveRows(QModelIndex(), index, index);
    m_basesNames.remove( m_glyphs.at(index).baseName );
    m_glyphs.removeAt(index);
    endRemoveRows();

    emit countChanged();
    return true;
}

void GlyphModel::setUsed(int index, bool used)
{
    if ( index < 0 || index >= m_glyphs.size() )
        return;

    if ( m_glyphs[index].used == used )
        return;

    m_glyphs[index].used = used;
    const QModelIndex modelIndex = this->index(index, 0);
    emit dataChanged( modelIndex, modelIndex, { UsedRole } );

}

bool GlyphModel::clearUsedInFiles(int index)
{
    if ( index < 0 || index >= m_glyphs.size() )
        return false;

    if ( m_glyphs[index].usedInFiles.isEmpty() )
        return false;

    m_glyphs[index].usedInFiles.clear();

    const QModelIndex modelIndex = this->index(index, 0);
    emit dataChanged(modelIndex, modelIndex, { UsedInFilesRole });

    return true;
}

bool GlyphModel::addUsedInFile(int index, const QString &absoluteFilePath)
{
    if ( index < 0 || index >= m_glyphs.size() )
        return false;

    if ( m_glyphs[index].usedInFiles.contains(absoluteFilePath) )
        return false;

    m_glyphs[index].usedInFiles.append(absoluteFilePath);

    const QModelIndex modelIndex = this->index(index, 0);
    emit dataChanged(modelIndex, modelIndex, { UsedInFilesRole });

    return true;
}

QVariantMap GlyphModel::get(int index) const
{
    if ( index < 0 || index >= m_glyphs.size() )
        return {};

    return toMap(m_glyphs.at(index));
}

Glyph GlyphModel::glyphAt(int index) const { return m_glyphs.at(index); }

bool GlyphModel::contains(const QString &baseName) const { return m_basesNames.contains(baseName); }

void GlyphModel::clear()
{
    if ( m_glyphs.isEmpty() )
        return;

    beginResetModel();
    m_glyphs.clear();
    m_basesNames.clear();
    endResetModel();
    emit countChanged();
}


QVariantMap GlyphModel::toMap(const Glyph &glyph) const
{
    return {
        { "baseName", glyph.baseName },
        { "fileName", glyph.fileName },
        { "relativePath", glyph.relativePath },
        { "format", glyph.format },
        { "absoluteFilePath", glyph.absoluteFilePath },
        { "fileSize", glyph.fileSize },
        { "resolutionWidth", glyph.resolutionWidth },
        { "resolutionHeight", glyph.resolutionHeight },
        { "used", glyph.used },
        { "usedInFiles", glyph.usedInFiles }
    };
}

Glyph GlyphModel::fromMap(const QVariantMap &glyph) const
{
    return {
        glyph.value("baseName").toString(),
        glyph.value("fileName").toString(),
        glyph.value("relativePath").toString(),
        glyph.value("format").toString(),
        glyph.value("absoluteFilePath").toString(),
        glyph.value("fileSize").toDouble(),
        glyph.value("resolutionWidth").toInt(),
        glyph.value("resolutionHeight").toInt(),
        glyph.value("used").toBool(),
        glyph.value("usedInFiles").toStringList(),
    };
}






































