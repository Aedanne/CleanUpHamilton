import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

//Loading animation when waiting on response
Item {

    id: loadingAnimation
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    anchors.fill: parent
    property string loadingText;

    Rectangle {
        width: 150*app.scaleFactor
        height: 150*app.scaleFactor

        anchors.fill: parent
        color: app.backgroundAccent
        opacity: 0.95

        BusyIndicator {
            id: busy
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 200*app.scaleFactor
            Material.accent: app.primaryColor
            running: loadingAnimation.visible
        }

        Label {
            Material.theme: app.lightTheme? Material.Light : Material.Dark;
            anchors.centerIn: parent;
            font.pixelSize: app.baseFontSize*0.5;
            color: app.primaryColor;
            font.bold: true
            wrapMode: Text.Wrap;
            topPadding: 75*app.scaleFactor;
            text: loadingText;
        }

    }
}
