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
            configStatusText.text = "✅ " + displays.length + " display(s) encontrado(s)"
            configStatusText.color = "#10b981"
            configStatusText.visible = true
        }
        
        function onConfigurationSuccess() {
            configStatusText.text = "✅ Display 3D configurado com sucesso!"
            configStatusText.color = "#10b981"
            configStatusText.visible = true
            configTimer.restart()
        }
        
        function onConfigurationError(error) {
            configStatusText.text = "❌ " + error
            configStatusText.color = "#ef4444"
            configStatusText.visible = true
            configTimer.restart()
        }
    }
    
    Timer {
        id: statusTimer
        interval: 5000
        onTriggered: {
            statusText.visible = false
        }
    }
    
    Timer {
        id: configTimer
        interval: 5000
        onTriggered: {
            configStatusText.visible = false
        }
    }
    
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 8
        
        Text {
            text: "Visualização 3D"
            font.pixelSize: 24
            font.bold: true
            color: mainWindow.textColor
        }
        
        Text {
            text: "Modelo tridimensional interativo do terreno"
            font.pixelSize: 13
            color: mainWindow.mutedTextColor
        }
    }
    
    // Card de Configuração de Display
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: displayConfigExpanded ? 350 : 80
        radius: 12
        color: mainWindow.cardColor
        border.color: mainWindow.borderColor
        
        Behavior on Layout.preferredHeight {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16
            
            // Header clicável
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Text {
                    text: "⚙️"
                    font.pixelSize: 24
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    
                    Text {
                        text: "Configurar Display Secundário"
                        font.pixelSize: 16
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Text {
                        text: displayConfigExpanded ? "Escolha qual tela usar para visualização 3D" : "Clique para expandir"
                        font.pixelSize: 12
                        color: mainWindow.mutedTextColor
                    }
                }
                
                Text {
                    text: displayConfigExpanded ? "▼" : "▶"
                    font.pixelSize: 16
                    color: mainWindow.mutedTextColor
                    
                    Behavior on rotation {
                        NumberAnimation { duration: 300 }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        displayConfigExpanded = !displayConfigExpanded
                        if (displayConfigExpanded) {
                            displayManager.getAvailableDisplays()
                        }
                    }
                }
            }
            
            // Conteúdo expandido
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12
                visible: displayConfigExpanded
                opacity: displayConfigExpanded ? 1 : 0
                
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
                
                Text {
                    text: "Displays Conectados:"
                    font.pixelSize: 13
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
                        height: 50
                        radius: 8
                        color: mouseArea.containsMouse ? Qt.rgba(0, 0, 0, 0.05) : "transparent"
                        border.color: mainWindow.borderColor
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            
                            Text {
                                text: model.isPrimary ? "🖥️" : "📺"
                                font.pixelSize: 20
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                Text {
                                    text: model.name
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: mainWindow.textColor
                                }
                                
                                Text {
                                    text: model.isPrimary ? "Principal (Projetor)" : "Secundário"
                                    font.pixelSize: 11
                                    color: mainWindow.mutedTextColor
                                }
                            }
                            
                            Button {
                                text: "Usar"
                                visible: !model.isPrimary
                                padding: 8
                                
                                background: Rectangle {
                                    color: parent.pressed ? Qt.darker(mainWindow.primaryColor, 1.1) : mainWindow.primaryColor
                                    radius: 6
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    color: "white"
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                onClicked: {
                                    configStatusText.text = "⏳ Configurando..."
                                    configStatusText.color = mainWindow.mutedTextColor
                                    configStatusText.visible = true
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
                    text: "🔄 Redetectar Displays"
                    Layout.alignment: Qt.AlignHCenter
                    padding: 8
                    
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(mainWindow.secondaryColor, 1.1) : mainWindow.secondaryColor
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
                        displayManager.getAvailableDisplays()
                    }
                }
                
                Text {
                    id: configStatusText
                    Layout.fillWidth: true
                    font.pixelSize: 11
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }
            }
        }
    }
    
    property bool displayConfigExpanded: false
    
    // Card principal do Sandbox 3D
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 280
        radius: 12
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#faf5ff" }
            GradientStop { position: 1.0; color: "#e0e7ff" }
        }
        border.color: mainWindow.borderColor
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16
            
            Text {
                text: "Sandbox 3D Interativa"
                font.pixelSize: 20
                font.bold: true
                color: mainWindow.textColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Explore o terreno em três dimensões com rotação livre,\nzoom e renderização realista do relevo"
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
                        {icon: "🔄", text: "Rotação 360°"},
                        {icon: "👁️", text: "Vista Realista"}
                    ]
                    
                    Rectangle {
                        width: 140
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
                id: sandbox3DButton
                text: "Abrir Sandbox 3D"
                Layout.alignment: Qt.AlignHCenter
                padding: 12
                
                background: Rectangle {
                    color: sandbox3DButton.pressed ? Qt.darker(mainWindow.secondaryColor, 1.1) : mainWindow.secondaryColor
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
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        sandboxManager.openSandbox3D()
                    }
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
