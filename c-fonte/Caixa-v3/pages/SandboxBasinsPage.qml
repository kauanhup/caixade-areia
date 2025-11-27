// VERSÃO FINAL - ESC FUNCIONANDO E IMAGEM TELA CHEIA

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import QtQuick.Window 2.12

Item {
    id: sandboxBasinsPage
    
    property int selectedBasin: -1
    
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
        
        function onValidationProgress(stage, progress) {
            console.log("📊 Progresso:", stage, progress + "%")
            validationDialog.progressText = stage
            validationDialog.progressValue = progress
            validationDialog.showProgress = true
            validationDialog.showResult = false
            validationDialog.visible = true
        }
        
        function onCaptureReady(path) {
            console.log("📸 Captura pronta:", path)
            validationDialog.capturePath = "file://" + path
        }
        
        function onDifferenceReady(path) {
            console.log("🎨 Diferença pronta:", path)
            validationDialog.differencePath = "file://" + path
        }
        
        function onValidationResult(percentage) {
            console.log("✅ Resultado final:", percentage + "%")
            console.log("   Mudando showProgress false → showResult true")
            validationDialog.percentual = percentage
            validationDialog.showProgress = false
            validationDialog.showResult = true
        }
    }
    
    Timer {
        id: statusTimer
        interval: 5000
        onTriggered: statusText.visible = false
    }
    
    Rectangle {
        anchors.fill: parent
        color: mainWindow.backgroundColor
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
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
                
                Text {
                    id: statusText
                    font.pixelSize: 12
                    visible: false
                }
            }
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: sandboxBasinsPage.width
                spacing: 24
                
                Item { 
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24 
                }
                
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
                
                GridLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    columns: 3
                    columnSpacing: 16
                    rowSpacing: 16
                    
                    Repeater {
                        model: [
                            {name: "Modelo 1", area: "7M km²", desc: "Maior bacia hidrográfica do mundo", color: mainWindow.successColor, file: "modelo_1.png"},
                            {name: "Delta do Nilo", area: "24K km²", desc: "Região fértil do Egito antigo", color: mainWindow.warningColor, file: "modelo_2.png"},
                            {name: "Bacia do Paraná", area: "2.8M km²", desc: "Segunda maior da América do Sul", color: mainWindow.secondaryColor, file: "modelo_3.png"},
                            {name: "Rio Colorado", area: "637K km²", desc: "Essencial para o oeste dos EUA", color: mainWindow.accentColor, file: "modelo_4.png"},
                            {name: "Rio Yangtzé", area: "1.8M km²", desc: "Maior rio da Ásia", color: mainWindow.primaryColor, file: "modelo_5.png"},
                            {name: "Rio Mississippi", area: "3.2M km²", desc: "Principal via fluvial dos EUA", color: mainWindow.accentColor, file: "modelo_6.png"}
                        ]
                        
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
                            
                            layer.enabled: hovered || selectedBasin === index
                            layer.effect: DropShadow {
                                color: "#40000000"
                                radius: 16
                                samples: 33
                                horizontalOffset: 0
                                verticalOffset: 4
                            }
                            
                            Behavior on border.color { ColorAnimation { duration: 300 } }
                            Behavior on border.width { NumberAnimation { duration: 300 } }
                            
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
                                
                                Rectangle {
                                    width: parent.width
                                    height: 180
                                    clip: true
                                    color: "#f1f5f9"
                                    
                                    Image {
                                        id: basinImage
                                        anchors.fill: parent
                                        source: "qrc:/assets/images/" + modelData.file
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        smooth: true
                                        
                                        onStatusChanged: {
                                            if (status === Image.Error) {
                                                console.log("❌ Erro:", modelData.file)
                                            } else if (status === Image.Ready) {
                                                console.log("✅ OK:", modelData.file)
                                            }
                                        }
                                    }
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        visible: basinImage.status !== Image.Ready
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "#64748b" }
                                            GradientStop { position: 1.0; color: "#94a3b8" }
                                        }
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: basinImage.status === Image.Loading ? "Carregando..." : "Imagem não encontrada"
                                            color: "white"
                                            font.pixelSize: 12
                                        }
                                    }
                                    
                                    Rectangle {
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.margins: 12
                                        width: selectedBasin === index ? 80 : 0
                                        height: 28
                                        radius: 14
                                        color: modelData.color
                                        visible: selectedBasin === index
                                        
                                        Behavior on width { NumberAnimation { duration: 300 } }
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "✓ Ativa"
                                            color: "white"
                                            font.pixelSize: 11
                                            font.bold: true
                                        }
                                    }
                                }
                                
                                Column {
                                    width: parent.width
                                    padding: 16
                                    spacing: 12
                                    
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
                                    
                                    Button {
                                        width: parent.width - 32
                                        height: 38
                                        
                                        background: Rectangle {
                                            color: selectedBasin === index ? modelData.color : mainWindow.secondaryColor
                                            radius: 6
                                            opacity: parent.pressed ? 0.8 : parent.hovered ? 0.9 : 1
                                            Behavior on color { ColorAnimation { duration: 300 } }
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
                                    
                                    Column {
                                        width: parent.width - 32
                                        spacing: 8
                                        visible: opacity > 0
                                        opacity: selectedBasin === index ? 1 : 0
                                        height: selectedBasin === index ? implicitHeight : 0
                                        clip: true
                                        
                                        Behavior on opacity { NumberAnimation { duration: 300 } }
                                        Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                                        
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
                
                Item { 
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40 
                }
            }
        }
    }
    
    // ============ DIALOG DE VALIDAÇÃO ============
    Rectangle {
        id: validationDialog
        anchors.centerIn: parent
        width: 700
        height: showResult ? 600 : 200
        radius: 12
        color: "white"
        border.color: mainWindow.borderColor
        border.width: 2
        visible: false
        z: 100
        
        property int percentual: 0
        property bool showProgress: false
        property bool showResult: false
        property string progressText: ""
        property int progressValue: 0
        property string capturePath: ""
        property string differencePath: ""
        
        onShowResultChanged: {
            console.log("🔄 showResult mudou para:", showResult)
            if (showResult) {
                height = 610
                Qt.callLater(function() { height = 600 })
            }
        }
        
        Behavior on height {
            NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
        }
        
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#60000000"
            radius: 24
            samples: 49
            horizontalOffset: 0
            verticalOffset: 8
        }
        
        // ===== BARRA DE PROGRESSO =====
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            visible: validationDialog.showProgress && !validationDialog.showResult
            opacity: visible ? 1 : 0
            
            Behavior on opacity { NumberAnimation { duration: 300 } }
            
            Text {
                text: "⏳ Validando Modelo"
                font.pixelSize: 18
                font.bold: true
                color: mainWindow.textColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: validationDialog.progressText
                font.pixelSize: 14
                color: mainWindow.mutedTextColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: "#e2e8f0"
                
                Rectangle {
                    width: parent.width * (validationDialog.progressValue / 100)
                    height: parent.height
                    radius: parent.radius
                    color: mainWindow.primaryColor
                    Behavior on width { NumberAnimation { duration: 300 } }
                }
            }
            
            Text {
                text: validationDialog.progressValue + "%"
                font.pixelSize: 14
                font.bold: true
                color: mainWindow.primaryColor
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // ===== RESULTADO =====
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            visible: validationDialog.showResult
            opacity: visible ? 1 : 0
            
            Behavior on opacity { NumberAnimation { duration: 400 } }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                
                Text {
                    text: "📊 Resultado da Validação"
                    font.pixelSize: 20
                    font.bold: true
                    color: mainWindow.textColor
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 120
                    height: 120
                    radius: 60
                    color: {
                        if (validationDialog.percentual >= 70) {
                            return "#10b981"
                        } else if (validationDialog.percentual >= 50) {
                            return "#f59e0b"
                        } else {
                            return "#ef4444"
                        }
                    }
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            text: validationDialog.percentual + "%"
                            font.pixelSize: 36
                            font.bold: true
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: validationDialog.percentual >= 70 ? "Ótimo!" : 
                                  validationDialog.percentual >= 50 ? "Bom" : 
                                  "Tente novamente"
                            font.pixelSize: 12
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
            
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                columnSpacing: 12
                rowSpacing: 8
                
                // ===== CAPTURA =====
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    
                    Text {
                        text: "📸 Sua Captura (clique p/ ampliar)"
                        font.pixelSize: 12
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 150
                        color: "#f1f5f9"
                        radius: 6
                        border.color: mainWindow.borderColor
                        border.width: 1
                        clip: true
                        
                        property bool hovered: false
                        
                        Image {
                            id: captureImage
                            anchors.fill: parent
                            anchors.margins: 4
                            source: validationDialog.capturePath
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            smooth: true
                            cache: false
                            
                            onStatusChanged: {
                                if (status === Image.Ready) {
                                    console.log("✅ Captura exibida:", source)
                                } else if (status === Image.Error) {
                                    console.log("❌ Erro captura:", source)
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: parent.hovered = true
                            onExited: parent.hovered = false
                            onClicked: {
                                console.log("🖼️ Abrindo captura em fullscreen")
                                fullscreenViewer.imageTitle = "Sua Captura"
                                fullscreenViewer.imagePath = validationDialog.capturePath
                                fullscreenViewer.show()
                                fullscreenViewer.raise()
                                fullscreenViewer.requestActivate()
                            }
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                            opacity: parent.hovered ? 0.1 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🔍 Clique para ampliar"
                            color: "white"
                            font.pixelSize: 12
                            font.bold: true
                            opacity: parent.parent.hovered ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                            
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: -8
                                color: "black"
                                opacity: 0.7
                                radius: 4
                                z: -1
                            }
                        }
                    }
                }
                
                // ===== DIFERENÇAS =====
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    
                    Text {
                        text: "🎨 Diferenças (clique p/ ampliar)"
                        font.pixelSize: 12
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 150
                        color: "#f1f5f9"
                        radius: 6
                        border.color: mainWindow.borderColor
                        border.width: 1
                        clip: true
                        
                        property bool hovered: false
                        
                        Image {
                            id: diffImage
                            anchors.fill: parent
                            anchors.margins: 4
                            source: validationDialog.differencePath
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            smooth: true
                            cache: false
                            
                            onStatusChanged: {
                                if (status === Image.Ready) {
                                    console.log("✅ Diferença exibida:", source)
                                } else if (status === Image.Error) {
                                    console.log("❌ Erro diferença:", source)
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: parent.hovered = true
                            onExited: parent.hovered = false
                            onClicked: {
                                console.log("🖼️ Abrindo diferença em fullscreen")
                                fullscreenViewer.imageTitle = "Mapa de Diferenças"
                                fullscreenViewer.imagePath = validationDialog.differencePath
                                fullscreenViewer.show()
                                fullscreenViewer.raise()
                                fullscreenViewer.requestActivate()
                            }
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                            opacity: parent.hovered ? 0.1 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🔍 Clique para ampliar"
                            color: "white"
                            font.pixelSize: 12
                            font.bold: true
                            opacity: parent.parent.hovered ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                            
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: -8
                                color: "black"
                                opacity: 0.7
                                radius: 4
                                z: -1
                            }
                        }
                    }
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Button {
                    text: "📁 Abrir Pasta"
                    Layout.fillWidth: true
                    height: 40
                    
                    background: Rectangle {
                        color: parent.hovered ? Qt.lighter(mainWindow.secondaryColor, 1.1) : mainWindow.secondaryColor
                        radius: 6
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        Qt.openUrlExternally("file://" + basinManager.getProjectRoot() + "/resources/comparacoes")
                    }
                }
                
                Button {
                    text: "✓ Fechar"
                    Layout.fillWidth: true
                    height: 40
                    
                    background: Rectangle {
                        color: parent.hovered ? Qt.lighter(mainWindow.primaryColor, 1.1) : mainWindow.primaryColor
                        radius: 6
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        validationDialog.visible = false
                        validationDialog.showResult = false
                        validationDialog.showProgress = false
                    }
                }
            }
        }
    }
    
    // ============ VISUALIZADOR FULLSCREEN ============
    Window {
        id: fullscreenViewer
        visible: false
        flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        color: "#000000"
        
        width: Screen.width
        height: Screen.height
        x: Screen.virtualX
        y: Screen.virtualY
        
        property string imagePath: ""
        property string imageTitle: ""
        
        onVisibleChanged: {
            if (visible) {
                console.log("🖼️ Fullscreen aberto:", imagePath)
                showFullScreen()
                raise()
                requestActivate()
                forceActiveFocus()
            }
        }
        
        // CRÍTICO: Capturar tecla ESC
        Item {
            anchors.fill: parent
            focus: true
            
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    console.log("⌨️ ESC pressionado - fechando")
                    fullscreenViewer.close()
                    event.accepted = true
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("🖱️ Clique no fundo - fechando")
                    fullscreenViewer.close()
                }
            }
            
            Image {
                anchors.fill: parent
                source: fullscreenViewer.imagePath
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                cache: false
                
                onStatusChanged: {
                    if (status === Image.Ready) {
                        console.log("✅ Imagem fullscreen carregada")
                    } else if (status === Image.Error) {
                        console.log("❌ Erro ao carregar:", source)
                    }
                }
            }
            
            Rectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                width: titleText.width + 32
                height: 44
                color: "#CC000000"
                radius: 8
                
                Text {
                    id: titleText
                    anchors.centerIn: parent
                    text: fullscreenViewer.imageTitle
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                }
            }
            
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 20
                width: closeText.width + 24
                height: 44
                color: "#CC000000"
                radius: 8
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: fullscreenViewer.close()
                }
                
                Text {
                    id: closeText
                    anchors.centerIn: parent
                    text: "✕ Fechar (ESC)"
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
        }
    }
}
