#include "displaymanager.h"
#include <QProcess>
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QRegularExpression>

DisplayManager::DisplayManager(QObject *parent)
    : QObject(parent)
{
}

QStringList DisplayManager::getAvailableDisplays()
{
    QProcess process;
    process.start("xrandr");
    process.waitForFinished();
    
    QString output = process.readAllStandardOutput();
    QStringList displays = parseXrandrOutput(output);
    
    emit displaysDetected(displays);
    return displays;
}

QStringList DisplayManager::parseXrandrOutput(const QString &output)
{
    QStringList displays;
    QStringList lines = output.split("\n");
    
    // Regex pra pegar: "HDMI-1 connected" ou "DP-1 connected 1920x1080+0+0"
    QRegularExpression re("^([A-Za-z0-9\\-]+)\\s+connected");
    
    for (const QString &line : lines) {
        QRegularExpressionMatch match = re.match(line);
        if (match.hasMatch()) {
            QString displayName = match.captured(1);
            displays.append(displayName);
            qDebug() << "Display encontrado:" << displayName;
        }
    }
    
    return displays;
}

QString DisplayManager::getPrimaryDisplay()
{
    QProcess process;
    process.start("xrandr");
    process.waitForFinished();
    
    QString output = process.readAllStandardOutput();
    QStringList lines = output.split("\n");
    
    // Procura por "primary"
    QRegularExpression re("^([A-Za-z0-9\\-]+)\\s+connected\\s+primary");
    
    for (const QString &line : lines) {
        QRegularExpressionMatch match = re.match(line);
        if (match.hasMatch()) {
            return match.captured(1);
        }
    }
    
    // Se não encontrou primary, pega o primeiro
    QStringList displays = parseXrandrOutput(output);
    return displays.isEmpty() ? "" : displays.first();
}

QString DisplayManager::getVruiConfigPath()
{
    // Caminho CORRETO do config do SARndbox
    return QDir::homePath() + "/.config/Vrui-8.0/Applications/SARndbox.cfg";
}

bool DisplayManager::configureSecondDisplay(QString displayName)
{
    QString configPath = getVruiConfigPath();
    
    // Cria diretório se não existir (cria toda a hierarquia)
    QDir configDir = QFileInfo(configPath).dir();
    if (!configDir.exists()) {
        if (!configDir.mkpath(".")) {
            emit configurationError("Não foi possível criar diretório de configuração");
            return false;
        }
        qDebug() << "✅ Diretório criado:" << configDir.path();
    }
    
    QFile file(configPath);
    
    // Se não existir, cria com estrutura básica do Step 15
    if (!file.exists()) {
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            emit configurationError("Não foi possível criar SARndbox.cfg");
            return false;
        }
        
        QString basicConfig = 
            "section Vrui\n"
            "\tsection Desktop\n"
            "\t\t# Disable the screen saver:\n"
            "\t\tinhibitScreenSaver true\n"
            "\t\t\n"
            "\t\tsection MouseAdapter\n"
            "\t\t\t# Hide the mouse cursor after 5 seconds of inactivity:\n"
            "\t\t\tmouseIdleTimeout 5.0\n"
            "\t\tendsection\n"
            "\t\t\n"
            "\t\tsection Window\n"
            "\t\t\t# Force the application's window to full-screen mode:\n"
            "\t\t\twindowFullscreen true\n"
            "\t\tendsection\n"
            "\t\t\n"
            "\t\tsection Tools\n"
            "\t\t\tsection DefaultTools\n"
            "\t\t\t\t# Bind a global rain/dry tool to the \"1\" and \"2\" keys:\n"
            "\t\t\t\tsection WaterTool\n"
            "\t\t\t\t\ttoolClass GlobalWaterTool\n"
            "\t\t\t\t\tbindings ((Mouse, 1, 2))\n"
            "\t\t\t\tendsection\n"
            "\t\t\tendsection\n"
            "\t\tendsection\n"
            "\tendsection\n"
            "endsection\n";
        
        file.write(basicConfig.toUtf8());
        file.close();
        qDebug() << "✅ SARndbox.cfg criado com configuração básica";
    }
    
    // Abre para leitura
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit configurationError("Não foi possível abrir SARndbox.cfg");
        return false;
    }
    
    QString content = file.readAll();
    file.close();
    
    // Remove configuração antiga de Window2 se existir
    QRegularExpression window2Re("\\s*section Window2.*?endsection\\s*", 
                                  QRegularExpression::DotMatchesEverythingOption);
    content.remove(window2Re);
    
    // Remove windowNames += (Window2) se existir
    QRegularExpression windowNamesRe("\\s*windowNames\\s*\\+=\\s*\\(Window2\\)\\s*\n");
    content.remove(windowNamesRe);
    
    // Procura a seção Desktop
    int desktopPos = content.indexOf("section Desktop");
    if (desktopPos == -1) {
        emit configurationError("Seção Desktop não encontrada no SARndbox.cfg");
        return false;
    }
    
    // Adiciona windowNames logo após "section Desktop"
    int afterDesktopPos = content.indexOf("\n", desktopPos);
    if (afterDesktopPos == -1) afterDesktopPos = content.length();
    
    QString windowNamesLine = "\t\t# Open a second window:\n\t\twindowNames += (Window2)\n";
    
    // Insere windowNames se ainda não existir
    if (!content.contains("windowNames")) {
        content.insert(afterDesktopPos + 1, windowNamesLine);
    }
    
    // Procura o final da seção Tools para adicionar Window2 depois
    int toolsEndPos = content.lastIndexOf("endsection", content.indexOf("endsection", content.indexOf("section Tools")));
    if (toolsEndPos == -1) {
        emit configurationError("Fim da seção Tools não encontrado");
        return false;
    }
    
    // Move para depois do endsection da Tools
    toolsEndPos += QString("endsection").length();
    
    // Cria configuração da Window2 COM FULLSCREEN (Step 19)
    QString window2Config = QString(
        "\n\t\t\n"
        "\t\tsection Window2\n"
        "\t\t\tviewerName Viewer\n"
        "\t\t\tscreenName Screen\n"
        "\t\t\twindowType Mono\n"
        "\t\t\t\n"
        "\t\t\t# Open the window on a specific video output port:\n"
        "\t\t\toutputName %1\n"
        "\t\t\t\n"
        "\t\t\t# Open the window to full-screen mode:\n"
        "\t\t\twindowSize (1920, 1080)\n"
        "\t\t\twindowFullscreen true\n"
        "\t\tendsection\n").arg(displayName);
    
    // Insere Window2 após Tools
    content.insert(toolsEndPos, window2Config);
    
    // Salva arquivo
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        emit configurationError("Não foi possível salvar SARndbox.cfg");
        return false;
    }
    
    QTextStream out(&file);
    out << content;
    file.close();
    
    qDebug() << "✅ SARndbox.cfg configurado com display:" << displayName;
    qDebug() << "📄 Arquivo salvo em:" << configPath;
    emit configurationSuccess();
    return true;
}
