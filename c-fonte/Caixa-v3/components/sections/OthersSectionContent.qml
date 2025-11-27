import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ScrollView {
    id: othersScroll
    clip: true
    contentWidth: availableWidth
    
    ColumnLayout {
        width: othersScroll.width
        spacing: 24
        
        // Espaço no topo
        Item { 
            Layout.fillWidth: true
            Layout.preferredHeight: 12 
        }
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            border.color: mainWindow.borderColor
            
            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width - 64
                spacing: 12
                
                Text {
                    text: "Outras Funcionalidades"
                    font.pixelSize: 24
                    font.bold: true
                    color: mainWindow.textColor
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                
                Text {
                    text: "Recursos adicionais em desenvolvimento para expandir as capacidades do sistema"
                    font.pixelSize: 13
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
        
        // Grid de funcionalidades
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 340
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            
            Row {
                anchors.fill: parent
                spacing: 24
                
                // Modo Jogo
                Rectangle {
                    width: (parent.width - 24) / 2
                    height: parent.height
                    radius: 12
                    border.width: 2
                    border.color: Qt.rgba(0.23, 0.51, 0.96, 0.2)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0.23, 0.51, 0.96, 0.05) }
                        GradientStop { position: 1.0; color: mainWindow.backgroundColor }
                    }
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16
                        
                        Rectangle {
                            Layout.preferredWidth: 64
                            Layout.preferredHeight: 64
                            radius: 12
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(0.23, 0.51, 0.96, 0.2) }
                                GradientStop { position: 1.0; color: Qt.rgba(0.23, 0.51, 0.96, 0.05) }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🎮"
                                font.pixelSize: 32
                            }
                        }
                        
                        Text {
                            text: "Modo Jogo"
                            font.pixelSize: 20
                            font.bold: true
                            color: mainWindow.textColor
                        }
                        
                        Text {
                            text: "Experiência interativa gamificada para aprendizado de geografia"
                            font.pixelSize: 13
                            color: mainWindow.mutedTextColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            Repeater {
                                model: [
                                    "Desafios de identificação topográfica",
                                    "Sistema de pontuação e rankings",
                                    "Missões educativas interativas",
                                    "Modo multiplayer cooperativo"
                                ]
                                
                                Row {
                                    spacing: 12
                                    Layout.fillWidth: true
                                    
                                    Text {
                                        text: "▸"
                                        color: mainWindow.primaryColor
                                        font.pixelSize: 16
                                    }
                                    
                                    Text {
                                        text: modelData
                                        font.pixelSize: 13
                                        color: mainWindow.textColor
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true }
                    }
                }
                
                // Visualização de Nascentes
                Rectangle {
                    width: (parent.width - 24) / 2
                    height: parent.height
                    radius: 12
                    border.width: 2
                    border.color: Qt.rgba(0.55, 0.36, 0.96, 0.2)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0.55, 0.36, 0.96, 0.05) }
                        GradientStop { position: 1.0; color: mainWindow.backgroundColor }
                    }
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16
                        
                        Rectangle {
                            Layout.preferredWidth: 64
                            Layout.preferredHeight: 64
                            radius: 12
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(0.55, 0.36, 0.96, 0.2) }
                                GradientStop { position: 1.0; color: Qt.rgba(0.55, 0.36, 0.96, 0.05) }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "💧"
                                font.pixelSize: 32
                            }
                        }
                        
                        Text {
                            text: "Visualização de Nascentes"
                            font.pixelSize: 20
                            font.bold: true
                            color: mainWindow.textColor
                        }
                        
                        Text {
                            text: "Identificação e análise de pontos de nascente de água"
                            font.pixelSize: 13
                            color: mainWindow.mutedTextColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            Repeater {
                                model: [
                                    "Detecção automática de nascentes",
                                    "Mapeamento de fluxo de água",
                                    "Análise de áreas de recarga",
                                    "Simulação de preservação"
                                ]
                                
                                Row {
                                    spacing: 12
                                    Layout.fillWidth: true
                                    
                                    Text {
                                        text: "▸"
                                        color: mainWindow.secondaryColor
                                        font.pixelSize: 16
                                    }
                                    
                                    Text {
                                        text: modelData
                                        font.pixelSize: 13
                                        color: mainWindow.textColor
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
        
        // Status Info
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            radius: 8
            color: Qt.rgba(0.4, 0.45, 0.55, 0.1)
            border.color: Qt.rgba(0.4, 0.45, 0.55, 0.2)
            
            Text {
                anchors.centerIn: parent
                text: "⚙️ Desenvolvimento ativo: Essas funcionalidades estão sendo desenvolvidas e estarão disponíveis em breve."
                font.pixelSize: 13
                font.bold: true
                color: mainWindow.mutedTextColor
            }
        }
        
        // Espaço no final
        Item { 
            Layout.fillWidth: true
            Layout.preferredHeight: 24 
        }
    }
}
