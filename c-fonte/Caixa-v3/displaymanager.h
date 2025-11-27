#ifndef DISPLAYMANAGER_H
#define DISPLAYMANAGER_H

#include <QObject>
#include <QStringList>

class DisplayManager : public QObject
{
    Q_OBJECT
    
public:
    explicit DisplayManager(QObject *parent = nullptr);
    
    // Métodos públicos invocáveis do QML
    Q_INVOKABLE QStringList getAvailableDisplays();
    Q_INVOKABLE QString getPrimaryDisplay();
    Q_INVOKABLE bool configureSecondDisplay(QString displayName);
    Q_INVOKABLE QString getVruiConfigPath();
    
signals:
    void displaysDetected(QStringList displays);
    void configurationSuccess();
    void configurationError(QString error);
    
private:
    QStringList parseXrandrOutput(const QString &output);
};

#endif // DISPLAYMANAGER_H
