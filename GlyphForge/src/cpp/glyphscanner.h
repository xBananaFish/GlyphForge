#ifndef GLYPHSCANNER_H
#define GLYPHSCANNER_H

#include "glyphmanager.h"
#include <QElapsedTimer>
#include <QObject>

class GlyphScanner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(GlyphManager *manager READ manager WRITE setManager NOTIFY managerChanged FINAL)
    Q_PROPERTY(QString projectScanPath READ projectScanPath WRITE setProjectScanPath NOTIFY projectScanPathChanged FINAL)
    Q_PROPERTY(bool projectScanPathExists READ projectScanPathExists NOTIFY projectScanPathExistsChanged FINAL)
    Q_PROPERTY(bool isValidProjectPath READ isValidProjectPath NOTIFY isValidProjectPathChanged FINAL)
    Q_PROPERTY(bool scanning READ scanning NOTIFY scanningChanged FINAL)

    Q_PROPERTY(int used READ used NOTIFY countsChanged FINAL)
    Q_PROPERTY(int unused READ unused NOTIFY countsChanged FINAL)
    Q_PROPERTY(int pngCount READ pngCount NOTIFY countsChanged FINAL)
    Q_PROPERTY(int svgCount READ svgCount NOTIFY countsChanged FINAL)
    Q_PROPERTY(int sizeTotal READ sizeTotal NOTIFY countsChanged FINAL)
    Q_PROPERTY(int sizeUnused READ sizeUnused NOTIFY countsChanged FINAL)
    Q_PROPERTY(qint64 scanElapsedMs READ scanElapsedMs NOTIFY scanningChanged FINAL)

public:
    explicit GlyphScanner(QObject *parent = nullptr);

    GlyphManager *manager() const;
    void setManager(GlyphManager *newManager);

    Q_INVOKABLE void scan();

    QString projectScanPath() const;
    void setProjectScanPath(const QString &projectScanPath);
    bool projectScanPathExists() const;
    bool isValidProjectPath() const;

    int used() const;
    int unused() const;
    int pngCount() const;
    int svgCount() const;
    int sizeTotal() const;
    int sizeUnused() const;
    qint64 scanElapsedMs() const;

    bool scanning() const;

signals:
    void managerChanged();
    void projectScanPathChanged();
    void projectScanPathExistsChanged();
    void isValidProjectPathChanged();
    void countsChanged();
    void scanningChanged();

private:
    void fetchAvailableFiles(const QDir &dir);
    void processScanBatch();
    void runCounting();
    void resetCounts();
    void emitCounts();

private:
    GlyphManager *m_manager = nullptr;
    QString m_projectScanPath;
    QString m_iconsBaseName;
    QStringList m_availableFiles;
    QStringList m_folderBlackList;
    QDir m_projectScanDir;
    QElapsedTimer m_scanTimer;
    qint64 m_scanElapsedMs = 0;

    int m_scanBatchSize = 1;
    int m_scanFileIndex = 0;

    int m_used = 0;
    int m_unused = 0;
    int m_pngCount = 0;
    int m_svgCount = 0;
    int m_sizeTotal = 0;
    int m_sizeUnused = 0;

    bool m_projectScanPathExists = false;
    bool m_isValidProjectPath = false;
    bool m_scanning = false;

};

#endif // GLYPHSCANNER_H
