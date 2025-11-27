import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.15

Item {
    id: sandboxColorsPage
    
    // 🔥 Sincroniza com C++
    property int selectedPalette: paletteManager.selectedPalette
    
    Component.onCompleted: {
        console.log("🎨 Paleta atual carregada:", selectedPalette)
    }
    
    // 🔥 Escuta sinais do C++
    Connections {
        target: paletteManager
        
        function onPaletteApplied(success, message) {
            if (success) {
                successDialog.text = message
                successDialog.open()
            } else {
                errorDialog.text = message
                errorDialog.open()
            }
        }
        
        function onSelectedPaletteChanged() {
            console.log("🔄 Paleta atualizada para:", paletteManager.selectedPalette)
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // ========== HEADER ==========
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: Qt.rgba(1, 1, 1, 0.5)
            border.color: mainWindow.borderColor
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                anchors.topMargin: 12
                anchors.bottomMargin: 12
                spacing: 16
                
                // Botão Voltar
                Button {
                    text: "⬅ Voltar"
                    font.pixelSize: 14
                    
                    background: Rectangle {
                        color: parent.hovered ? Qt.rgba(0, 0, 0, 0.05) : "transparent"
                        radius: 6
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
                
                Item { Layout.fillWidth: true }
                
                // Título central
                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 4
                    
                    Text {
                        text: ""
                        font.pixelSize: 18
                        font.bold: true
                        color: mainWindow.textColor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: ""
                        font.pixelSize: 12
                        color: mainWindow.mutedTextColor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                Item { Layout.fillWidth: true }
            }
        }
        
        // ========== CONTEÚDO ==========
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth
            
            ColumnLayout {
                width: Math.min(parent.width, 1200)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24
                
                Item { Layout.preferredHeight: 24 }
                
                // Subtítulo
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    spacing: 8
                    
                    Text {
                        text: "Paletas Disponíveis"
                        font.pixelSize: 20
                        font.bold: true
                        color: mainWindow.textColor
                    }
                    
                    Text {
                        text: "Selecione uma paleta para modificar a visualização do terreno"
                        font.pixelSize: 14
                        color: mainWindow.mutedTextColor
                    }
                }
                
                // ========== GRID DE PALETAS ==========
                GridLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    columns: 3
                    columnSpacing: 16
                    rowSpacing: 16
                    
                    Repeater {
                        model: [
                            {name: "Clássico", colors: ["#4a148c", "#6a1b9a", "#8e24aa", "#ab47bc", "#ce93d8"]},
                            {name: "Oceano", colors: ["#01579b", "#0277bd", "#0288d1", "#039be5", "#03a9f4"]},
                            {name: "Floresta", colors: ["#1b5e20", "#2e7d32", "#388e3c", "#43a047", "#66bb6a"]},
                            {name: "Deserto", colors: ["#e65100", "#f57c00", "#ff9800", "#ffa726", "#ffb74d"]},
                            {name: "Ártico", colors: ["#006064", "#00838f", "#0097a7", "#00acc1", "#00bcd4"]},
                            {name: "Vulcão", colors: ["#b71c1c", "#c62828", "#d32f2f", "#e53935", "#f44336"]}
                        ]
                        
                        // ========== CARD DA PALETA ==========
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 220
                            color: "white"
                            radius: 12
                            border.width: paletteMouseArea.containsMouse ? 2 : 1
                            border.color: selectedPalette === index ? mainWindow.primaryColor : 
                                         (paletteMouseArea.containsMouse ? mainWindow.primaryColor : mainWindow.borderColor)
                            
                            Behavior on border.width {
                                NumberAnimation { duration: 200 }
                            }
                            
                            Behavior on border.color {
                                ColorAnimation { duration: 200 }
                            }
                            
                            // Sombra quando hover
                            layer.enabled: paletteMouseArea.containsMouse
                            layer.effect: DropShadow {
                                transparentBorder: true
                                color: Qt.rgba(0, 0, 0, 0.15)
                                radius: 8
                                samples: 16
                            }
                            
                            MouseArea {
                                id: paletteMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                            
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 16
                                
                                // Cabeçalho do card
                                RowLayout {
                                    Layout.fillWidth: true
                                    
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: mainWindow.textColor
                                        Layout.fillWidth: true
                                    }
                                    
                                    // Indicador de seleção
                                    Rectangle {
                                        visible: selectedPalette === index
                                        width: 24
                                        height: 24
                                        radius: 12
                                        color: mainWindow.primaryColor
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "✓"
                                            color: "white"
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                    }
                                }
                                
                                // Barra de cores
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 60
                                    radius: 8
                                    clip: true
                                    
                                    Row {
                                        anchors.fill: parent
                                        spacing: 0
                                        
                                        Repeater {
                                            model: modelData.colors
                                            
                                            Rectangle {
                                                width: parent.width / 5
                                                height: parent.height
                                                color: modelData
                                            }
                                        }
                                    }
                                }
                                
                                Item { Layout.fillHeight: true }
                                
                                // Botão aplicar
                                Button {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 40
                                    text: selectedPalette === index ? "✓ Paleta Aplicada" : "Aplicar Paleta"
                                    enabled: selectedPalette !== index
                                    
                                    background: Rectangle {
                                        color: {
                                            if (!parent.enabled) return Qt.rgba(0.9, 0.9, 0.9, 1)
                                            return parent.hovered ? Qt.darker(mainWindow.primaryColor, 1.1) : mainWindow.primaryColor
                                        }
                                        radius: 6
                                        
                                        Behavior on color {
                                            ColorAnimation { duration: 200 }
                                        }
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: parent.enabled ? "white" : Qt.rgba(0.5, 0.5, 0.5, 1)
                                        font.pixelSize: 14
                                        font.bold: selectedPalette === index
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    
                                    onClicked: {
                                        console.log("🎨 Aplicando paleta", index, "-", modelData.name)
                                        paletteManager.applyPalette(index)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Item { Layout.preferredHeight: 24 }
            }
        }
    }
    
    // ========== DIÁLOGO DE SUCESSO ==========
    Dialog {
        id: successDialog
        property alias text: successText.text
        
        modal: true
        anchors.centerIn: parent
        width: 400
        height: 200
        
        background: Rectangle {
            color: "white"
            radius: 12
            border.width: 1
            border.color: mainWindow.borderColor
        }
        
        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20
            
            Text {
                text: "✅"
                font.pixelSize: 56
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                id: successText
                font.pixelSize: 16
                color: mainWindow.textColor
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                text: "OK"
                Layout.preferredWidth: 120
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                
                background: Rectangle {
                    color: parent.hovered ? Qt.darker(mainWindow.primaryColor, 1.1) : mainWindow.primaryColor
                    radius: 6
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: successDialog.close()
            }
        }
    }
    
    // ========== DIÁLOGO DE ERRO ==========
    Dialog {
        id: errorDialog
        property alias text: errorText.text
        
        modal: true
        anchors.centerIn: parent
        width: 400
        height: 200
        
        background: Rectangle {
            color: "white"
            radius: 12
            border.width: 1
            border.color: "#ef4444"
        }
        
        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20
            
            Text {
                text: "❌"
                font.pixelSize: 56
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                id: errorText
                font.pixelSize: 16
                color: "#ef4444"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                text: "OK"
                Layout.preferredWidth: 120
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                
                background: Rectangle {
                    color: parent.hovered ? "#dc2626" : "#ef4444"
                    radius: 6
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: errorDialog.close()
            }
        }
    }
}
