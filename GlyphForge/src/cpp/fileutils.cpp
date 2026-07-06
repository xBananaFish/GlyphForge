#include "fileutils.h"



QString FileUtils::read(const QString &path)
{
    QFile file(path);

    if ( !file.open(QIODevice::ReadOnly | QIODevice::Text ) ) {
        return {};
    }

    QString content = QString::fromUtf8(file.readAll());
    return content;
}

bool FileUtils::write(const QString &path, const QString &content)
{
    QFile file(path);

    if ( !file.open(QIODevice::WriteOnly | QIODevice::Text ) ) {
        return false;
    }

    file.write(content.toUtf8());
    return true;
}
