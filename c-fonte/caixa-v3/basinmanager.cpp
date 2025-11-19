#include "basinmanager.h"
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QThread>
#include <QProcess>
#include <QQmlComponent>
#include <QQuickWindow>

BasinManager::BasinManager(QObject *parent)
    : QObject(parent)
    , m_selectedBasin(-1)
    , m_selectedBasinName("")
    , m_engine(nullptr)
{
    log("BasinManager inicializado", "success");
    log("Diretório do executável: " + QCoreApplication::applicationDirPath(), "info");
    log("Raiz do projeto: " + getProjectRoot(), "info");
}

BasinManager::~BasinManager()
{
    log("BasinManager destruído", "info");
}

void BasinManager::log(const QString &message, const QString &type)
{
    // Log no console
    QString prefix;
    if (type == "success") prefix = "✅";
    else if (type == "error") prefix = "❌";
    else if (type == "warning") prefix = "⚠️";
    else if (type == "info") prefix = "ℹ️";
    else prefix = "📝";
    
    qDebug() << prefix << message;
    
    // Emitir sinal para o QML também
    emit logMessage(message, type);
}

QString BasinManager::getProjectRoot()
{
    // Executável na área de trabalho: ~/Desktop/caixa-de-areia
    // Recursos em: ~/Caixade-Areia/
    
    // Opção 1: Usar caminho fixo do usuário
    QString homeDir = QDir::homePath();
    QString projectPath = homeDir + "/Caixade-Areia";
    
    if (QDir(projectPath).exists()) {
        return projectPath;
    }
    
    // Opção 2: Tentar a partir do executável
    QString appDir = QCoreApplication::applicationDirPath();
    QDir dir(appDir);
    
    // Se tiver na estrutura ~/Caixade-Areia/bin/
    if (dir.dirName() == "bin") {
        dir.cdUp();
        return dir.absolutePath();
    }
    
    // Fallback: assumir que tá no home
    log("AVISO: Usando caminho padrão ~/Caixade-Areia", "warning");
    return projectPath;
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

QString BasinManager::getBasinImagePath(int basinIndex)
{
    if (basinIndex < 0 || basinIndex >= m_basinFiles.size()) {
        log("getBasinImagePath: índice inválido " + QString::number(basinIndex), "error");
        return "";
    }
    
    // Caminho: ~/Caixade-Areia/resources/modelos/modelo_X.png
    QString projectRoot = getProjectRoot();
    QString imagePath = projectRoot + "/resources/modelos/" + m_basinFiles[basinIndex];
    
    if (!QFile::exists(imagePath)) {
        log("AVISO: Arquivo não existe: " + imagePath, "warning");
    }
    
    return imagePath;
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
    log("Caminho da imagem: " + m_currentBasinPath, "info");
    
    // Criar componente da janela fullscreen
    QQmlComponent component(m_engine, QUrl("qrc:/components/sections/FullscreenProjection.qml"));
    
    if (component.isError()) {
        log("Erro ao carregar FullscreenProjection.qml:", "error");
        for (const QQmlError &error : component.errors()) {
            log("  - " + error.toString(), "error");
        }
        emit basinError("Erro ao carregar janela fullscreen");
        return;
    }
    
    // Criar objeto da janela
    QObject *fullscreenObj = component.create();
    
    if (!fullscreenObj) {
        log("Erro ao criar janela fullscreen", "error");
        emit basinError("Erro ao criar janela fullscreen");
        return;
    }
    
    // Configurar caminho da imagem
    fullscreenObj->setProperty("imagePath", m_currentBasinPath);
    
    // Conectar destruição
    connect(fullscreenObj, &QObject::destroyed, this, [this]() {
        log("Janela fullscreen foi fechada", "info");
    });
    
    emit basinProjected();
    log("Projeção fullscreen iniciada (pressione ESC para sair)", "success");
}

void BasinManager::visualizeBasin()
{
    if (m_selectedBasin < 0) {
        log("Nenhum modelo selecionado para visualizar", "error");
        emit basinError("Nenhum modelo selecionado");
        return;
    }
    
    log("Visualizando modelo no SARndbox: " + m_selectedBasinName, "info");
    
    QString sandboxPath = QDir::homePath() + "/src/SARndbox-2.8";
    
    if (!QDir(sandboxPath).exists()) {
        log("SARndbox não encontrado em: " + sandboxPath, "error");
        emit basinError("SARndbox não está instalado em ~/src/SARndbox-2.8");
        return;
    }
    
    // Executar SARndbox
    QProcess *process = new QProcess(this);
    process->setWorkingDirectory(sandboxPath);
    
    connect(process, &QProcess::started, [this]() {
        log("SARndbox iniciado com sucesso!", "success");
    });
    
    connect(process, &QProcess::errorOccurred, [this](QProcess::ProcessError error) {
        QString errorMsg;
        switch(error) {
            case QProcess::FailedToStart:
                errorMsg = "Falha ao iniciar SARndbox. Verifique as permissões.";
                break;
            case QProcess::Crashed:
                errorMsg = "SARndbox fechou inesperadamente.";
                break;
            default:
                errorMsg = "Erro desconhecido ao executar SARndbox.";
        }
        log(errorMsg, "error");
        emit basinError(errorMsg);
    });
    
    log("Executando: " + sandboxPath + "/bin/SARndbox -uhm -fpv", "info");
    process->start("bash", QStringList() << "-c" << "./bin/SARndbox -uhm -fpv");
}

void BasinManager::validateBasin()
{
    if (m_selectedBasin < 0) {
        log("Nenhum modelo selecionado para validar", "error");
        emit basinError("Nenhum modelo selecionado");
        return;
    }
    
    log("Iniciando validação: " + m_selectedBasinName, "info");
    log("Esta operação levará aproximadamente 10 segundos...", "warning");
    
    QString projectRoot = getProjectRoot();
    QString comparacoesDir = projectRoot + "/resources/comparacoes/";
    
    // Criar diretório de comparações se não existir
    QDir dir;
    if (!dir.exists(comparacoesDir)) {
        if (dir.mkpath(comparacoesDir)) {
            log("Diretório criado: " + comparacoesDir, "success");
        } else {
            log("ERRO ao criar diretório: " + comparacoesDir, "error");
            emit basinError("Não foi possível criar diretório de comparações");
            return;
        }
    }
    
    QString sandboxPath = QDir::homePath() + "/src/SARndbox-2.8";
    
    if (!QDir(sandboxPath).exists()) {
        log("SARndbox não encontrado", "error");
        emit basinError("SARndbox não está instalado");
        return;
    }
    
    // 1. Abrir SARndbox
    log("[1/4] Iniciando SARndbox...", "info");
    QProcess *sandboxProcess = new QProcess(this);
    sandboxProcess->setWorkingDirectory(sandboxPath);
    sandboxProcess->start("bash", QStringList() << "-c" << "./bin/SARndbox -uhm -fpv");
    
    if (!sandboxProcess->waitForStarted(5000)) {
        log("ERRO: Timeout ao iniciar SARndbox", "error");
        emit basinError("Timeout ao iniciar SARndbox");
        sandboxProcess->deleteLater();
        return;
    }
    
    log("SARndbox iniciado!", "success");
    
    // 2. Aguardar e capturar tela
    log("[2/4] Aguardando 5 segundos para estabilização...", "info");
    QThread::sleep(5);
    captureScreen();
    
    // 3. Fechar SARndbox
    log("[3/4] Fechando SARndbox...", "info");
    QProcess::execute("killall", QStringList() << "SARndbox");
    sandboxProcess->deleteLater();
    log("SARndbox fechado", "success");
    
    // 4. Comparar imagens
    log("[4/4] Comparando imagens...", "info");
    QString capturedPath = comparacoesDir + "captura.png";
    
    if (!QFile::exists(capturedPath)) {
        log("ERRO: Captura de tela falhou", "error");
        emit basinError("Falha na captura de tela. Instale o scrot: sudo apt install scrot");
        return;
    }
    
    int percentage = compareImages(m_currentBasinPath, capturedPath);
    
    emit validationResult(percentage);
    log("Validação concluída! Acerto: " + QString::number(percentage) + "%", "success");
}

void BasinManager::captureScreen()
{
    QString projectRoot = getProjectRoot();
    QString outputPath = projectRoot + "/resources/comparacoes/captura.png";
    
    // Verificar se scrot está instalado
    QProcess checkScrot;
    checkScrot.start("which", QStringList() << "scrot");
    checkScrot.waitForFinished();
    
    if (checkScrot.exitCode() != 0) {
        log("ERRO: scrot não está instalado!", "error");
        log("Instale com: sudo apt install scrot", "warning");
        return;
    }
    
    log("Capturando tela...", "info");
    
    // Capturar tela com scrot
    int result = QProcess::execute("scrot", QStringList() << "-b" << outputPath);
    
    if (result == 0) {
        log("Captura salva: " + outputPath, "success");
    } else {
        log("ERRO na captura. Código: " + QString::number(result), "error");
    }
}

int BasinManager::compareImages(const QString &original, const QString &captured)
{
    log("Comparando imagens...", "info");
    log("Original : " + original, "info");
    log("Capturada: " + captured, "info");
    
    // Verificar se os arquivos existem
    if (!QFile::exists(original)) {
        log("ERRO: Arquivo original não existe!", "error");
        return 0;
    }
    
    if (!QFile::exists(captured)) {
        log("ERRO: Arquivo capturado não existe!", "error");
        return 0;
    }
    
    // Caminho do executável ComparaImagens
    QString projectRoot = getProjectRoot();
    QString compareExe = projectRoot + "/auxs/ComparaImagens";
    
    if (!QFile::exists(compareExe)) {
        log("ERRO: ComparaImagens não encontrado: " + compareExe, "error");
        return 0;
    }
    
    log("Executável: " + compareExe, "info");
    
    // Executar ComparaImagens
    QProcess process;
    process.start(compareExe, QStringList() << original << captured);
    
    if (!process.waitForFinished(10000)) {
        log("ERRO: Timeout ao executar ComparaImagens", "error");
        return 0;
    }
    
    int exitCode = process.exitCode();
    int percentage = exitCode / 256;
    
    // Limitar entre 0 e 100
    if (percentage < 0) percentage = 0;
    if (percentage > 100) percentage = 100;
    
    // Verificar imagem de diferença
    QString diffPath = projectRoot + "/resources/comparacoes/diferenca.png";
    
    if (QFile::exists(diffPath)) {
        log("Imagem de diferença salva: " + diffPath, "success");
    } else {
        log("AVISO: Imagem de diferença não foi gerada", "warning");
    }
    
    log("Comparação concluída: " + QString::number(percentage) + "%", "success");
    
    return percentage;
}
