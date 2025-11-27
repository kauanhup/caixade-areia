// ~/see-my-design-qml/basinmanager.cpp
// VERSÃO FINAL - CORRIGIDO TIMING DO RESULTADO + AppImage

#include "basinmanager.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QThread>
#include <QProcess>
#include <QQmlComponent>
#include <QQuickWindow>
#include <QFileInfo>
#include <QTimer>

BasinManager::BasinManager(QObject *parent)
    : QObject(parent)
    , m_selectedBasin(-1)
    , m_selectedBasinName("")
    , m_engine(nullptr)
{
    log("BasinManager inicializado", "success");
    log("Diretório do executável: " + QCoreApplication::applicationDirPath(), "info");
    log("Raiz do projeto: " + getProjectRoot(), "info");
    
    m_basinFiles = QStringList() 
        << "modelo_1.png" 
        << "modelo_2.png" 
        << "modelo_3.png"
        << "modelo_4.png"
        << "modelo_5.png"
        << "modelo_6.png";
    
    m_basinNames = QStringList()
        << "Modelo 1"
        << "Delta do Nilo"
        << "Bacia do Paraná"
        << "Rio Colorado"
        << "Rio Yangtzé"
        << "Rio Mississippi";
}

BasinManager::~BasinManager()
{
    log("BasinManager destruído", "info");
}

void BasinManager::log(const QString &message, const QString &type)
{
    QString prefix;
    if (type == "success") prefix = "✅";
    else if (type == "error") prefix = "❌";
    else if (type == "warning") prefix = "⚠️";
    else if (type == "info") prefix = "ℹ️";
    else prefix = "📝";
    
    qDebug() << prefix << message;
    emit logMessage(message, type);
}

QString BasinManager::getProjectRoot()
{
    QString appDir = QCoreApplication::applicationDirPath();
    
    // CRÍTICO: Se rodando de AppImage, usar diretório REAL do projeto
    if (appDir.startsWith("/tmp/.mount_")) {
        QString realPath = QDir::homePath() + "/Caixade-Areia";
        if (QDir(realPath).exists()) {
            log("🎯 AppImage detectado! Usando: " + realPath, "success");
            return realPath;
        }
    }
    
    QDir dir(appDir);
    
    if (dir.dirName() == "bin") {
        dir.cdUp();
        log("Raiz detectada (a partir de bin/): " + dir.absolutePath(), "info");
        return dir.absolutePath();
    }
    
    QString caixaPath = QDir::homePath() + "/Caixade-Areia";
    if (QDir(caixaPath).exists()) {
        log("Raiz detectada (fallback): " + caixaPath, "warning");
        return caixaPath;
    }
    
    log("ERRO: Não foi possível encontrar raiz do projeto!", "error");
    return appDir;
}

QString BasinManager::getBasinImagePath(int basinIndex)
{
    if (basinIndex < 0 || basinIndex >= m_basinFiles.size()) {
        log("getBasinImagePath: índice inválido " + QString::number(basinIndex), "error");
        return "";
    }
    
    QString projectRoot = getProjectRoot();
    QString imagePath = projectRoot + "/resources/modelos/" + m_basinFiles[basinIndex];
    
    if (!QFile::exists(imagePath)) {
        log("AVISO: Arquivo não existe: " + imagePath, "warning");
    } else {
        log("Imagem encontrada: " + imagePath, "info");
    }
    
    return imagePath;
}

void BasinManager::setSelectedBasin(int basin)
{
    if (m_selectedBasin != basin && basin >= 0 && basin < m_basinFiles.size()) {
        m_selectedBasin = basin;
        m_selectedBasinName = m_basinNames[basin];
        m_currentBasinPath = getBasinImagePath(basin);
        
        emit selectedBasinChanged(basin);
        emit selectedBasinNameChanged(m_selectedBasinName);
        emit currentBasinPathChanged(m_currentBasinPath);
        
        log("Modelo selecionado: " + m_selectedBasinName, "success");
    }
}

void BasinManager::loadBasin(int basinIndex)
{
    if (basinIndex < 0 || basinIndex >= m_basinFiles.size()) {
        log("Índice de modelo inválido: " + QString::number(basinIndex), "error");
        emit basinError("Índice de modelo inválido");
        return;
    }
    
    setSelectedBasin(basinIndex);
    
    QString imagePath = getBasinImagePath(basinIndex);
    
    if (!QFile::exists(imagePath)) {
        log("Arquivo não encontrado: " + imagePath, "error");
        emit basinError("Imagem do modelo não encontrada: " + m_basinFiles[basinIndex]);
        return;
    }
    
    emit basinLoaded(basinIndex, m_basinNames[basinIndex]);
    log("Modelo carregado: " + m_basinNames[basinIndex], "success");
    log("Caminho: " + imagePath, "info");
}

void BasinManager::projectBasin()
{
    if (m_selectedBasin < 0) {
        log("Nenhum modelo selecionado para projetar", "error");
        emit basinError("Nenhum modelo selecionado");
        return;
    }
    
    if (m_currentBasinPath.isEmpty() || !QFile::exists(m_currentBasinPath)) {
        log("Imagem não encontrada: " + m_currentBasinPath, "error");
        emit basinError("Imagem do modelo não encontrada");
        return;
    }
    
    if (!m_engine) {
        log("Engine QML não está configurada!", "error");
        emit basinError("Erro interno: Engine não configurada");
        return;
    }
    
    log("Projetando modelo: " + m_selectedBasinName, "info");
    
    QQmlComponent component(m_engine, QUrl("qrc:/components/sections/FullscreenProjection.qml"));
    
    if (component.isError()) {
        log("Erro ao carregar FullscreenProjection.qml:", "error");
        for (const QQmlError &error : component.errors()) {
            log("  - " + error.toString(), "error");
        }
        emit basinError("Erro ao carregar janela fullscreen");
        return;
    }
    
    QObject *fullscreenObj = component.create();
    
    if (!fullscreenObj) {
        log("Erro ao criar janela fullscreen", "error");
        return;
    }
    
    fullscreenObj->setProperty("imagePath", m_currentBasinPath);
    
    connect(fullscreenObj, &QObject::destroyed, this, [this]() {
        log("Janela fullscreen fechada", "info");
    });
    
    emit basinProjected();
    log("Projeção iniciada (ESC para sair)", "success");
}

void BasinManager::visualizeBasin()
{
    if (m_selectedBasin < 0) {
        log("Nenhum modelo selecionado", "error");
        emit basinError("Nenhum modelo selecionado");
        return;
    }
    
    QString sandboxPath = QDir::homePath() + "/src/SARndbox-2.8";
    
    if (!QDir(sandboxPath).exists()) {
        log("SARndbox não encontrado: " + sandboxPath, "error");
        emit basinError("SARndbox não instalado em ~/src/SARndbox-2.8");
        return;
    }
    
    log("Iniciando SARndbox...", "info");
    
    QProcess *process = new QProcess(this);
    process->setWorkingDirectory(sandboxPath);
    
    connect(process, &QProcess::started, [this]() {
        log("SARndbox iniciado!", "success");
    });
    
    connect(process, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        QString msg = "Erro ao executar SARndbox";
        if (error == QProcess::FailedToStart) {
            msg = "Falha ao iniciar SARndbox";
        }
        log(msg, "error");
        emit basinError(msg);
    });
    
    process->start("bash", QStringList() << "-c" << "./bin/SARndbox -uhm -fpv");
}

void BasinManager::validateBasin()
{
    if (m_selectedBasin < 0) {
        log("Nenhum modelo selecionado", "error");
        emit basinError("Nenhum modelo selecionado");
        return;
    }
    
    QString projectRoot = getProjectRoot();
    QString comparacoesDir = projectRoot + "/resources/comparacoes/";
    QString sandboxPath = QDir::homePath() + "/src/SARndbox-2.8";
    
    log("=== INICIANDO VALIDAÇÃO ===", "info");
    emit validationProgress("Preparando...", 0);
    
    // Criar diretório
    QDir dir;
    if (!dir.exists(comparacoesDir)) {
        if (dir.mkpath(comparacoesDir)) {
            log("Diretório criado: " + comparacoesDir, "success");
        } else {
            emit basinError("Erro ao criar diretório");
            return;
        }
    }
    
    // Verificar SARndbox
    if (!QDir(sandboxPath).exists()) {
        log("SARndbox não encontrado", "error");
        emit basinError("SARndbox não instalado");
        return;
    }
    
    // Verificar scrot
    QProcess checkScrot;
    checkScrot.start("which", QStringList() << "scrot");
    checkScrot.waitForFinished(2000);
    
    if (checkScrot.exitCode() != 0) {
        log("scrot não instalado!", "error");
        emit basinError("Instale: sudo apt install scrot");
        return;
    }
    
    // Verificar xdotool
    bool hasXdotool = true;
    QProcess checkXdo;
    checkXdo.start("which", QStringList() << "xdotool");
    checkXdo.waitForFinished(2000);
    
    if (checkXdo.exitCode() != 0) {
        log("xdotool não instalado (sem verificação de janela)", "warning");
        hasXdotool = false;
    }
    
    // Limpar capturas antigas
    QString capturePath = comparacoesDir + "captura.png";
    QString differencePath = comparacoesDir + "diferenca.png";
    QFile::remove(capturePath);
    QFile::remove(differencePath);
    
    // ===== INICIAR SANDBOX =====
    log("[1/6] Iniciando SARndbox...", "info");
    emit validationProgress("Iniciando SARndbox...", 15);
    
    QProcess *sandboxProcess = new QProcess(this);
    sandboxProcess->setWorkingDirectory(sandboxPath);
    sandboxProcess->start("bash", QStringList() << "-c" << "./bin/SARndbox -uhm -fpv");
    
    if (!sandboxProcess->waitForStarted(5000)) {
        log("Timeout ao iniciar SARndbox", "error");
        emit basinError("Falha ao iniciar SARndbox");
        sandboxProcess->deleteLater();
        return;
    }
    
    log("SARndbox PID: " + QString::number(sandboxProcess->processId()), "success");
    
    // ===== VERIFICAR JANELA =====
    QString windowId = "";
    if (hasXdotool) {
        log("[2/6] Verificando janela...", "info");
        emit validationProgress("Aguardando janela...", 30);
        
        for (int i = 0; i < 15; i++) {
            QThread::msleep(1000);
            
            QProcess check;
            check.start("bash", QStringList() << "-c" << "xdotool search --name 'SARndbox' 2>/dev/null | head -1");
            check.waitForFinished(1000);
            
            QString result = check.readAllStandardOutput().trimmed();
            
            if (!result.isEmpty()) {
                windowId = result;
                log("Janela detectada! ID: " + windowId, "success");
                break;
            }
            
            log("Tentativa " + QString::number(i+1) + "/15...", "info");
        }
        
        if (windowId.isEmpty()) {
            log("Janela não detectada, continuando...", "warning");
        }
    } else {
        log("[2/6] Aguardando janela (10s fixos)...", "warning");
        emit validationProgress("Aguardando janela...", 30);
        QThread::sleep(10);
    }
    
    // ===== COUNTDOWN =====
    log("[3/6] Aguardando estabilização...", "info");
    
    for (int i = 5; i > 0; i--) {
        emit validationProgress("Capturando em " + QString::number(i) + "s...", 45 + (5-i)*5);
        log("  " + QString::number(i) + "s...", "info");
        QThread::sleep(1);
    }
    
    // ===== CAPTURAR APENAS A JANELA DA SANDBOX =====
    log("[4/6] Capturando janela SARndbox...", "info");
    emit validationProgress("Capturando...", 70);
    
    int scrotResult = -1;
    
    if (!windowId.isEmpty() && hasXdotool) {
        log("Capturando janela ID: " + windowId, "info");
        scrotResult = QProcess::execute("bash", QStringList() 
            << "-c" 
            << QString("scrot -u -b %1 -e 'xdotool windowactivate --sync %2 && sleep 0.2'")
                .arg(capturePath)
                .arg(windowId));
    } else {
        log("Capturando tela toda (fallback)", "warning");
        scrotResult = QProcess::execute("scrot", QStringList() << "-b" << capturePath);
    }
    
    if (scrotResult != 0 || !QFile::exists(capturePath)) {
        log("Erro na captura", "error");
        QProcess::execute("killall", QStringList() << "SARndbox");
        sandboxProcess->deleteLater();
        emit basinError("Falha na captura");
        return;
    }
    
    log("Captura salva: " + capturePath, "success");
    emit captureReady(capturePath);
    
    // ===== FECHAR SANDBOX =====
    log("[5/6] Fechando SARndbox...", "info");
    emit validationProgress("Fechando...", 80);
    
    QProcess::execute("killall", QStringList() << "SARndbox");
    sandboxProcess->deleteLater();
    QThread::msleep(500);
    
    // ===== COMPARAR =====
    log("[6/6] Comparando imagens...", "info");
    emit validationProgress("Comparando...", 90);
    
    int percentage = compareImages(m_currentBasinPath, capturePath);
    
    if (QFile::exists(differencePath)) {
        log("Diferença salva: " + differencePath, "success");
        emit differenceReady(differencePath);
    } else {
        log("AVISO: diferenca.png não foi criada", "warning");
    }
    
    emit validationProgress("Concluído!", 100);
    
    // CRÍTICO: Aumentar delay para 1500ms para garantir transição visual suave
    QTimer::singleShot(1500, this, [this, percentage]() {
        log("=============================", "success");
        log("  RESULTADO: " + QString::number(percentage) + "%", "success");
        log("=============================", "success");
        log("Emitindo validationResult com " + QString::number(percentage) + "%", "success");
        emit validationResult(percentage);
    });
}

void BasinManager::captureScreen()
{
    QString projectRoot = getProjectRoot();
    QString outputPath = projectRoot + "/resources/comparacoes/captura.png";
    
    log("Capturando: " + outputPath, "info");
    
    int result = QProcess::execute("scrot", QStringList() << "-b" << outputPath);
    
    if (result == 0) {
        log("Captura OK", "success");
    } else {
        log("Erro na captura", "error");
    }
}

int BasinManager::compareImages(const QString &original, const QString &captured)
{
    log("Comparando imagens...", "info");
    log("  Original: " + original, "info");
    log("  Captura:  " + captured, "info");
    
    if (!QFile::exists(original)) {
        log("Original não existe: " + original, "error");
        return 0;
    }
    
    if (!QFile::exists(captured)) {
        log("Captura não existe: " + captured, "error");
        return 0;
    }
    
    QString projectRoot = getProjectRoot();
    QString compareExe = projectRoot + "/auxs/ComparaImagens";
    
    if (!QFile::exists(compareExe)) {
        log("ComparaImagens não encontrado: " + compareExe, "error");
        log("Compile em ~/Caixade-Areia/auxs/", "warning");
        return 0;
    }
    
    QFileInfo info(compareExe);
    if (!info.isExecutable()) {
        log("Sem permissão de execução", "error");
        log("Execute: chmod +x " + compareExe, "warning");
        return 0;
    }
    
    log("Executando: " + compareExe, "info");
    
    QProcess process;
    process.setWorkingDirectory(projectRoot + "/auxs");
    process.start(compareExe, QStringList() << original << captured);
    
    if (!process.waitForFinished(30000)) {
        log("Timeout na comparação", "error");
        process.kill();
        return 0;
    }
    
    if (process.exitCode() != 0) {
        QString err = process.readAllStandardError();
        log("Erro no ComparaImagens: " + err, "error");
        return 0;
    }
    
    QString output = process.readAllStandardOutput();
    log("Saída ComparaImagens:", "info");
    log(output, "info");
    
    int percentage = 0;
    QStringList lines = output.split('\n');
    
    for (const QString &line : lines) {
        QString trimmed = line.trimmed();
        if (trimmed.startsWith("PERCENTUAL:")) {
            QString num = trimmed.mid(11).trimmed();
            bool ok;
            percentage = num.toInt(&ok);
            
            if (ok) {
                log("Percentual extraído: " + QString::number(percentage) + "%", "success");
            } else {
                log("Erro ao converter percentual: " + num, "error");
            }
            break;
        }
    }
    
    if (percentage < 0) percentage = 0;
    if (percentage > 100) percentage = 100;
    
    return percentage;
}
