import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    spacing: 24
    
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 8
        
        Text {
            text: "Sistema de Bacias"
            font.pixelSize: 24
            font.bold: true
            color: mainWindow.textColor
        }
        
        Text {
            text: "Modelos de bacias hidrográficas mundiais"
            font.pixelSize: 13
            color: mainWindow.mutedTextColor
        }
    }
    
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 280
        radius: 12
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#eff6ff" }
            GradientStop { position: 1.0; color: "#ccfbf1" }
        }
        border.color: mainWindow.borderColor
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16
            
            Text {
                text: "Sistema de Bacias Hidrográficas"
                font.pixelSize: 20
                font.bold: true
                color: mainWindow.textColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Explore e carregue modelos pré-configurados de bacias\nhidrográficas famosas do mundo todo"
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
                        {icon: "🌊", text: "6 Modelos"},
                        {icon: "📍", text: "Áreas Reais"},
                        {icon: "👁️", text: "Imagens Satélite"}
                    ]
                    
                    Rectangle {
                        width: 120
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
                id: basinsButton
                text: "Abrir Sistema de Bacias"
                Layout.alignment: Qt.AlignHCenter
                padding: 12
                
                background: Rectangle {
                    color: basinsButton.pressed ? Qt.darker(mainWindow.secondaryColor, 1.1) : mainWindow.secondaryColor
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
                        mainWindow.navigate("sandboxBasins")
                    }
                }
            }
        }
    }
}
