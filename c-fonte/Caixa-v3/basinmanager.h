// ~/see-my-design-qml/basinmanager.h
// Header do gerenciador de bacias hidrográficas

#ifndef BASINMANAGER_H
#define BASINMANAGER_H

#include <QObject>
#include <QString>
#include <QStringList>

class QQmlEngine;

class BasinManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int selectedBasin READ selectedBasin WRITE setSelectedBasin NOTIFY selectedBasinChanged)
    Q_PROPERTY(QString selectedBasinName READ selectedBasinName NOTIFY selectedBasinNameChanged)
    Q_PROPERTY(QString currentBasinPath READ currentBasinPath NOTIFY currentBasinPathChanged)

public:
    explicit BasinManager(QObject *parent = nullptr);
    ~BasinManager();

    // Getters
    int selectedBasin() const { return m_selectedBasin; }
    QString selectedBasinName() const { return m_selectedBasinName; }
    QString currentBasinPath() const { return m_currentBasinPath; }
    
    // Setters
    void setSelectedBasin(int basin);
    
    // Engine QML
    void setQmlEngine(QQmlEngine *engine) { m_engine = engine; }
    
    // Métodos públicos invocáveis do QML
    Q_INVOKABLE void loadBasin(int basinIndex);
    Q_INVOKABLE void projectBasin();
    Q_INVOKABLE void visualizeBasin();
    Q_INVOKABLE void validateBasin();
    Q_INVOKABLE QString getBasinImagePath(int basinIndex);
    Q_INVOKABLE QString getProjectRoot();

signals:
    // Sinais de mudança de propriedades
    void selectedBasinChanged(int basin);
    void selectedBasinNameChanged(QString name);
    void currentBasinPathChanged(QString path);
    
    // Sinais de eventos
    void basinLoaded(int index, QString name);
    void basinProjected();
    void basinError(QString error);
    void validationResult(int percentage);
    void logMessage(QString message, QString type);
    
    // NOVOS SINAIS para validação visual
    void validationProgress(QString stage, int progress);
    void captureReady(QString capturePath);
    void differenceReady(QString differencePath);

private:
    // Métodos privados
    void log(const QString &message, const QString &type = "info");
    void captureScreen();
    int compareImages(const QString &original, const QString &captured);
    
    // Variáveis privadas
    int m_selectedBasin;
    QString m_selectedBasinName;
    QString m_currentBasinPath;
    QQmlEngine *m_engine;
    
    // Listas de bacias
    QStringList m_basinFiles;
    QStringList m_basinNames;
};

#endif // BASINMANAGER_H
