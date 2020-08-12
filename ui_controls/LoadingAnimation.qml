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
//        width: parent.width
//        height: parent.height

        anchors.fill: parent
        color: app.appBackgroundColor
//        opacity: 0.90

        BusyIndicator {
            id: busy
            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: parent.top
            anchors.centerIn: parent
            anchors.topMargin: 200*app.scaleFactor
            antialiasing: true
            Material.accent: app.primaryColor
            running: loadingAnimation.visible
        }

        Label {
            Material.theme: app.lightTheme? Material.Light : Material.Dark;
//            anchors.centerIn: parent;
            font.pixelSize: app.baseFontSize*0.5;
            color: app.primaryColor;
            font.bold: true
            wrapMode: Text.Wrap;
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: busy.top
            bottomPadding: 25*app.scaleFactor;
            text: loadingText;
        }

    }
}
