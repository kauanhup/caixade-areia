import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

ScrollView {
    id: aboutScroll
    clip: true
    contentWidth: availableWidth
    
    ColumnLayout {
        width: Math.min(aboutScroll.width - 48, 1024)
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 24
        
        // Espaço no topo
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
        
        // Header
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 12
            
            Text {
                text: "Créditos e Licenças"
                font.pixelSize: 30
                font.bold: true
                color: mainWindow.textColor
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }
            
            Text {
                text: "Projeto educacional de código aberto baseado no Augmented Reality Sandbox"
                font.pixelSize: 14
                color: mainWindow.mutedTextColor
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // Container principal
        Rectangle {
            id: mainCard
            Layout.fillWidth: true
            Layout.preferredHeight: mainLayout.height + 64
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            border.color: mainWindow.borderColor
            border.width: 1
            
            ColumnLayout {
                id: mainLayout
                width: parent.width - 64
                anchors.centerIn: parent
                spacing: 32
                
                // Grid 2 colunas
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 24
                    rowSpacing: 24
                    
                    // Card 1: Projeto Original
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        radius: 12
                        border.width: 2
                        border.color: Qt.rgba(0.23, 0.51, 0.96, 0.2)
                        
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(0.23, 0.51, 0.96, 0.05) }
                            GradientStop { position: 1.0; color: Qt.rgba(0.23, 0.51, 0.96, 0.1) }
                        }
                        
                        MouseArea {
                            id: originalCardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 16
                            
                            // Ícone
                            Rectangle {
                                Layout.preferredWidth: 48
                                Layout.preferredHeight: 48
                                Layout.alignment: Qt.AlignTop
                                radius: 8
                                color: Qt.rgba(0.23, 0.51, 0.96, 0.1)
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🏆"
                                    font.pixelSize: 24
                                }
                            }
                            
                            // Conteúdo
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 8
                                
                                Text {
                                    text: "Projeto Original"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: mainWindow.textColor
                                }
                                
                                Text {
                                    text: "<b>The Augmented Reality Sandbox</b> desenvolvido pelo Centro W.M. Keck para Visualização Ativa em Ciências da Terra da UC Davis (KeckCAVES)"
                                    font.pixelSize: 14
                                    color: mainWindow.mutedTextColor
                                    wrapMode: Text.WordWrap
                                    textFormat: Text.RichText
                                    Layout.fillWidth: true
                                    lineHeight: 1.4
                                }
                                
                                Text {
                                    text: "Com apoio da National Science Foundation sob a concessão nº DRL 1114663"
                                    font.pixelSize: 12
                                    color: mainWindow.mutedTextColor
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                                
                                Item { Layout.fillHeight: true }
                                
                                Text {
                                    text: "<a href='https://arsandbox.ucdavis.edu' style='color: #3b82f6; text-decoration: none; font-weight: 500;'>🔗 arsandbox.ucdavis.edu</a>"
                                    font.pixelSize: 14
                                    textFormat: Text.RichText
                                    onLinkActivated: Qt.openUrlExternally(link)
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        acceptedButtons: Qt.NoButton
                                    }
                                }
                            }
                        }
                    }
                    
                    // Card 2: Adaptação Brasileira
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        radius: 12
                        border.width: 2
                        border.color: Qt.rgba(0.55, 0.36, 0.96, 0.2)
                        
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(0.55, 0.36, 0.96, 0.05) }
                            GradientStop { position: 1.0; color: Qt.rgba(0.55, 0.36, 0.96, 0.1) }
                        }
                        
                        MouseArea {
                            id: brazilCardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 16
                            
                            // Ícone
                            Rectangle {
                                Layout.preferredWidth: 48
                                Layout.preferredHeight: 48
                                Layout.alignment: Qt.AlignTop
                                radius: 8
                                color: Qt.rgba(0.55, 0.36, 0.96, 0.1)
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🏫"
                                    font.pixelSize: 24
                                }
                            }
                            
                            // Conteúdo
                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 8
                                
                                Text {
                                    text: "Adaptação Brasileira"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: mainWindow.textColor
                                }
                                
                                Text {
                                    text: "<b>Projeto Caixa de Areia Interativa</b> - Modificado para fins educacionais"
                                    font.pixelSize: 14
                                    color: mainWindow.mutedTextColor
                                    wrapMode: Text.WordWrap
                                    textFormat: Text.RichText
                                    Layout.fillWidth: true
                                    lineHeight: 1.4
                                }
                                
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8
                                    
                                    Text {
                                        text: "📍"
                                        font.pixelSize: 18
                                    }
                                    
                                    Text {
                                        text: "Escola Rangel Torres - Rio Branco, MT"
                                        font.pixelSize: 14
                                        color: mainWindow.textColor
                                    }
                                }
                                
                                Item { Layout.fillHeight: true }
                                
                                Text {
                                    text: "<a href='https://caixade-areia.com' style='color: #8b5cf6; text-decoration: none; font-weight: 500;'>🔗 caixade-areia.com</a>"
                                    font.pixelSize: 14
                                    textFormat: Text.RichText
                                    onLinkActivated: Qt.openUrlExternally(link)
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        acceptedButtons: Qt.NoButton
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Card Recursos Adicionais
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    radius: 12
                    border.width: 1
                    border.color: Qt.rgba(0.02, 0.73, 0.84, 0.2)
                    
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0.02, 0.73, 0.84, 0.05) }
                        GradientStop { position: 1.0; color: Qt.rgba(0.02, 0.73, 0.84, 0.1) }
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16
                        
                        // Ícone
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 8
                            color: Qt.rgba(0.02, 0.73, 0.84, 0.1)
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🔗"
                                font.pixelSize: 20
                            }
                        }
                        
                        // Conteúdo
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            
                            Text {
                                text: "Recursos Adicionais"
                                font.pixelSize: 16
                                font.bold: true
                                color: mainWindow.textColor
                            }
                            
                            GridLayout {
                                Layout.fillWidth: true
                                columns: 2
                                columnSpacing: 24
                                rowSpacing: 12
                                
                                Text {
                                    text: "<a href='https://caixae-agua.blogspot.com/' style='color: #64748b; text-decoration: none;'>🔗 Blog Caixa e-Água</a>"
                                    font.pixelSize: 14
                                    textFormat: Text.RichText
                                    onLinkActivated: Qt.openUrlExternally(link)
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        acceptedButtons: Qt.NoButton
                                    }
                                }
                                
                                Text {
                                    text: "<a href='https://github.com/KeckCAVES/SARndbox' style='color: #64748b; text-decoration: none;'>🔗 GitHub do projeto original</a>"
                                    font.pixelSize: 14
                                    textFormat: Text.RichText
                                    onLinkActivated: Qt.openUrlExternally(link)
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        acceptedButtons: Qt.NoButton
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Separador
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: mainWindow.borderColor
                }
                
                // Footer
                Text {
                    text: "🌍 Projeto de código aberto para educação e pesquisa científica em geografia e hidrografia"
                    font.pixelSize: 14
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    lineHeight: 1.4
                }
            }
        }
        
        // Espaço no final
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
    }
}
