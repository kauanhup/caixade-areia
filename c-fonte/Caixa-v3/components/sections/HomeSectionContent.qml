import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ScrollView {
    id: homeScroll
    clip: true
    contentWidth: availableWidth
    
    ColumnLayout {
        width: Math.min(homeScroll.width - 48, 1280)
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 24
        
        // Espaço no topo
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
        
        // Hero Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            border.color: mainWindow.borderColor
            border.width: 1
            
            Text {
                anchors.centerIn: parent
                width: parent.width - 64
                text: "Sistema de visualização topográfica em tempo real para educação e pesquisa em geografia e hidrografia"
                font.pixelSize: 18
                color: mainWindow.mutedTextColor
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
        
        // Features Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: contentColumn.height + 48
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            border.color: mainWindow.borderColor
            border.width: 1
            
            ColumnLayout {
                id: contentColumn
                width: parent.width - 48
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 24
                spacing: 16
                
                // Header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 8
                        color: Qt.rgba(0.23, 0.51, 0.96, 0.1)
                        
                        Text {
                            anchors.centerIn: parent
                            text: "ℹ"
                            font.pixelSize: 20
                            color: mainWindow.primaryColor
                        }
                    }
                    
                    Text {
                        text: "Recursos do Sistema"
                        font.pixelSize: 18
                        font.bold: true
                        color: mainWindow.textColor
                    }
                }
                
                // Grid de features
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 16
                    rowSpacing: 16
                    
                    Repeater {
                        model: [
                            {text: "Calibração ajustável de sensores", color: mainWindow.primaryColor},
                            {text: "Visualização de curvas de nível", color: mainWindow.secondaryColor},
                            {text: "Simulação de bacias hidrográficas", color: mainWindow.accentColor},
                            {text: "Controles de câmera 3D", color: mainWindow.successColor},
                            {text: "Exportação de vistas e dados", color: mainWindow.warningColor},
                            {text: "Interface responsiva e intuitiva", color: mainWindow.primaryColor}
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 52
                            radius: 8
                            color: Qt.rgba(0.98, 0.98, 0.98, 0.5)
                            border.color: Qt.rgba(0, 0, 0, 0.05)
                            border.width: 1
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Rectangle {
                                    Layout.preferredWidth: 8
                                    Layout.preferredHeight: 8
                                    radius: 4
                                    color: modelData.color
                                }
                                
                                Text {
                                    text: modelData.text
                                    font.pixelSize: 14
                                    color: mainWindow.textColor
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Credits Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.5)
            border.color: mainWindow.borderColor
            border.width: 1
            
            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width - 48
                spacing: 12
                
                Text {
                    text: "📍 Escola Rangel Torres - Rio Branco, MT"
                    font.pixelSize: 16
                    font.bold: true
                    color: mainWindow.textColor
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                
                Text {
                    text: "Projeto educacional baseado no Augmented Reality Sandbox"
                    font.pixelSize: 14
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                
                RowLayout {
                    spacing: 16
                    Layout.alignment: Qt.AlignHCenter
                    
                    Text {
                        text: "<a href='https://caixade-areia.com' style='color: #3b82f6; text-decoration: none; font-weight: 500;'>caixade-areia.com →</a>"
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
                        text: "<a href='https://arsandbox.ucdavis.edu' style='color: #64748b; text-decoration: none;'>UC Davis →</a>"
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
        
        // Espaço no final
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
    }
}
