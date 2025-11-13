#ifndef DISPLAYMANAGER_H
#define DISPLAYMANAGER_H

#include <QObject>
#include <QStringList>

class DisplayManager : public QObject
{
    Q_OBJECT
    
public:
    explicit DisplayManager(QObject *parent = nullptr);
    
    Q_INVOKABLE QStringList getAvailableDisplays();
    Q_INVOKABLE bool configureSecondDisplay(QString displayName);
    Q_INVOKABLE QString getPrimaryDisplay();
    
signals:
    void displaysDetected(QStringList displays);
    void configurationSuccess();
    void configurationError(QString error);
    
private:
    QStringList parseXrandrOutput(const QString &output);
    bool updateVruiConfig(const QString &displayName);
    QString getVruiConfigPath();
};

#endif // DISPLAYMANAGER_H
