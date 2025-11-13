#include "sandboxmanager.h"
#include <QDebug>
#include <QDir>
#include <QTimer>

SandboxManager::SandboxManager(QObject *parent)
    : QObject(parent)
    , sandboxProcess(nullptr)
    , currentMode("")
{
}

void SandboxManager::openSandbox2D()
{
    if (sandboxProcess && sandboxProcess->state() == QProcess::Running) {
        qWarning() << "Sandbox already running!";
        emit sandboxError("Sandbox já está rodando! Feche antes de abrir outro.");
        return;
    }
    
    sandboxProcess = new QProcess(this);
    currentMode = "2D";
    
    // Configurar working directory
    sandboxProcess->setWorkingDirectory(QDir::homePath() + "/src/SARndbox-2.8");
    
    // Conectar sinais
    connect(sandboxProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &SandboxManager::onProcessFinished);
    
    connect(sandboxProcess, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        QString errorMsg;
        switch(error) {
            case QProcess::FailedToStart:
                errorMsg = "Falha ao iniciar SARndbox. Verifique se está instalado.";
                break;
            case QProcess::Crashed:
                errorMsg = "SARndbox fechou inesperadamente.";
                break;
            default:
                errorMsg = "Erro desconhecido ao executar SARndbox.";
        }
        emit sandboxError(errorMsg);
        qWarning() << "Erro no processo Sandbox:" << errorMsg;
    });
    
    emit sandboxStarted("2D");
    qDebug() << "Iniciando Sandbox 2D...";
    
    // Timer de segurança
    QTimer::singleShot(3000, this, [this]() {
        if (sandboxProcess && sandboxProcess->state() != QProcess::Running) {
            emit sandboxError("Sandbox 2D não iniciou. Verifique o Kinect.");
        }
    });
    
    // MODO 2D: Vista de cima, travada no projetor
    // -uhm = usar mapa de cores padrão
    // -fpv = travar câmera na calibração do projetor (fixed projector view)
    sandboxProcess->start("bash", QStringList() << "-c" << "./bin/SARndbox -uhm -fpv");
}

void SandboxManager::openSandbox3D()
{
    if (sandboxProcess && sandboxProcess->state() == QProcess::Running) {
        qWarning() << "Sandbox already running!";
        emit sandboxError("Sandbox já está rodando! Feche antes de abrir outro.");
        return;
    }
    
    sandboxProcess = new QProcess(this);
    currentMode = "3D";
    
    // Configurar working directory
    sandboxProcess->setWorkingDirectory(QDir::homePath() + "/src/SARndbox-2.8");
    
    // Conectar sinais
    connect(sandboxProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &SandboxManager::onProcessFinished);
    
    connect(sandboxProcess, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        QString errorMsg;
        switch(error) {
            case QProcess::FailedToStart:
                errorMsg = "Falha ao iniciar SARndbox. Verifique se está instalado.";
                break;
            case QProcess::Crashed:
                errorMsg = "SARndbox fechou inesperadamente.";
                break;
            default:
                errorMsg = "Erro desconhecido ao executar SARndbox.";
        }
        emit sandboxError(errorMsg);
        qWarning() << "Erro no processo Sandbox:" << errorMsg;
    });
    
    emit sandboxStarted("3D");
    qDebug() << "Iniciando Sandbox 3D...";
    
    // Timer de segurança
    QTimer::singleShot(3000, this, [this]() {
        if (sandboxProcess && sandboxProcess->state() != QProcess::Running) {
            emit sandboxError("Sandbox 3D não iniciou. Verifique o Kinect e segunda tela.");
        }
    });
    
    // MODO 3D: Projetor fixo + segunda janela 3D navegável
    // -uhm = mapa de cores
    // -fpv = janela principal travada no projetor
    // -wi 1 = próximas opções só pra Window2 (segunda janela)
    // -rws = água em 3D realista (render water surface)
    sandboxProcess->start("bash", QStringList() << "-c" << "./bin/SARndbox -uhm -fpv -wi 1 -rws");
}

void SandboxManager::stopSandbox()
{
    if (sandboxProcess && sandboxProcess->state() == QProcess::Running) {
        qDebug() << "Parando Sandbox...";
        sandboxProcess->terminate();
        
        // Se não parar em 3 segundos, força
        QTimer::singleShot(3000, this, [this]() {
            if (sandboxProcess && sandboxProcess->state() == QProcess::Running) {
                sandboxProcess->kill();
            }
        });
    }
}

void SandboxManager::onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "Sandbox" << currentMode << "finished. Exit code:" << exitCode;
    
    if (exitStatus != QProcess::NormalExit || exitCode != 0) {
        emit sandboxError(QString("Sandbox %1 fechou com erro.").arg(currentMode));
    } else {
        emit sandboxStopped();
    }
    
    sandboxProcess->deleteLater();
    sandboxProcess = nullptr;
    currentMode = "";
}
