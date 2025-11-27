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
    
    sandboxProcess->setWorkingDirectory(QDir::homePath() + "/src/SARndbox-2.8");
    
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
    
    QTimer::singleShot(3000, this, [this]() {
        if (sandboxProcess && sandboxProcess->state() != QProcess::Running) {
            emit sandboxError("Sandbox 2D não iniciou. Verifique o Kinect.");
        }
    });
    
    // MODO 2D: Apenas projetor, vista de cima fixa
    sandboxProcess->start("bash", QStringList() << "-c" 
        << "DISPLAY=:0.0 ./bin/SARndbox -uhm -fpv");
    
    // Fullscreen inteligente
    QTimer *fullscreenTimer = new QTimer(this);
    fullscreenTimer->setInterval(1000);
    int *attemptsPtr = new int(0);
    
    connect(fullscreenTimer, &QTimer::timeout, [this, fullscreenTimer, attemptsPtr]() {
        (*attemptsPtr)++;
        
        QProcess *checkWindow = new QProcess(this);
        checkWindow->start("bash", QStringList() << "-c" 
            << "xdotool search --name \"SARndbox\" 2>/dev/null");
        checkWindow->waitForFinished(500);
        
        QString output = checkWindow->readAllStandardOutput().trimmed();
        checkWindow->deleteLater();
        
        if (!output.isEmpty()) {
            QProcess::execute("bash", QStringList() << "-c" 
                << "WIN_ID=$(xdotool search --name \"SARndbox\" | head -1); "
                   "if [ ! -z \"$WIN_ID\" ]; then wmctrl -i -r $WIN_ID -b add,fullscreen; fi");
            qDebug() << "✅ Fullscreen aplicado no Sandbox 2D após" << *attemptsPtr << "tentativa(s)";
            fullscreenTimer->stop();
            fullscreenTimer->deleteLater();
            delete attemptsPtr;
        } else if (*attemptsPtr >= 10) {
            qWarning() << "❌ Timeout: Janela do Sandbox 2D não encontrada após 10 segundos";
            fullscreenTimer->stop();
            fullscreenTimer->deleteLater();
            delete attemptsPtr;
        } else {
            qDebug() << "⏳ Tentativa" << *attemptsPtr << "- Aguardando janela do Sandbox 2D...";
        }
    });
    
    fullscreenTimer->start();
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
    
    sandboxProcess->setWorkingDirectory(QDir::homePath() + "/src/SARndbox-2.8");
    
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
    qDebug() << "🚀 Iniciando Sandbox 3D (2 janelas)...";
    
    QTimer::singleShot(3000, this, [this]() {
        if (sandboxProcess && sandboxProcess->state() != QProcess::Running) {
            emit sandboxError("Sandbox 3D não iniciou. Verifique Kinect e configuração de displays.");
        }
    });
    
    // ===== MODO 3D CORRETO =====
    // O QUE VOCÊ QUER:
    // Janela 0 (Projetor): Vista 2D fixa de cima + água padrão
    // Janela 1 (Notebook): Vista 3D navegável + água padrão
    //
    // COMANDO CORRETO:
    // ./bin/SARndbox -uhm -fpv -wi 1
    //
    // Explicação:
    // -uhm = mapa de elevação (ambas janelas)
    // -fpv = vista fixa no projetor (só janela 0)
    // -wi 1 = reseta -fpv para janela 1, deixando ela navegável
    //
    // SEM -rws = água padrão (textura 2D) em AMBAS as janelas ✅
    // COM -rws = água 3D realista, mas só fica boa em vista oblíqua
    
    qDebug() << "📺 Janela 0 (Projetor): Vista 2D fixa + água padrão";
    qDebug() << "🖥️ Janela 1 (Notebook): Vista 3D navegável + água padrão";
    
    sandboxProcess->start("bash", QStringList() << "-c" 
        << "./bin/SARndbox -uhm -fpv -wi 1");
    
    qDebug() << "✅ Comando 3D executado. Janelas devem abrir conforme Vrui.cfg";
    qDebug() << "💡 IMPORTANTE: Certifique-se que ~/.config/Vrui-8.0/Applications/SARndbox.cfg";
    qDebug() << "    possui 'windowNames += (Window2)' e seção Window2 com outputName correto";
}

void SandboxManager::stopSandbox()
{
    if (sandboxProcess && sandboxProcess->state() == QProcess::Running) {
        qDebug() << "Parando Sandbox...";
        sandboxProcess->terminate();
        
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
