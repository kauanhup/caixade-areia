#ifndef BASINMANAGER_H
#define BASINMANAGER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <QQmlApplicationEngine>

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
    void setQmlEngine(QQmlApplicationEngine *engine) { m_engine = engine; }
    
    // Métodos invocáveis do QML
    Q_INVOKABLE void loadBasin(int basinIndex);
    Q_INVOKABLE void projectBasin();
    Q_INVOKABLE void visualizeBasin();
    Q_INVOKABLE void validateBasin();
    Q_INVOKABLE QString getBasinImagePath(int basinIndex);
    
signals:
    void selectedBasinChanged(int basin);
    void selectedBasinNameChanged(QString name);
    void currentBasinPathChanged(QString path);
    void basinLoaded(int index, QString name);
    void basinProjected();
    void basinError(QString error);
    void validationResult(int percentage);
    void logMessage(QString message, QString type); // novo sinal para logs
    
private:
    int m_selectedBasin;
    QString m_selectedBasinName;
    QString m_currentBasinPath;
    QQmlApplicationEngine *m_engine;
    
    // Nomes dos modelos de nascentes
    QStringList m_basinNames = {
        "Modelo 1 - Nascente Difusa",
        "Modelo 2 - Nascente Pontual", 
        "Modelo 3 - Nascente em Encosta",
        "Modelo 4 - Nascente em Vale",
        "Modelo 5 - Nascente Múltipla",
        "Modelo 6 - Nascente em Planície"
    };
    
    // Arquivos das nascentes
    QStringList m_basinFiles = {
        "modelo_1.png",
        "modelo_2.png",
        "modelo_3.png",
        "modelo_4.png",
        "modelo_5.png",
        "modelo_6.png"
    };
    
    QString getProjectRoot();
    void captureScreen();
    int compareImages(const QString &original, const QString &captured);
    void log(const QString &message, const QString &type = "info");
};

#endif // BASINMANAGER_H
