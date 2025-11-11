#ifndef DISPLAYMANAGER_H
#define DISPLAYMANAGER_H

#include <QObject>
#include <QStringList>

class DisplayManager : public QObject
{
    Q_OBJECT  // <- ESSENCIAL pro Qt gerar a vtable

public:
    explicit DisplayManager(QObject *parent = nullptr);

    QStringList getAvailableDisplays();
    QString getPrimaryDisplay();
    QString getVruiConfigPath();
    bool configureSecondDisplay(QString displayName);

signals:
    void displaysDetected(QStringList displays);
    void configurationSuccess();
    void configurationError(QString error);

private:
    QStringList parseXrandrOutput(const QString &output);
};

#endif // DISPLAYMANAGER_H

