#include "glyphscanner.h"

#include "fileutils.h"

#include <QRegularExpression>
#include <QTimer>

GlyphScanner::GlyphScanner(QObject *parent)
    : QObject{parent}
{
    m_folderBlackList << "build" << "src" << ".qtcreator";
}

GlyphManager *GlyphScanner::manager() const
{
    return m_manager;
}

void GlyphScanner::setManager(GlyphManager *newManager)
{
    if (m_manager == newManager)
        return;
    m_manager = newManager;
    emit managerChanged();
}

void GlyphScanner::scan()
{
    resetCounts();
    m_availableFiles.clear();
    m_scanFileIndex = 0;

    if ( !m_projectScanDir.exists() ) {
        return;
    }

    if ( m_manager->iconFilePath().isEmpty() ) {
        return;
    }

    m_scanning = true;
    m_scanElapsedMs = 0;
    m_scanTimer.restart();
    emit scanningChanged();

    m_iconsBaseName = QFileInfo(m_manager->iconFilePath()).baseName();

    for ( int i = 0; i < m_manager->model()->count(); ++i ) {
        m_manager->model()->setUsed(i, false);
        m_manager->model()->clearUsedInFiles(i);
    }

    fetchAvailableFiles(m_projectScanDir);
    processScanBatch();
}

void GlyphScanner::fetchAvailableFiles(const QDir &dir)
{
    const auto entries = dir.entryInfoList( QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot );
    for ( const auto &entry: entries ) {
        if ( entry.isDir() ) {
            if ( m_folderBlackList.contains(entry.baseName()) || entry.baseName().isEmpty())
                continue;
            const QString content = FileUtils::read(entry.absoluteFilePath());
            fetchAvailableFiles( QDir(entry.absoluteFilePath()) );
        }

        else if ( ( entry.suffix().toLower() == "qml" || entry.suffix().toLower() == "cpp" ) && entry.absoluteFilePath() != m_manager->iconFilePath()) {

            const QString content = FileUtils::read(entry.absoluteFilePath());
            if ( content.isEmpty() )
                continue;
            m_availableFiles.append(entry.absoluteFilePath());
        }
    }


}

void GlyphScanner::processScanBatch()
{
    int count = 0;

    while ( count < m_scanBatchSize && m_scanFileIndex < m_availableFiles.size() ) {
        const QString absoluteFilePath = m_availableFiles.at(m_scanFileIndex);
        const QString content = FileUtils::read(absoluteFilePath);

        if ( !content.isEmpty() ) {
            const QString pattern = QString(R"(\b%1\s*\.\s*([A-Za-z_][A-Za-z0-9_]*)\b)")
            .arg(QRegularExpression::escape(m_iconsBaseName));

            const QRegularExpression regularExpression(pattern);
            QRegularExpressionMatchIterator iterator = regularExpression.globalMatch(content);

            while ( iterator.hasNext() ) {
                const QRegularExpressionMatch match = iterator.next();
                const QString baseName = match.captured(1);

                for ( int i = 0; i < m_manager->model()->count(); ++i ) {
                    const Glyph glyph = m_manager->model()->glyphAt(i);

                    if ( glyph.baseName == baseName ) {
                        m_manager->model()->setUsed(i, true);
                        m_manager->model()->addUsedInFile(i, absoluteFilePath);
                        break;
                    }
                }

            }
            for ( int i = 0; i < m_manager->model()->count(); ++i ) {
                const Glyph glyph = m_manager->model()->glyphAt(i);
                if ( content.contains(glyph.fileName) ) {
                    m_manager->model()->setUsed(i, true);
                    m_manager->model()->addUsedInFile(i, absoluteFilePath);
                }
            }
        }

        ++m_scanFileIndex;
        ++count;
    }

    if ( m_scanFileIndex < m_availableFiles.size() ) {
        QTimer::singleShot(10, this, &GlyphScanner::processScanBatch);
    } else {
        runCounting();
        m_scanning = false;
        m_scanElapsedMs = m_scanTimer.elapsed();
        emit scanningChanged();
    }
}

void GlyphScanner::runCounting()
{
    for ( int i = 0; i < m_manager->model()->count(); ++i ) {
        const Glyph glyph = m_manager->model()->glyphAt(i);

        if ( glyph.used )
            ++m_used;
        else {
            ++m_unused;
            m_sizeUnused += glyph.fileSize;
        }

        if ( glyph.format.toLower() == "png" )
            ++m_pngCount;
        else
            ++m_svgCount;

        m_sizeTotal += glyph.fileSize;
    }

    emit countsChanged();
}

void GlyphScanner::resetCounts()
{
    m_used = 0;
    m_unused = 0;
    m_pngCount = 0;
    m_svgCount = 0;
    m_sizeTotal = 0;
    m_sizeUnused = 0;
    emit countsChanged();
}

bool GlyphScanner::scanning() const { return m_scanning; }
int GlyphScanner::sizeUnused() const { return m_sizeUnused; }
qint64 GlyphScanner::scanElapsedMs() const { return m_scanElapsedMs; }
int GlyphScanner::sizeTotal() const { return m_sizeTotal; }
int GlyphScanner::svgCount() const { return m_svgCount; }
int GlyphScanner::pngCount() const { return m_pngCount; }
int GlyphScanner::unused() const { return m_unused; }
int GlyphScanner::used() const { return m_used; }



QString GlyphScanner::projectScanPath() const
{
    return m_projectScanPath;
}

void GlyphScanner::setProjectScanPath(const QString &projectScanPath)
{
    if (m_projectScanPath == projectScanPath)
        return;

    const QString path = QUrl(projectScanPath).toLocalFile();
    const QDir dir(path);
    const auto entries = dir.entryInfoList( {"*.qmlproject", "*.pro", "CMakeLists.txt"}  );
    const bool exists = dir.exists( );
    const bool valid = entries.length() > 0;

    if ( m_projectScanPathExists != exists ) {
        m_projectScanPathExists = exists;
        emit projectScanPathExistsChanged();
    }

    if ( m_isValidProjectPath != valid ) {
        m_isValidProjectPath = valid;
        emit isValidProjectPathChanged();
    }

    if ( !exists ) {
        return;
    }
    m_projectScanDir = dir;
    m_projectScanPath = path;
    emit projectScanPathChanged();
    qDebug() << "GlyphScanner::setProjectScanPath" << path;
}

bool GlyphScanner::projectScanPathExists() const { return m_projectScanPathExists; }

bool GlyphScanner::isValidProjectPath() const { return m_isValidProjectPath; }




