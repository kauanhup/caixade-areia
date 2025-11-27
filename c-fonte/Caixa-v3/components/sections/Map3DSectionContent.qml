import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ScrollView {
    id: scrollView
    clip: true
    
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    
    contentWidth: availableWidth
    
    property bool displayConfigExpanded: false
    
    ColumnLayout {
        width: scrollView.availableWidth
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
            border.width: 1
            
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
                    
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 8
                        color: displayConfigExpanded ? Qt.rgba(0.5, 0.3, 0.8, 0.1) : Qt.rgba(0, 0, 0, 0.05)
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⚙️"
                            font.pixelSize: 24
                        }
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
                            text: displayConfigExpanded ? "Escolha o monitor/TV onde aparecerá a vista 3D navegável" : "Clique para expandir configurações"
                            font.pixelSize: 12
                            color: mainWindow.mutedTextColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                    
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 16
                        color: headerMouseArea.containsMouse ? Qt.rgba(0, 0, 0, 0.05) : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: displayConfigExpanded ? "▼" : "▶"
                            font.pixelSize: 14
                            color: mainWindow.mutedTextColor
                        }
                    }
                    
                    MouseArea {
                        id: headerMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        
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
                            height: 60
                            radius: 8
                            color: displayMouseArea.containsMouse ? Qt.rgba(0.5, 0.3, 0.8, 0.05) : "transparent"
                            border.color: mainWindow.borderColor
                            border.width: 1
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: model.isPrimary ? Qt.rgba(0.2, 0.5, 1.0, 0.1) : Qt.rgba(0.5, 0.3, 0.8, 0.1)
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.isPrimary ? "🖥️" : "📺"
                                        font.pixelSize: 20
                                    }
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    
                                    Text {
                                        text: model.name
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: mainWindow.textColor
                                    }
                                    
                                    Text {
                                        text: model.isPrimary ? "Principal (Projetor)" : "Secundário - Use para vista 3D"
                                        font.pixelSize: 11
                                        color: mainWindow.mutedTextColor
                                    }
                                }
                                
                                Button {
                                    id: useDisplayBtn
                                    text: "Usar"
                                    visible: !model.isPrimary
                                    padding: 10
                                    
                                    background: Rectangle {
                                        color: useDisplayBtn.pressed ? Qt.darker(mainWindow.primaryColor, 1.2) : 
                                               useDisplayBtn.hovered ? Qt.lighter(mainWindow.primaryColor, 1.1) : 
                                               mainWindow.primaryColor
                                        radius: 6
                                        
                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }
                                        
                                        scale: useDisplayBtn.pressed ? 0.95 : 1.0
                                        
                                        Behavior on scale {
                                            NumberAnimation { duration: 100 }
                                        }
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: "white"
                                        font.pixelSize: 12
                                        font.bold: true
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
                                id: displayMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onPressed: mouse.accepted = false
                            }
                        }
                    }
                    
                    Button {
                        id: redetectBtn
                        text: "🔄 Redetectar Displays"
                        Layout.alignment: Qt.AlignHCenter
                        padding: 10
                        
                        background: Rectangle {
                            color: redetectBtn.pressed ? Qt.darker(mainWindow.secondaryColor, 1.2) : 
                                   redetectBtn.hovered ? Qt.lighter(mainWindow.secondaryColor, 1.1) : 
                                   mainWindow.secondaryColor
                            radius: 6
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                            
                            scale: redetectBtn.pressed ? 0.95 : 1.0
                            
                            Behavior on scale {
                                NumberAnimation { duration: 100 }
                            }
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: 12
                            font.bold: true
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
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        
        // Card principal do Sandbox 3D
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            radius: 12
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#faf5ff" }
                GradientStop { position: 1.0; color: "#e0e7ff" }
            }
            border.color: mainWindow.borderColor
            border.width: 1
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "Sandbox 3D Interativa"
                    font.pixelSize: 22
                    font.bold: true
                    color: mainWindow.textColor
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: "Projetor: Visão de cima (fixa)\nMonitor: Vista 3D navegável (rotação livre)"
                    font.pixelSize: 13
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                    lineHeight: 1.4
                }
                
                Row {
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter
                    
                    Repeater {
                        model: [
                            {icon: "🔄", text: "Rotação 360°"},
                            {icon: "👁️", text: "Vista Realista"},
                            {icon: "💧", text: "Água 3D"}
                        ]
                        
                        Rectangle {
                            width: 130
                            height: 32
                            radius: 16
                            color: Qt.rgba(1, 1, 1, 0.6)
                            border.color: Qt.rgba(0.5, 0.3, 0.8, 0.2)
                            border.width: 1
                            
                            Row {
                                anchors.centerIn: parent
                                spacing: 6
                                
                                Text {
                                    text: modelData.icon
                                    font.pixelSize: 14
                                }
                                
                                Text {
                                    text: modelData.text
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: mainWindow.mutedTextColor
                                }
                            }
                        }
                    }
                }
                
                Button {
                    id: sandbox3DButton
                    text: "🚀 Abrir Sandbox 3D"
                    Layout.alignment: Qt.AlignHCenter
                    padding: 14
                    
                    background: Rectangle {
                        color: sandbox3DButton.pressed ? Qt.darker(mainWindow.secondaryColor, 1.2) : 
                               sandbox3DButton.hovered ? Qt.lighter(mainWindow.secondaryColor, 1.1) : 
                               mainWindow.secondaryColor
                        radius: 8
                        
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                        
                        scale: sandbox3DButton.pressed ? 0.96 : 1.0
                        
                        Behavior on scale {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "white"
                            opacity: sandbox3DButton.hovered ? 0.1 : 0
                            
                            Behavior on opacity {
                                NumberAnimation { duration: 200 }
                            }
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 15
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        sandboxManager.openSandbox3D()
                    }
                }
                
                Text {
                    id: statusText
                    Layout.fillWidth: true
                    font.pixelSize: 12
                    font.bold: true
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }
            }
        }
        
        // Dica informativa
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: infoLayout.implicitHeight + 24
            radius: 8
            color: Qt.rgba(0.2, 0.5, 1.0, 0.05)
            border.color: Qt.rgba(0.2, 0.5, 1.0, 0.2)
            border.width: 1
            
            RowLayout {
                id: infoLayout
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                
                Text {
                    text: "💡"
                    font.pixelSize: 20
                }
                
                Text {
                    text: "Configure o display secundário acima antes de abrir o modo 3D.\nO modo 2D funciona apenas com o projetor."
                    font.pixelSize: 11
                    color: mainWindow.mutedTextColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    lineHeight: 1.4
                }
            }
        }
    }
}

