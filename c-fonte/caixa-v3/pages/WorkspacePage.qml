import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: workspacePage
    anchors.fill: parent
    
    property int currentTab: 0  // SEMPRE COMEÇA NA ABA INÍCIO
    
    // Debug
    Component.onCompleted: {
        console.log("WorkspacePage iniciado. Tab atual:", currentTab)
    }
    
    onCurrentTabChanged: {
        console.log("Tab mudou para:", currentTab)
    }
    
    // Fundo gradiente
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8fafc" }
            GradientStop { position: 0.5; color: "#f1f5f9" }
            GradientStop { position: 1.0; color: "#e2e8f0" }
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // ==================== HEADER ====================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: Qt.rgba(1, 1, 1, 0.8)
            border.color: "#e2e8f0"
            border.width: 1
            z: 10
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 0
                
                // Título
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    
                    Text {
                        text: "Caixa de Areia Interativa"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#0f172a"
                    }
                    
                    Text {
                        text: "Sistema de Visualização Topográfica v2.0"
                        font.pixelSize: 11
                        color: "#64748b"
                    }
                }
                
                // Espaçador
                Item { Layout.fillWidth: true }
                
                // Botões
                RowLayout {
                    spacing: 8
                    
                    // Botão Calibrar
                    Rectangle {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 36
                        radius: 8
                        color: calibrarMouse.containsMouse ? Qt.rgba(0,0,0,0.05) : "transparent"
                        
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6
                            
                            Text {
                                text: "⚙"
                                font.pixelSize: 16
                                color: "#64748b"
                            }
                            
                            Text {
                                text: "Calibrar"
                                font.pixelSize: 13
                                color: "#64748b"
                            }
                        }
                        
                        MouseArea {
                            id: calibrarMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Botão Calibrar clicado")
                                currentTab = 6
                            }
                        }
                    }
                    
                    // Botão Sobre
                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 36
                        radius: 8
                        color: sobreMouse.containsMouse ? Qt.rgba(0,0,0,0.05) : "transparent"
                        
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6
                            
                            Text {
                                text: "ℹ"
                                font.pixelSize: 16
                                color: "#64748b"
                            }
                            
                            Text {
                                text: "Sobre"
                                font.pixelSize: 13
                                color: "#64748b"
                            }
                        }
                        
                        MouseArea {
                            id: sobreMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Botão Sobre clicado")
                                currentTab = 7
                            }
                        }
                    }
                }
            }
        }
        
        // ==================== CONTEÚDO ====================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16
                
                // ==================== TABS ====================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: Qt.rgba(1, 1, 1, 0.6)
                    radius: 10
                    border.color: "#e2e8f0"
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 2
                        
                        // Tab: Início
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8
                            color: currentTab === 0 ? "#64748b" : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🏠 Início"
                                font.pixelSize: 13
                                font.bold: currentTab === 0
                                color: currentTab === 0 ? "white" : "#0f172a"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("Tab Início clicada")
                                    currentTab = 0
                                }
                            }
                        }
                        
                        // Tab: Cores
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8
                            color: currentTab === 1 ? "#3b82f6" : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Cores"
                                font.pixelSize: 13
                                font.bold: currentTab === 1
                                color: currentTab === 1 ? "white" : "#0f172a"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("Tab Cores clicada")
                                    currentTab = 1
                                }
                            }
                        }
                        
                        // Tab: Bacias
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8
                            color: currentTab === 2 ? "#8b5cf6" : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Bacias"
                                font.pixelSize: 13
                                font.bold: currentTab === 2
                                color: currentTab === 2 ? "white" : "#0f172a"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentTab = 2
                            }
                        }
                        
                        // Tab: 2D
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8
                            color: currentTab === 3 ? "#06b6d4" : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "2D"
                                font.pixelSize: 13
                                font.bold: currentTab === 3
                                color: currentTab === 3 ? "white" : "#0f172a"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentTab = 3
                            }
                        }
                        
                        // Tab: 3D
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8
                            color: currentTab === 4 ? "#10b981" : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "3D"
                                font.pixelSize: 13
                                font.bold: currentTab === 4
                                color: currentTab === 4 ? "white" : "#0f172a"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentTab = 4
                            }
                        }
                        
                        // Tab: Outros
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 8
                            color: currentTab === 5 ? "#64748b" : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "⋯ Outros"
                                font.pixelSize: 13
                                font.bold: currentTab === 5
                                color: currentTab === 5 ? "white" : "#0f172a"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentTab = 5
                            }
                        }
                    }
                }
                
                // ==================== CONTEÚDO DAS TABS ====================
                Loader {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    source: {
                        switch(currentTab) {
                            case 0: return "../components/sections/HomeSectionContent.qml"
                            case 1: return "../components/sections/ColorsSectionContent.qml"
                            case 2: return "../components/sections/BasinsSectionContent.qml"
                            case 3: return "../components/sections/Map2DSectionContent.qml"
                            case 4: return "../components/sections/Map3DSectionContent.qml"
                            case 5: return "../components/sections/OthersSectionContent.qml"
                            case 6: return "../components/sections/CalibrateSectionContent.qml"
                            case 7: return "../components/sections/AboutSectionContent.qml"
                            default: return "../components/sections/HomeSectionContent.qml"
                        }
                    }
                    
                    onStatusChanged: {
                        if (status === Loader.Error) {
                            console.log("❌ Erro ao carregar:", source)
                        } else if (status === Loader.Ready) {
                            console.log("✅ Carregado:", source)
                        }
                    }
                }
            }
        }
    }
}
