#ifndef SANDBOXMANAGER_H
#define SANDBOXMANAGER_H

#include <QObject>
#include <QProcess>

class SandboxManager : public QObject
{
    Q_OBJECT
    
public:
    explicit SandboxManager(QObject *parent = nullptr);
    
    Q_INVOKABLE void openSandbox2D();
    Q_INVOKABLE void openSandbox3D();
    Q_INVOKABLE void stopSandbox();
    
signals:
    void sandboxStarted(QString mode);
    void sandboxStopped();
    void sandboxError(QString error);
    
private slots:
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    
private:
    QProcess *sandboxProcess;
    QString currentMode;
};

#endif // SANDBOXMANAGER_H
