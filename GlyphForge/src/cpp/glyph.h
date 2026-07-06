#ifndef GLYPH_H
#define GLYPH_H

#include <QString>
#include <QStringList>

struct Glyph {
    QString baseName;
    QString fileName;
    QString relativePath;
    QString format;
    QString absoluteFilePath;
    double fileSize;
    int resolutionWidth;
    int resolutionHeight;
    bool used = false;
    QStringList usedInFiles;
};


#endif // GLYPH_H
