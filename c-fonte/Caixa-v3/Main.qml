import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import "pages"

ApplicationWindow {
    id: mainWindow
    visible: false
    width: 1000
    height: 600
    minimumWidth: 1000
    minimumHeight: 600
    maximumWidth: 1000
    maximumHeight: 600
    title: "Caixa de Areia Interativa"
    
    flags: Qt.Window
         | Qt.WindowTitleHint
         | Qt.WindowSystemMenuHint
         | Qt.WindowMinimizeButtonHint
         | Qt.WindowCloseButtonHint
    
    Component.onCompleted: {
        visibility = Window.Windowed
        x = (Screen.width - width) / 2
        y = (Screen.height - height) / 2
        visible = true
        showNormal()
    }
    
    // 🎨 Tema (padrão Tailwind)
    readonly property color backgroundColor: "#f8fafc"
    readonly property color cardColor: "#ffffff"
    readonly property color borderColor: "#e2e8f0"
    readonly property color primaryColor: "#3b82f6"
    readonly property color secondaryColor: "#8b5cf6"
    readonly property color accentColor: "#06b6d4"
    readonly property color successColor: "#10b981"
    readonly property color warningColor: "#f59e0b"
    readonly property color errorColor: "#ef4444"
    readonly property color textColor: "#0f172a"
    readonly property color mutedTextColor: "#64748b"
    
    property string currentPage: "workspace"
    
    function navigate(page) {
        currentPage = page
    }

    // Fundo com gradiente
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8fafc" }
            GradientStop { position: 0.5; color: "#f1f5f9" }
            GradientStop { position: 1.0; color: "#e2e8f0" }
        }
    }
    
    // Loader de páginas
    Loader {
        id: pageLoader
        anchors.fill: parent
        
        source: {
            switch(currentPage) {
                case "workspace": return "pages/WorkspacePage.qml"
                case "about": return "pages/AboutPage.qml"
                case "sandbox2d": return "pages/Sandbox2DPage.qml"
                case "sandbox3d": return "pages/Sandbox3DPage.qml"
                case "sandboxColors": return "pages/SandboxColorsPage.qml"
                case "sandboxBasins": return "pages/SandboxBasinsPage.qml"
                case "notfound": return "pages/NotFoundPage.qml"
                default: return "pages/WorkspacePage.qml"
            }
        }
        
        onStatusChanged: {
            if (status === Loader.Error) {
                console.log("Erro ao carregar:", source)
            }
        }
    }
}

