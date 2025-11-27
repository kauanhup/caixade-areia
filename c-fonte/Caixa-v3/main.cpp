#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "calibrationmanager.h"
#include "sandboxmanager.h"
#include "displaymanager.h"
#include "basinmanager.h"
#include "palettemanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    
    // Configurações da aplicação
    app.setOrganizationName("CaixaDeAreia");
    app.setOrganizationDomain("caixadeareia.com");
    app.setApplicationName("Caixa de Areia Interativa");
    
    // ✅ Ícone da aplicação (novo caminho)
    app.setWindowIcon(QIcon(":/assets/app/icon.png"));
    
    // Criar engine QML
    QQmlApplicationEngine engine;
    
    // Criar gerenciadores C++
    CalibrationManager calibrationManager;
    SandboxManager sandboxManager;
    DisplayManager displayManager;
    BasinManager basinManager;
    PaletteManager paletteManager;  // 🎨 NOVO
    
    // ⚠️ Passar a engine para o BasinManager
    basinManager.setQmlEngine(&engine);
    
    // Registrar gerenciadores no contexto QML
    engine.rootContext()->setContextProperty("calibrationManager", &calibrationManager);
    engine.rootContext()->setContextProperty("sandboxManager", &sandboxManager);
    engine.rootContext()->setContextProperty("displayManager", &displayManager);
    engine.rootContext()->setContextProperty("basinManager", &basinManager);
    engine.rootContext()->setContextProperty("paletteManager", &paletteManager);
    
    // Carregar o arquivo QML principal
    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);
    return app.exec();
}

