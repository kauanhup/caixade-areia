#include "calibrationmanager.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QDir>
#include <QTimer>

CalibrationManager::CalibrationManager(QObject *parent)
    : QObject(parent)
    , kinectProcess(nullptr)
    , projectorProcess(nullptr)
{
}

void CalibrationManager::calibrateKinect()
{
    if (kinectProcess && kinectProcess->state() == QProcess::Running) {
        qWarning() << "Kinect calibration already running!";
        return;
    }
    
    kinectProcess = new QProcess(this);
    capturedOutput.clear();
    
    // Configurar working directory
    kinectProcess->setWorkingDirectory(QDir::homePath() + "/src/SARndbox-2.8");
    
    // Conectar sinais
    connect(kinectProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &CalibrationManager::onKinectProcessFinished);
    
    connect(kinectProcess, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        QString errorMsg;
        switch(error) {
            case QProcess::FailedToStart:
                errorMsg = "Falha ao iniciar RawKinectViewer. Verifique se está instalado.";
                break;
            case QProcess::Crashed:
                errorMsg = "RawKinectViewer fechou inesperadamente.";
                break;
            default:
                errorMsg = "Erro desconhecido ao executar RawKinectViewer.";
        }
        emit kinectCalibrationError(errorMsg);
        qWarning() << "Erro no processo Kinect:" << errorMsg;
    });
    
    // Capturar output (stdout e stderr)
    connect(kinectProcess, &QProcess::readyReadStandardOutput, [this]() {
        QString output = kinectProcess->readAllStandardOutput();
        capturedOutput += output;
        qDebug() << "Kinect output:" << output;
    });
    
    connect(kinectProcess, &QProcess::readyReadStandardError, [this]() {
        QString error = kinectProcess->readAllStandardError();
        capturedOutput += error;
        qDebug() << "Kinect error:" << error;
    });
    
    emit kinectCalibrationStarted();
    qDebug() << "Iniciando calibração Kinect...";
    
    // Timer de segurança (se não iniciar em 3 segundos, considera erro)
    QTimer::singleShot(3000, this, [this]() {
        if (kinectProcess && kinectProcess->state() != QProcess::Running) {
            if (capturedOutput.isEmpty()) {
                emit kinectCalibrationError("Kinect não detectado ou RawKinectViewer não encontrado.");
            }
        }
    });
    
    // Executar comando
    kinectProcess->start("bash", QStringList() << "-c" << "RawKinectViewer -compress 0");
}

void CalibrationManager::onKinectProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "Kinect calibration finished. Exit code:" << exitCode << "Status:" << exitStatus;
    qDebug() << "Captured output:" << capturedOutput;
    
    if (exitStatus == QProcess::NormalExit && exitCode == 0 && !capturedOutput.isEmpty()) {
        // Sucesso - salvar calibração
        saveKinectCalibration(capturedOutput);
        emit kinectCalibrationFinished(capturedOutput);
    } else {
        // Erro ou saída anormal
        QString errorMsg;
        
        if (capturedOutput.contains("Could not open") || 
            capturedOutput.contains("No device") ||
            capturedOutput.contains("not found")) {
            errorMsg = "Kinect não detectado. Verifique a conexão USB.";
        } else if (exitCode != 0) {
            errorMsg = QString("Calibração falhou (código: %1)").arg(exitCode);
        } else if (capturedOutput.isEmpty()) {
            errorMsg = "RawKinectViewer não encontrado. Instale o SARndbox primeiro.";
        } else {
            errorMsg = "Calibração cancelada ou incompleta.";
        }
        
        emit kinectCalibrationError(errorMsg);
    }
    
    capturedOutput.clear();
    kinectProcess->deleteLater();
    kinectProcess = nullptr;
}

void CalibrationManager::saveKinectCalibration(const QString &output)
{
    QString filePath = QDir::homePath() + "/src/SARndbox-2.8/etc/SARndbox-2.8/BoxLayout.txt";
    
    // Criar diretórios se não existirem
    QFileInfo fileInfo(filePath);
    QDir dir = fileInfo.absoluteDir();
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << output;
        file.close();
        qDebug() << "Calibração salva em:" << filePath;
    } else {
        qWarning() << "Erro ao salvar calibração em:" << filePath;
    }
}

void CalibrationManager::calibrateProjector()
{
    if (projectorProcess && projectorProcess->state() == QProcess::Running) {
        qWarning() << "Projector calibration already running!";
        return;
    }
    
    projectorProcess = new QProcess(this);
    
    // Configurar working directory
    projectorProcess->setWorkingDirectory(QDir::homePath() + "/src/SARndbox-2.8");
    
    // Conectar sinais
    connect(projectorProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &CalibrationManager::onProjectorProcessFinished);
    
    connect(projectorProcess, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        QString errorMsg;
        switch(error) {
            case QProcess::FailedToStart:
                errorMsg = "Falha ao iniciar CalibrateProjector. Verifique se está instalado.";
                break;
            case QProcess::Crashed:
                errorMsg = "CalibrateProjector fechou inesperadamente.";
                break;
            default:
                errorMsg = "Erro desconhecido ao executar CalibrateProjector.";
        }
        emit projectorCalibrationError(errorMsg);
        qWarning() << "Erro no processo Projetor:" << errorMsg;
    });
    
    emit projectorCalibrationStarted();
    qDebug() << "Iniciando calibração do Projetor...";
    
    // Timer de segurança
    QTimer::singleShot(3000, this, [this]() {
        if (projectorProcess && projectorProcess->state() != QProcess::Running) {
            emit projectorCalibrationError("Projetor não detectado ou CalibrateProjector não encontrado.");
        }
    });
    
    // Executar comando
    projectorProcess->start("bash", QStringList() << "-c" << "./bin/CalibrateProjector -s");
}

void CalibrationManager::onProjectorProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "Projector calibration finished. Exit code:" << exitCode;
    
    if (exitStatus == QProcess::NormalExit && exitCode == 0) {
        emit projectorCalibrationFinished();
    } else {
        QString errorMsg;
        
        if (exitCode != 0) {
            errorMsg = QString("Calibração do projetor falhou (código: %1)").arg(exitCode);
        } else {
            errorMsg = "Calibração do projetor cancelada ou incompleta.";
        }
        
        emit projectorCalibrationError(errorMsg);
    }
    
    projectorProcess->deleteLater();
    projectorProcess = nullptr;
}
