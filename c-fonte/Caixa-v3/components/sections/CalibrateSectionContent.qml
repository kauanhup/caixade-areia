import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    spacing: 16
    
    // 🔥 POPUP DE CONFIRMAÇÃO
    Popup {
        id: confirmationPopup
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 600)
        height: Math.min(parent.height * 0.8, 500)
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        
        property string calibrationData: ""
        
        background: Rectangle {
            color: mainWindow.cardColor
            radius: 16
            border.color: mainWindow.borderColor
            border.width: 2
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Text {
                    text: "✅"
                    font.pixelSize: 32
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    
                    Text {
                        text: "Calibração Concluída"
                        font.pixelSize: 20
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Text {
                        text: "Deseja salvar os dados de calibração?"
                        font.pixelSize: 13
                        color: mainWindow.mutedTextColor
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: mainWindow.borderColor
            }
            
            // Dados capturados
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                
                Text {
                    text: "Dados Capturados:"
                    font.pixelSize: 14
                    font.bold: true
                    color: mainWindow.textColor
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: Qt.rgba(0, 0, 0, 0.05)
                    border.color: mainWindow.borderColor
                    
                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 12
                        clip: true
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        
                        TextEdit {
                            width: parent.parent.width - 24
                            height: Math.max(contentHeight, parent.parent.height - 24)
                            text: confirmationPopup.calibrationData
                            font.pixelSize: 13
                            font.family: "Monospace"
                            color: mainWindow.textColor
                            readOnly: true
                            selectByMouse: true
                            wrapMode: TextEdit.Wrap
                            textFormat: TextEdit.PlainText
                        }
                    }
                }
                
                Text {
                    text: "💡 Revise os dados antes de salvar"
                    font.pixelSize: 11
                    color: mainWindow.mutedTextColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: mainWindow.borderColor
            }
            
            // Botões
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Button {
                    text: "❌ Cancelar"
                    Layout.fillWidth: true
                    padding: 12
                    
                    background: Rectangle {
                        color: parent.pressed ? Qt.rgba(0, 0, 0, 0.1) : Qt.rgba(0, 0, 0, 0.05)
                        radius: 8
                        border.color: mainWindow.borderColor
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: mainWindow.textColor
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        calibrationManager.cancelKinectCalibration()
                        confirmationPopup.close()
                    }
                }
                
                Button {
                    text: "💾 Salvar"
                    Layout.fillWidth: true
                    padding: 12
                    
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(mainWindow.primaryColor, 1.1) : mainWindow.primaryColor
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        calibrationManager.saveKinectCalibration()
                        confirmationPopup.close()
                    }
                }
            }
        }
    }
    
    // Conexões com o backend
    Connections {
        target: calibrationManager
        
        function onKinectCalibrationStarted() {
            console.log("✅ Calibração Kinect iniciada")
            kinectStatusText.text = "⏳ Calibrando Kinect..."
            kinectStatusText.color = mainWindow.mutedTextColor
            kinectStatusText.visible = true
        }
        
        function onKinectCalibrationClosed(formattedData) {
            console.log("🎉 Calibração fechada, mostrando popup de confirmação")
            confirmationPopup.calibrationData = formattedData
            confirmationPopup.open()
            kinectStatusText.visible = false
        }
        
        function onKinectCalibrationFinished() {
            console.log("✅ Calibração Kinect salva com sucesso!")
            kinectStatusText.text = "✅ Calibração salva com sucesso!"
            kinectStatusText.color = "#10b981"
            kinectStatusText.visible = true
            statusTimer.restart()
        }
        
        function onKinectCalibrationError(error) {
            console.log("❌ Erro na calibração Kinect:", error)
            kinectStatusText.text = "❌ " + error
            kinectStatusText.color = "#ef4444"
            kinectStatusText.visible = true
            statusTimer.restart()
        }
        
        function onProjectorCalibrationStarted() {
            console.log("✅ Calibração Projetor iniciada")
            projectorStatusText.text = "⏳ Calibrando Projetor..."
            projectorStatusText.color = mainWindow.mutedTextColor
            projectorStatusText.visible = true
        }
        
        function onProjectorCalibrationFinished() {
            console.log("✅ Calibração Projetor finalizada!")
            projectorStatusText.text = "✅ Calibração concluída!"
            projectorStatusText.color = "#10b981"
            projectorStatusText.visible = true
            statusTimer.restart()
        }
        
        function onProjectorCalibrationError(error) {
            console.log("❌ Erro na calibração Projetor:", error)
            projectorStatusText.text = "❌ " + error
            projectorStatusText.color = "#ef4444"
            projectorStatusText.visible = true
            statusTimer.restart()
        }
    }
    
    Timer {
        id: statusTimer
        interval: 5000
        onTriggered: {
            kinectStatusText.visible = false
            projectorStatusText.visible = false
        }
    }
    
    // Header com animação
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 6
        opacity: 0
        
        SequentialAnimation on opacity {
            running: true
            PauseAnimation { duration: 0 }
            PropertyAnimation { to: 1; duration: 400; easing.type: Easing.OutCubic }
        }
        
        Text {
            text: "Calibração do Sistema"
            font.pixelSize: 24
            font.bold: true
            color: mainWindow.textColor
        }
        
        Text {
            text: "Configure os parâmetros do sensor e projeção"
            font.pixelSize: 13
            color: mainWindow.mutedTextColor
        }
    }
    
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 12
    }
    
    GridLayout {
        Layout.fillWidth: true
        Layout.topMargin: 0
        columns: 2
        columnSpacing: 16
        rowSpacing: 16
        
        // Calibrar Kinect Card
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            opacity: 0
            
            SequentialAnimation on opacity {
                running: true
                PauseAnimation { duration: 100 }
                PropertyAnimation { to: 1; duration: 400; easing.type: Easing.OutCubic }
            }
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 8
                
                Rectangle {
                    id: kinectCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: mainWindow.primaryColor
                    
                    Rectangle {
                        id: kinectOverlay
                        anchors.fill: parent
                        radius: 12
                        color: "white"
                        opacity: 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20
                        
                        Text {
                            text: "📷"
                            font.pixelSize: 36
                            scale: 1
                            
                            SequentialAnimation on scale {
                                running: kinectMouseArea.containsMouse
                                loops: Animation.Infinite
                                NumberAnimation { to: 1.1; duration: 500; easing.type: Easing.InOutSine }
                                NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutSine }
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text {
                                text: "Calibrar Kinect"
                                font.pixelSize: 17
                                font.bold: true
                                color: "white"
                            }
                            
                            Text {
                                text: "Configurar sensor de profundidade"
                                font.pixelSize: 13
                                color: Qt.rgba(1, 1, 1, 0.9)
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                    
                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 12
                        width: 8
                        height: 8
                        radius: 4
                        color: "white"
                        opacity: kinectMouseArea.containsMouse ? 1 : 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }
                    
                    scale: 1
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                    
                    MouseArea {
                        id: kinectMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onEntered: {
                            kinectCard.scale = 1.03
                            kinectOverlay.opacity = 0.1
                        }
                        
                        onExited: {
                            kinectCard.scale = 1.0
                            kinectOverlay.opacity = 0
                        }
                        
                        onPressed: {
                            kinectCard.scale = 0.98
                        }
                        
                        onReleased: {
                            kinectCard.scale = 1.03
                        }
                        
                        onClicked: {
                            calibrationManager.calibrateKinect()
                        }
                    }
                }
                
                Text {
                    id: kinectStatusText
                    Layout.fillWidth: true
                    font.pixelSize: 12
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }
            }
        }
        
        // Calibrar Projetor Card
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            opacity: 0
            
            SequentialAnimation on opacity {
                running: true
                PauseAnimation { duration: 150 }
                PropertyAnimation { to: 1; duration: 400; easing.type: Easing.OutCubic }
            }
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 8
                
                Rectangle {
                    id: projectorCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: mainWindow.secondaryColor
                    
                    Rectangle {
                        id: projectorOverlay
                        anchors.fill: parent
                        radius: 12
                        color: "white"
                        opacity: 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20
                        
                        Text {
                            text: "📽️"
                            font.pixelSize: 36
                            scale: 1
                            
                            SequentialAnimation on scale {
                                running: projectorMouseArea.containsMouse
                                loops: Animation.Infinite
                                NumberAnimation { to: 1.1; duration: 500; easing.type: Easing.InOutSine }
                                NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutSine }
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text {
                                text: "Calibrar Projetor"
                                font.pixelSize: 17
                                font.bold: true
                                color: "white"
                            }
                            
                            Text {
                                text: "Ajustar alinhamento da projeção"
                                font.pixelSize: 13
                                color: Qt.rgba(1, 1, 1, 0.9)
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                    
                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 12
                        width: 8
                        height: 8
                        radius: 4
                        color: "white"
                        opacity: projectorMouseArea.containsMouse ? 1 : 0
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }
                    
                    scale: 1
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                    
                    MouseArea {
                        id: projectorMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onEntered: {
                            projectorCard.scale = 1.03
                            projectorOverlay.opacity = 0.1
                        }
                        
                        onExited: {
                            projectorCard.scale = 1.0
                            projectorOverlay.opacity = 0
                        }
                        
                        onPressed: {
                            projectorCard.scale = 0.98
                        }
                        
                        onReleased: {
                            projectorCard.scale = 1.03
                        }
                        
                        onClicked: {
                            calibrationManager.calibrateProjector()
                        }
                    }
                }
                
                Text {
                    id: projectorStatusText
                    Layout.fillWidth: true
                    font.pixelSize: 12
                    color: mainWindow.mutedTextColor
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }
            }
        }
    }
}

