import QtQuick 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: featureItem
    property string text: ""
    property color accentColor: mainWindow.primaryColor

    Layout.fillWidth: true
    height: 48
    radius: 8
    color: Qt.rgba(0.98, 0.98, 0.98, 0.5)
    border.color: Qt.rgba(0, 0, 0, 0.05)
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Bolinha de cor à esquerda
        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: featureItem.accentColor
            anchors.verticalCenter: parent.verticalCenter
        }

        // Texto descritivo
        Text {
            text: featureItem.text
            font.pixelSize: 13
            color: mainWindow.textColor
            Layout.fillWidth: true
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    // Área interativa (hover e clique)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    // Efeito visual de hover
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: featureItem
                color: Qt.lighter(Qt.rgba(0.93, 0.95, 1.0, 0.8))
                border.color: featureItem.accentColor
            }
        }
    ]

    transitions: [
        Transition {
            ColorAnimation { properties: "color,border.color"; duration: 150 }
        }
    ]
}

