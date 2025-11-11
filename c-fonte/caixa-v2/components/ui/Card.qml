import QtQuick 2.12

Rectangle {
    radius: 12
    color: Qt.rgba(1, 1, 1, 0.5)
    border.color: mainWindow.borderColor
    border.width: 1
    
    property alias contentItem: contentArea
    
    Item {
        id: contentArea
        anchors.fill: parent
    }
    
    // Efeito hover
    states: State {
        name: "hovered"
        when: mouseArea.containsMouse
        PropertyChanges {
            target: parent
            scale: 1.02
        }
    }
    
    transitions: Transition {
        NumberAnimation {
            properties: "scale"
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
    }
}
