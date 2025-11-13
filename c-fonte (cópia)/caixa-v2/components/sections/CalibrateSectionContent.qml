import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

ColumnLayout {
    spacing: 16
    
    // Conexões com o backend
    Connections {
        target: calibrationManager
        
        onKinectCalibrationStarted: {
            console.log("✅ Calibração Kinect iniciada")
            kinectStatusText.text = "⏳ Calibrando Kinect..."
            kinectStatusText.visible = true
        }
        
        onKinectCalibrationFinished: {
            console.log("✅ Calibração Kinect finalizada e salva!")
            kinectStatusText.text = "✅ Calibração salva com sucesso!"
            kinectStatusText.color = "#10b981"
            statusTimer.restart()
        }
        
        onKinectCalibrationError: {
            console.log("❌ Erro na calibração Kinect:", error)
            kinectStatusText.text = "❌ " + error
            kinectStatusText.color = "#ef4444"
            statusTimer.restart()
        }
        
        onProjectorCalibrationStarted: {
            console.log("✅ Calibração Projetor iniciada")
            projectorStatusText.text = "⏳ Calibrando Projetor..."
            projectorStatusText.visible = true
        }
        
        onProjectorCalibrationFinished: {
            console.log("✅ Calibração Projetor finalizada!")
            projectorStatusText.text = "✅ Calibração concluída!"
            projectorStatusText.color = "#10b981"
            statusTimer.restart()
        }
        
        onProjectorCalibrationError: {
            console.log("❌ Erro na calibração Projetor:", error)
            projectorStatusText.text = "❌ " + error
            projectorStatusText.color = "#ef4444"
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
                    
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 8.0
                        samples: 17
                        color: Qt.rgba(0, 0, 0, 0.15)
                    }
                    
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
                    
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 8.0
                        samples: 17
                        color: Qt.rgba(0, 0, 0, 0.15)
                    }
                    
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
