#ifndef FILEUTILS_H
#define FILEUTILS_H

#include <QFile>

class FileUtils
{
public:
    static QString read( const QString &path );
    static bool write( const QString &path, const QString &content );
};

#endif // FILEUTILS_H
