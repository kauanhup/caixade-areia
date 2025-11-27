#include "calibrationmanager.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QDir>
#include <QTimer>
#include <QRegularExpression>

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
        emit kinectCalibrationError("Calibração já está rodando!");
        return;
    }
    
    kinectProcess = new QProcess(this);
    capturedOutput.clear();
    formattedCalibrationData.clear();
    
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
    });
    
    connect(kinectProcess, &QProcess::readyReadStandardError, [this]() {
        QString error = kinectProcess->readAllStandardError();
        capturedOutput += error;
    });
    
    emit kinectCalibrationStarted();
    qDebug() << "🚀 Iniciando calibração Kinect...";
    
    // Timer de segurança
    QTimer::singleShot(3000, this, [this]() {
        if (kinectProcess && kinectProcess->state() != QProcess::Running) {
            if (capturedOutput.isEmpty()) {
                emit kinectCalibrationError("Kinect não detectado ou RawKinectViewer não encontrado.");
            }
        }
    });
    
    // Executar comando SEM comprimir (para capturar output)
    kinectProcess->start("bash", QStringList() << "-c" << "RawKinectViewer -compress 0");
    
    // 🔥 Fullscreen automático depois de 1 segundo
    QTimer *fullscreenTimer = new QTimer(this);
    fullscreenTimer->setInterval(1000);
    int *attemptsPtr = new int(0);
    
    connect(fullscreenTimer, &QTimer::timeout, [this, fullscreenTimer, attemptsPtr]() {
        (*attemptsPtr)++;
        
        QProcess *checkWindow = new QProcess(this);
        checkWindow->start("bash", QStringList() << "-c" 
            << "xdotool search --name \"RawKinectViewer\" 2>/dev/null");
        checkWindow->waitForFinished(500);
        
        QString output = checkWindow->readAllStandardOutput().trimmed();
        checkWindow->deleteLater();
        
        if (!output.isEmpty()) {
            QProcess::execute("bash", QStringList() << "-c" 
                << "WIN_ID=$(xdotool search --name \"RawKinectViewer\" | head -1); "
                   "if [ ! -z \"$WIN_ID\" ]; then wmctrl -i -r $WIN_ID -b add,fullscreen; fi");
            qDebug() << "✅ Fullscreen aplicado no RawKinectViewer após" << *attemptsPtr << "tentativa(s)";
            fullscreenTimer->stop();
            fullscreenTimer->deleteLater();
            delete attemptsPtr;
        } else if (*attemptsPtr >= 5) {
            qWarning() << "⏱️ Timeout: Janela do RawKinectViewer não encontrada";
            fullscreenTimer->stop();
            fullscreenTimer->deleteLater();
            delete attemptsPtr;
        }
    });
    
    fullscreenTimer->start();
}

void CalibrationManager::onKinectProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "📊 Kinect calibration finished. Exit code:" << exitCode;
    qDebug() << "📄 Captured output length:" << capturedOutput.length() << "bytes";
    
    if (capturedOutput.isEmpty()) {
        emit kinectCalibrationError("Nenhum dado capturado. Verifique se o Kinect está conectado.");
        kinectProcess->deleteLater();
        kinectProcess = nullptr;
        return;
    }
    
    // 🔥 Filtrar e formatar os dados
    formattedCalibrationData = filterAndFormatKinectData(capturedOutput);
    
    if (formattedCalibrationData.isEmpty()) {
        emit kinectCalibrationError("Dados de calibração não encontrados no output.");
        kinectProcess->deleteLater();
        kinectProcess = nullptr;
        return;
    }
    
    // 🎉 Emitir sinal para mostrar popup de confirmação
    emit kinectCalibrationClosed(formattedCalibrationData);
    
    kinectProcess->deleteLater();
    kinectProcess = nullptr;
}

QString CalibrationManager::filterAndFormatKinectData(const QString &rawOutput)
{
    qDebug() << "🔍 Filtrando dados de calibração...";
    
    QStringList lines = rawOutput.split('\n');
    QString result;
    bool foundEquation = false;
    int linesAfterEquation = 0;
    
    for (const QString &line : lines) {
        // Procura pela linha "Camera-space plane equation"
        if (line.contains("Camera-space plane equation")) {
            qDebug() << "✅ Encontrou linha de equação:" << line;
            
            // Extrair a parte: x * (números) = número
            QRegularExpression regex(R"(\(([-\d., ]+)\)\s*=\s*([-\d.]+))");
            QRegularExpressionMatch match = regex.match(line);
            
            if (match.hasMatch()) {
                QString coords = match.captured(1).trimmed();  // (x, y, z)
                QString value = match.captured(2).trimmed();   // valor após =
                
                // Formatar: (x, y, z), valor
                result = "(" + coords + "), " + value + "\n";
                foundEquation = true;
                qDebug() << "📝 Linha formatada:" << result.trimmed();
            }
        }
        // Pegar as próximas 4 linhas após a equação (coordenadas dos pontos)
        else if (foundEquation && linesAfterEquation < 4) {
            QString trimmedLine = line.trimmed();
            if (trimmedLine.startsWith("(") && trimmedLine.endsWith(")")) {
                result += trimmedLine + "\n";
                linesAfterEquation++;
                qDebug() << "📌 Ponto" << linesAfterEquation << ":" << trimmedLine;
            }
        }
        
        // Parar após pegar tudo
        if (linesAfterEquation >= 4) {
            break;
        }
    }
    
    if (!foundEquation) {
        qWarning() << "❌ Não encontrou 'Camera-space plane equation' no output";
        return QString();
    }
    
    qDebug() << "🎉 Dados formatados com sucesso!";
    qDebug() << "📋 Resultado final:\n" << result;
    
    return result;
}

void CalibrationManager::saveKinectCalibration()
{
    if (formattedCalibrationData.isEmpty()) {
        emit kinectCalibrationError("Nenhum dado para salvar.");
        return;
    }
    
    saveFormattedDataToFile(formattedCalibrationData);
    emit kinectCalibrationFinished(formattedCalibrationData);
    
    formattedCalibrationData.clear();
    capturedOutput.clear();
}

void CalibrationManager::cancelKinectCalibration()
{
    qDebug() << "❌ Calibração cancelada pelo usuário";
    formattedCalibrationData.clear();
    capturedOutput.clear();
}

void CalibrationManager::saveFormattedDataToFile(const QString &formattedData)
{
    QString filePath = QDir::homePath() + "/src/SARndbox-2.8/etc/SARndbox-2.8/BoxLayout.txt";
    
    // Criar diretórios se não existirem
    QFileInfo fileInfo(filePath);
    QDir dir = fileInfo.absoluteDir();
    if (!dir.exists()) {
        dir.mkpath(".");
        qDebug() << "📁 Diretório criado:" << dir.absolutePath();
    }
    
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << formattedData;
        file.close();
        qDebug() << "💾 Calibração salva em:" << filePath;
    } else {
        qWarning() << "❌ Erro ao salvar calibração em:" << filePath;
        emit kinectCalibrationError("Erro ao salvar arquivo de calibração.");
    }
}

void CalibrationManager::calibrateProjector()
{
    if (projectorProcess && projectorProcess->state() == QProcess::Running) {
        qWarning() << "Projector calibration already running!";
        emit projectorCalibrationError("Calibração já está rodando!");
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
    qDebug() << "🚀 Iniciando calibração do Projetor...";
    
    // Timer de segurança
    QTimer::singleShot(3000, this, [this]() {
        if (projectorProcess && projectorProcess->state() != QProcess::Running) {
            emit projectorCalibrationError("Projetor não detectado ou CalibrateProjector não encontrado.");
        }
    });
    
    // Executar comando
    projectorProcess->start("bash", QStringList() << "-c" << "./bin/CalibrateProjector -s");
    
    // 🔥 Fullscreen automático depois de 1 segundo
    QTimer *fullscreenTimer = new QTimer(this);
    fullscreenTimer->setInterval(1000);
    int *attemptsPtr = new int(0);
    
    connect(fullscreenTimer, &QTimer::timeout, [this, fullscreenTimer, attemptsPtr]() {
        (*attemptsPtr)++;
        
        QProcess *checkWindow = new QProcess(this);
        checkWindow->start("bash", QStringList() << "-c" 
            << "xdotool search --name \"CalibrateProjector\" 2>/dev/null");
        checkWindow->waitForFinished(500);
        
        QString output = checkWindow->readAllStandardOutput().trimmed();
        checkWindow->deleteLater();
        
        if (!output.isEmpty()) {
            QProcess::execute("bash", QStringList() << "-c" 
                << "WIN_ID=$(xdotool search --name \"CalibrateProjector\" | head -1); "
                   "if [ ! -z \"$WIN_ID\" ]; then wmctrl -i -r $WIN_ID -b add,fullscreen; fi");
            qDebug() << "✅ Fullscreen aplicado no CalibrateProjector após" << *attemptsPtr << "tentativa(s)";
            fullscreenTimer->stop();
            fullscreenTimer->deleteLater();
            delete attemptsPtr;
        } else if (*attemptsPtr >= 5) {
            qWarning() << "⏱️ Timeout: Janela do CalibrateProjector não encontrada";
            fullscreenTimer->stop();
            fullscreenTimer->deleteLater();
            delete attemptsPtr;
        }
    });
    
    fullscreenTimer->start();
}

void CalibrationManager::onProjectorProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "📊 Projector calibration finished. Exit code:" << exitCode;
    
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
