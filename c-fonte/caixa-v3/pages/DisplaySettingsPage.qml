import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    anchors.fill: parent
    color: mainWindow.backgroundColor
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        // Header
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            Text {
                text: "⚙️ Configuração de Displays"
                font.pixelSize: 28
                font.bold: true
                color: mainWindow.textColor
            }
            
            Text {
                text: "Configure qual tela será usada para a visualização 3D"
                font.pixelSize: 14
                color: mainWindow.mutedTextColor
            }
        }
        
        // Lista de displays detectados
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            radius: 12
            color: mainWindow.cardColor
            border.color: mainWindow.borderColor
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16
                
                Text {
                    text: "Displays Conectados:"
                    font.pixelSize: 16
                    font.bold: true
                    color: mainWindow.textColor
                }
                
                ListView {
                    id: displaysList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8
                    clip: true
                    
                    model: ListModel {
                        id: displaysModel
                    }
                    
                    delegate: Rectangle {
                        width: displaysList.width
                        height: 60
                        radius: 8
                        color: mouseArea.containsMouse ? Qt.rgba(0, 0, 0, 0.05) : "transparent"
                        border.color: mainWindow.borderColor
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            
                            Text {
                                text: model.isPrimary ? "🖥️" : "📺"
                                font.pixelSize: 24
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                
                                Text {
                                    text: model.name
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: mainWindow.textColor
                                }
                                
                                Text {
                                    text: model.isPrimary ? "Display Principal (Projetor)" : "Display Secundário"
                                    font.pixelSize: 12
                                    color: mainWindow.mutedTextColor
                                }
                            }
                            
                            Button {
                                text: "Usar para 3D"
                                visible: !model.isPrimary
                                
                                background: Rectangle {
                                    color: mainWindow.primaryColor
                                    radius: 6
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    color: "white"
                                    font.pixelSize: 12
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                onClicked: {
                                    statusText.text = "⏳ Configurando..."
                                    statusText.color = mainWindow.mutedTextColor
                                    statusText.visible = true
                                    displayManager.configureSecondDisplay(model.name)
                                }
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            propagateComposedEvents: true
                        }
                    }
                }
                
                Button {
                    text: "🔄 Detectar Displays"
                    Layout.alignment: Qt.AlignHCenter
                    
                    background: Rectangle {
                        color: mainWindow.secondaryColor
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        detectDisplays()
                    }
                }
            }
        }
        
        Text {
            id: statusText
            Layout.fillWidth: true
            font.pixelSize: 13
            color: mainWindow.mutedTextColor
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }
        
        Item {
            Layout.fillHeight: true
        }
        
        Button {
            text: "← Voltar"
            Layout.alignment: Qt.AlignLeft
            
            background: Rectangle {
                color: "transparent"
                border.color: mainWindow.borderColor
                radius: 8
            }
            
            contentItem: Text {
                text: parent.text
                color: mainWindow.textColor
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: mainWindow.navigate("workspace")
        }
    }
    
    Connections {
        target: displayManager
        
        function onDisplaysDetected(displays) {
            displaysModel.clear()
            var primary = displayManager.getPrimaryDisplay()
            
            for (var i = 0; i < displays.length; i++) {
                displaysModel.append({
                    name: displays[i],
                    isPrimary: displays[i] === primary
                })
            }
            
            console.log("Displays detectados:", displays.length)
        }
        
        function onConfigurationSuccess() {
            statusText.text = "✅ Display configurado com sucesso!"
            statusText.color = "#10b981"
            statusText.visible = true
        }
        
        function onConfigurationError(error) {
            statusText.text = "❌ " + error
            statusText.color = "#ef4444"
            statusText.visible = true
        }
    }
    
    Component.onCompleted: {
        detectDisplays()
    }
    
    function detectDisplays() {
        statusText.text = "🔍 Detectando displays..."
        statusText.color = mainWindow.mutedTextColor
        statusText.visible = true
        displayManager.getAvailableDisplays()
    }
}
