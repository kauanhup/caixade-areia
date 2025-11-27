import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: fullscreenWindow
    visible: true
    visibility: Window.FullScreen
    color: "black"
    
    // Propriedade que receberá o caminho da imagem
    property string imagePath: ""
    
    Image {
        id: basinImage
        anchors.fill: parent
        source: imagePath ? "file://" + imagePath : ""
        fillMode: Image.Stretch  // 🔥 FORÇA tela cheia (distorce se necessário)
        smooth: true
        asynchronous: true
        
        onStatusChanged: {
            if (status === Image.Error) {
                console.log("❌ Erro ao carregar imagem:", imagePath)
                errorText.visible = true
            } else if (status === Image.Ready) {
                console.log("✅ Imagem carregada com sucesso")
                errorText.visible = false
            } else if (status === Image.Loading) {
                console.log("⏳ Carregando imagem...")
            }
        }
    }
    
    // Texto de erro
    Rectangle {
        id: errorText
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: 200
        color: Qt.rgba(0.2, 0.2, 0.2, 0.9)
        radius: 12
        visible: false
        
        Column {
            anchors.centerIn: parent
            spacing: 20
            
            Text {
                text: "❌ Erro ao carregar imagem"
                color: "#ef4444"
                font.pixelSize: 32
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: imagePath
                color: "white"
                font.pixelSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAnywhere
                width: fullscreenWindow.width * 0.7
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    
    // Instruções
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 40
        width: instructionText.width + 60
        height: 80
        radius: 12
        color: Qt.rgba(0, 0, 0, 0.8)
        border.color: Qt.rgba(1, 1, 1, 0.2)
        border.width: 1
        
        Text {
            id: instructionText
            anchors.centerIn: parent
            text: "Pressione ESC para sair"
            color: "white"
            font.pixelSize: 20
            font.bold: true
        }
        
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.4; duration: 1200 }
            NumberAnimation { to: 1.0; duration: 1200 }
        }
    }
    
    // Indicador de carregamento
    Rectangle {
        id: loadingIndicator
        anchors.centerIn: parent
        width: 100
        height: 100
        radius: 50
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: basinImage.status === Image.Loading
        
        Text {
            anchors.centerIn: parent
            text: "⏳"
            font.pixelSize: 48
            
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 2000
            }
        }
    }
    
    // 🔥 CAPTURA ESC - Método 1
    Keys.onPressed: (event) => {
        console.log("🔑 Tecla pressionada:", event.key)
        if (event.key === Qt.Key_Escape) {
            console.log("🔙 Fechando projeção fullscreen (Keys.onPressed)")
            event.accepted = true
            fullscreenWindow.close()
        }
    }
    
    // 🔥 CAPTURA ESC - Método 2 (backup)
    Shortcut {
        sequence: "Esc"
        onActivated: {
            console.log("🔙 Fechando projeção fullscreen (Shortcut)")
            fullscreenWindow.close()
        }
    }
    
    // 🔥 Mouse também fecha (clique duplo)
    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            console.log("🔙 Fechando por duplo clique")
            fullscreenWindow.close()
        }
    }
    
    Component.onCompleted: {
        console.log("🎬 Projeção fullscreen aberta")
        console.log("📸 Caminho da imagem:", imagePath)
        
        // 🔥 FORÇA foco múltiplas vezes
        fullscreenWindow.requestActivate()
        fullscreenWindow.raise()
        fullscreenWindow.focus = true
        
        // Timer para garantir foco depois de renderizar
        focusTimer.start()
    }
    
    Timer {
        id: focusTimer
        interval: 100
        repeat: true
        running: false
        triggeredOnStart: true
        property int attempts: 0
        
        onTriggered: {
            attempts++
            fullscreenWindow.requestActivate()
            fullscreenWindow.focus = true
            
            if (attempts >= 5) {
                stop()
            }
        }
    }
    
    Component.onDestruction: {
        console.log("🛑 Projeção fullscreen fechada")
    }
}
