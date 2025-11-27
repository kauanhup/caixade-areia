import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    spacing: 24
    
    // Conexões com backend
    Connections {
        target: sandboxManager
        
        function onSandboxStarted(mode) {
            console.log("✅ Sandbox", mode, "iniciado")
            statusText.text = "✅ Sandbox " + mode + " rodando!"
            statusText.color = "#10b981"
            statusText.visible = true
            statusTimer.restart()
        }
        
        function onSandboxStopped() {
            console.log("🛑 Sandbox parado")
            statusText.text = "🛑 Sandbox fechado"
            statusText.color = mainWindow.mutedTextColor
            statusText.visible = true
            statusTimer.restart()
        }
        
        function onSandboxError(error) {
            console.log("❌ Erro Sandbox:", error)
            statusText.text = "❌ " + error
            statusText.color = "#ef4444"
            statusText.visible = true
            statusTimer.restart()
        }
    }
    
    Timer {
        id: statusTimer
        interval: 5000
        onTriggered: {
            statusText.visible = false
        }
    }
    
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 8
        
        Text {
            text: "Visualização 2D"
            font.pixelSize: 24
            font.bold: true
            color: mainWindow.textColor
        }
        
        Text {
            text: "Mapa de contorno e elevação em duas dimensões"
            font.pixelSize: 13
            color: mainWindow.mutedTextColor
        }
    }
    
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 280
        radius: 12
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#eff6ff" }
            GradientStop { position: 1.0; color: "#cffafe" }
        }
        border.color: mainWindow.borderColor
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16
            
            Text {
                text: "Sandbox 2D Interativa"
                font.pixelSize: 20
                font.bold: true
                color: mainWindow.textColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Visualize o terreno em vista superior com linhas de contorno,\ncurvas de nível e mapa de elevação em tempo real"
                font.pixelSize: 13
                color: mainWindow.mutedTextColor
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
            
            Row {
                spacing: 12
                Layout.alignment: Qt.AlignHCenter
                
                Repeater {
                    model: [
                        {icon: "📊", text: "Linhas de Contorno"},
                        {icon: "👁️", text: "Vista Superior"}
                    ]
                    
                    Rectangle {
                        width: 160
                        height: 28
                        radius: 14
                        color: Qt.rgba(1, 1, 1, 0.5)
                        
                        Row {
                            anchors.centerIn: parent
                            spacing: 6
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: 12
                            }
                            
                            Text {
                                text: modelData.text
                                font.pixelSize: 11
                                color: mainWindow.mutedTextColor
                            }
                        }
                    }
                }
            }
            
            Button {
                id: sandbox2DButton
                text: "Abrir Sandbox 2D"
                Layout.alignment: Qt.AlignHCenter
                padding: 12
                
                background: Rectangle {
                    color: sandbox2DButton.pressed ? Qt.darker(mainWindow.primaryColor, 1.1) : mainWindow.primaryColor
                    radius: 8
                    
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                // 🔥 MUDANÇA: onClicked direto no Button, SEM MouseArea
                onClicked: {
                    sandboxManager.openSandbox2D()
                }
            }
            
            Text {
                id: statusText
                Layout.fillWidth: true
                font.pixelSize: 12
                color: mainWindow.mutedTextColor
                horizontalAlignment: Text.AlignHCenter
                visible: false
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
