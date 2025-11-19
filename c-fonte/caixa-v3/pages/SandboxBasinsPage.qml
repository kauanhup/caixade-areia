import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Item {
    id: sandboxBasinsPage
    
    property int selectedBasin: -1
    
    // Conexões com o backend C++
    Connections {
        target: basinManager
        
        function onBasinLoaded(index, name) {
            console.log("✅ Bacia carregada:", name)
            statusText.text = "✅ " + name + " carregada!"
            statusText.color = "#10b981"
            statusText.visible = true
            statusTimer.restart()
        }
        
        function onBasinProjected() {
            console.log("🎬 Bacia projetada")
            statusText.text = "🎬 Projetando bacia..."
            statusText.color = "#3b82f6"
            statusText.visible = true
            statusTimer.restart()
        }
        
        function onBasinError(error) {
            console.log("❌ Erro:", error)
            statusText.text = "❌ " + error
            statusText.color = "#ef4444"
            statusText.visible = true
            statusTimer.restart()
        }
        
        function onValidationResult(percentage) {
            console.log("📊 Validação:", percentage + "%")
            validationDialog.percentual = percentage
            validationDialog.visible = true
        }
    }
    
    Timer {
        id: statusTimer
        interval: 5000
        onTriggered: {
            statusText.visible = false
        }
    }
    
    // Fundo
    Rectangle {
        anchors.fill: parent
        color: mainWindow.backgroundColor
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header fixo no topo
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Qt.rgba(1, 1, 1, 0.9)
            border.color: mainWindow.borderColor
            border.width: 1
            z: 10
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                
                // Botão voltar
                Button {
                    text: "⬅ Voltar"
                    font.pixelSize: 13
                    
                    background: Rectangle {
                        color: parent.hovered ? Qt.rgba(0, 0, 0, 0.05) : "transparent"
                        radius: 6
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 13
                        color: mainWindow.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: mainWindow.navigate("workspace")
                }
                
                // Info do header
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    
                    Text {
                        text: ""
                        font.pixelSize: 18
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Text {
                        text: ""
                        font.pixelSize: 12
                        color: mainWindow.mutedTextColor
                    }
                }
                
                // Status text
                Text {
                    id: statusText
                    font.pixelSize: 12
                    visible: false
                }
            }
        }
        
        // Área de conteúdo com scroll
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: sandboxBasinsPage.width
                spacing: 24
                
                // Espaçamento topo
                Item { 
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24 
                }
                
                // Título da seção
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    spacing: 8
                    
                    Text {
                        text: "Modelos de Bacias Hidrográficas"
                        font.pixelSize: 24
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Text {
                        text: "Carregue modelos pré-configurados de bacias famosas"
                        font.pixelSize: 14
                        color: mainWindow.mutedTextColor
                    }
                }
                
                // Grid de cards (3 colunas)
                GridLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    columns: 3
                    columnSpacing: 16
                    rowSpacing: 16
                    
                    Repeater {
                        model: [
                            {name: "modelo 1", area: "7M km²", desc: "Maior bacia hidrográfica do mundo", color: mainWindow.successColor, file: "modelo_1.png"},
                            {name: "Delta do Nilo", area: "24K km²", desc: "Região fértil do Egito antigo", color: mainWindow.warningColor, file: "modelo_2.png"},
                            {name: "Bacia do Paraná", area: "2.8M km²", desc: "Segunda maior da América do Sul", color: mainWindow.secondaryColor, file: "modelo_3.png"},
                            {name: "Rio Colorado", area: "637K km²", desc: "Essencial para o oeste dos EUA", color: mainWindow.accentColor, file: "modelo_4.png"},
                            {name: "Rio Yangtzé", area: "1.8M km²", desc: "Maior rio da Ásia", color: mainWindow.primaryColor, file: "modelo_5.png"},
                            {name: "Rio Mississipi", area: "3.2M km²", desc: "Principal via fluvial dos EUA", color: mainWindow.accentColor, file: "modelo_6.png"}
                        ]
                        
                        // Card individual
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: selectedBasin === index ? 500 : 380
                            Layout.minimumWidth: 200
                            
                            color: mainWindow.cardColor
                            radius: 12
                            border.width: selectedBasin === index ? 2 : 1
                            border.color: selectedBasin === index ? modelData.color : mainWindow.borderColor
                            clip: true
                            
                            property bool hovered: false
                            
                            Behavior on Layout.preferredHeight {
                                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                            }
                            
                            // Sombra
                            layer.enabled: hovered || selectedBasin === index
                            layer.effect: DropShadow {
                                color: "#40000000"
                                radius: 16
                                samples: 33
                                horizontalOffset: 0
                                verticalOffset: 4
                            }
                            
                            Behavior on border.color {
                                ColorAnimation { duration: 300 }
                            }
                            
                            Behavior on border.width {
                                NumberAnimation { duration: 300 }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.hovered = true
                                onExited: parent.hovered = false
                                propagateComposedEvents: true
                                onPressed: mouse.accepted = false
                            }
                            
                            Column {
                                anchors.fill: parent
                                spacing: 0
                                
                                // Imagem
                                Rectangle {
                                    width: parent.width
                                    height: 180
                                    clip: true
                                    color: "#f1f5f9"
                                    
                                    // Tentar carregar imagem real
                                    Image {
                                        id: basinImage
                                        anchors.fill: parent
                                        source: "qrc:/assets/images/" + modelData.file
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        smooth: true
                                        
                                        onStatusChanged: {
                                            if (status === Image.Error) {
                                                console.log("❌ Erro ao carregar:", modelData.file)
                                            } else if (status === Image.Ready) {
                                                console.log("✅ Imagem carregada:", modelData.file)
                                            }
                                        }
                                    }
                                    
                                    // Fallback: Gradiente
                                    Rectangle {
                                        anchors.fill: parent
                                        visible: basinImage.status !== Image.Ready
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "#64748b" }
                                            GradientStop { position: 1.0; color: "#94a3b8" }
                                        }
                                    }
                                    
                                    // Indicador de carregamento
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 50
                                        height: 50
                                        radius: 25
                                        color: Qt.rgba(0, 0, 0, 0.5)
                                        visible: basinImage.status === Image.Loading
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "⏳"
                                            font.pixelSize: 28
                                            
                                            RotationAnimation on rotation {
                                                loops: Animation.Infinite
                                                from: 0
                                                to: 360
                                                duration: 1500
                                            }
                                        }
                                    }
                                    
                                    // Badge de status (canto superior direito)
                                    Rectangle {
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.margins: 12
                                        width: selectedBasin === index ? 80 : 0
                                        height: 28
                                        radius: 14
                                        color: modelData.color
                                        visible: selectedBasin === index
                                        
                                        Behavior on width {
                                            NumberAnimation { duration: 300 }
                                        }
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "✓ Ativa"
                                            color: "white"
                                            font.pixelSize: 11
                                            font.bold: true
                                        }
                                    }
                                }
                                
                                // Conteúdo
                                Column {
                                    width: parent.width
                                    padding: 16
                                    spacing: 12
                                    
                                    // Info básica
                                    Column {
                                        width: parent.width - 32
                                        spacing: 6
                                        
                                        Text {
                                            text: modelData.name
                                            font.pixelSize: 16
                                            font.bold: true
                                            color: mainWindow.textColor
                                            wrapMode: Text.WordWrap
                                            width: parent.width
                                        }
                                        
                                        Text {
                                            text: "📍 " + modelData.area
                                            font.pixelSize: 12
                                            color: mainWindow.mutedTextColor
                                        }
                                        
                                        Text {
                                            text: modelData.desc
                                            font.pixelSize: 12
                                            color: mainWindow.mutedTextColor
                                            wrapMode: Text.WordWrap
                                            width: parent.width
                                        }
                                    }
                                    
                                    // Botão Carregar
                                    Button {
                                        width: parent.width - 32
                                        height: 38
                                        
                                        background: Rectangle {
                                            color: selectedBasin === index ? modelData.color : mainWindow.secondaryColor
                                            radius: 6
                                            opacity: parent.pressed ? 0.8 : parent.hovered ? 0.9 : 1
                                            
                                            Behavior on color {
                                                ColorAnimation { duration: 300 }
                                            }
                                            
                                            Behavior on opacity {
                                                NumberAnimation { duration: 150 }
                                            }
                                        }
                                        
                                        contentItem: Text {
                                            text: selectedBasin === index ? "✓ Carregado" : "Carregar Bacia"
                                            color: "white"
                                            font.pixelSize: 13
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        
                                        onClicked: {
                                            selectedBasin = index
                                            basinManager.loadBasin(index)
                                        }
                                    }
                                    
                                    // Botões de ação (aparecem quando selecionado)
                                    Column {
                                        width: parent.width - 32
                                        spacing: 8
                                        visible: opacity > 0
                                        opacity: selectedBasin === index ? 1 : 0
                                        height: selectedBasin === index ? implicitHeight : 0
                                        clip: true
                                        
                                        Behavior on opacity {
                                            NumberAnimation { duration: 300 }
                                        }
                                        
                                        Behavior on height {
                                            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                                        }
                                        
                                        // Linha separadora
                                        Rectangle {
                                            width: parent.width
                                            height: 1
                                            color: mainWindow.borderColor
                                            opacity: 0.5
                                        }
                                        
                                        Button {
                                            width: parent.width
                                            height: 36
                                            
                                            background: Rectangle {
                                                color: mainWindow.primaryColor
                                                radius: 6
                                                opacity: parent.pressed ? 0.8 : parent.hovered ? 0.9 : 1
                                            }
                                            
                                            contentItem: Text {
                                                text: "🎬 Projetar"
                                                color: "white"
                                                font.pixelSize: 12
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            
                                            onClicked: basinManager.projectBasin()
                                        }
                                        
                                        Button {
                                            width: parent.width
                                            height: 36
                                            
                                            background: Rectangle {
                                                color: mainWindow.accentColor
                                                radius: 6
                                                opacity: parent.pressed ? 0.8 : parent.hovered ? 0.9 : 1
                                            }
                                            
                                            contentItem: Text {
                                                text: "👁️ Visualizar"
                                                color: "white"
                                                font.pixelSize: 12
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            
                                            onClicked: basinManager.visualizeBasin()
                                        }
                                        
                                        Button {
                                            width: parent.width
                                            height: 36
                                            
                                            background: Rectangle {
                                                color: mainWindow.warningColor
                                                radius: 6
                                                opacity: parent.pressed ? 0.8 : parent.hovered ? 0.9 : 1
                                            }
                                            
                                            contentItem: Text {
                                                text: "✓ Validar"
                                                color: "white"
                                                font.pixelSize: 12
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                            
                                            onClicked: basinManager.validateBasin()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Espaçamento final
                Item { 
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40 
                }
            }
        }
    }
    
    // Dialog de validação
    Rectangle {
        id: validationDialog
        anchors.centerIn: parent
        width: 400
        height: 200
        radius: 12
        color: "white"
        border.color: mainWindow.borderColor
        border.width: 2
        visible: false
        z: 100
        
        property int percentual: 0
        
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#60000000"
            radius: 24
            samples: 49
            horizontalOffset: 0
            verticalOffset: 8
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16
            
            Text {
                text: "📊 Resultado da Validação"
                font.pixelSize: 18
                font.bold: true
                color: mainWindow.textColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Você acertou " + validationDialog.percentual + "%"
                font.pixelSize: 24
                font.bold: true
                color: validationDialog.percentual >= 70 ? mainWindow.successColor : mainWindow.warningColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                text: "Fechar"
                Layout.alignment: Qt.AlignHCenter
                
                background: Rectangle {
                    color: mainWindow.primaryColor
                    radius: 6
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: validationDialog.visible = false
            }
        }
    }
}
