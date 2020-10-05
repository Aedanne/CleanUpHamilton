import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

/*
LoadingAnimation QML Type - used for loading animation with descriptive text
*/

Item {

    id: loadingAnimation
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    anchors.fill: parent
    property string loadingText

    Rectangle {

        anchors.fill: parent
        color: app.appBackgroundColor

        BusyIndicator {
            id: busy
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.centerIn: parent
            anchors.topMargin: 200*app.scaleFactor
            antialiasing: true
            Material.accent: app.primaryColor
            running: loadingAnimation.visible
        }

        Label {
            Material.theme: Material.Light
            font.pixelSize: app.baseFontSize*0.5
            color: app.primaryColor
            font.bold: true
            wrapMode: Text.Wrap
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: busy.top
            bottomPadding: 25*app.scaleFactor
            text: loadingText
        }
    }
}
