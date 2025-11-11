import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: control
    
    property color backgroundColor: mainWindow.primaryColor
    property color textColor: "white"
    property int buttonRadius: 8
    
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        color: control.down ? Qt.darker(control.backgroundColor, 1.2) : 
               control.hovered ? Qt.lighter(control.backgroundColor, 1.1) : control.backgroundColor
        radius: control.buttonRadius
        
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
    
    contentItem: Text {
        text: control.text
        font.pixelSize: 14
        color: control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    // Efeito de escala ao pressionar
    scale: control.down ? 0.95 : 1.0
    
    Behavior on scale {
        NumberAnimation {
            duration: 100
        }
    }
}
