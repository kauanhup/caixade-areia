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
    return QDir::homePath() + "/src/SARndbox-2.8/etc/SARndbox-2.8/Vrui.cfg";
}

bool DisplayManager::configureSecondDisplay(QString displayName)
{
    QString configPath = getVruiConfigPath();
    
    QFile file(configPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit configurationError("Não foi possível abrir Vrui.cfg");
        return false;
    }
    
    QString content = file.readAll();
    file.close();
    
    // Remove configuração antiga de Window2 se existir
    QRegularExpression window2Re("section Window2.*?endsection", 
                                  QRegularExpression::DotMatchesEverythingOption);
    content.remove(window2Re);
    
    // Remove windowNames += (Window2) se existir
    content.remove(QRegularExpression("windowNames\\s*\\+=\\s*\\(Window2\\).*\n"));
    
    // Procura a seção Desktop
    int desktopPos = content.indexOf("section Desktop");
    if (desktopPos == -1) {
        emit configurationError("Seção Desktop não encontrada no Vrui.cfg");
        return false;
    }
    
    // Procura o final da primeira seção Window
    int firstWindowEndPos = content.indexOf("endsection", 
                                            content.indexOf("section Window", desktopPos));
    if (firstWindowEndPos == -1) {
        emit configurationError("Seção Window não encontrada no Vrui.cfg");
        return false;
    }
    
    // Move para depois do "endsection" da Window
    firstWindowEndPos += QString("endsection").length();
    
    // Adiciona windowNames logo após "section Desktop"
    int afterDesktopPos = content.indexOf("\n", desktopPos) + 1;
    QString windowNamesLine = "\t\twindowNames += (Window2)\n";
    
    // Verifica se já não existe
    if (!content.contains("windowNames")) {
        content.insert(afterDesktopPos, windowNamesLine);
        firstWindowEndPos += windowNamesLine.length(); // Ajusta posição
    }
    
    // Cria configuração da Window2
    QString window2Config = QString("\n\t\tsection Window2\n"
                                   "\t\t\tviewerName Viewer\n"
                                   "\t\t\tscreenName Screen\n"
                                   "\t\t\twindowType Mono\n"
                                   "\t\t\toutputName %1\n"
                                   "\t\t\twindowSize (1920, 1080)\n"
                                   "\t\t\twindowFullscreen false\n"
                                   "\t\tendsection\n").arg(displayName);
    
    // Insere Window2 após Window
    content.insert(firstWindowEndPos, window2Config);
    
    // Salva arquivo
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        emit configurationError("Não foi possível salvar Vrui.cfg");
        return false;
    }
    
    QTextStream out(&file);
    out << content;
    file.close();
    
    qDebug() << "Vrui.cfg configurado com display:" << displayName;
    emit configurationSuccess();
    return true;
}
