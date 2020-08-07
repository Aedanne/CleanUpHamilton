import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

//Loading animation when waiting on response
Item {

    id: loadingAnimation
    width: parent.width
    height: parent.width
    anchors.centerIn: parent
    anchors.fill: parent

    Rectangle {
        width: 150*app.scaleFactor
        height: 150*app.scaleFactor

        anchors.fill: parent
        color: app.backgroundAccent
        opacity: 0.8

        BusyIndicator {
            id: busy
            anchors.centerIn: parent
            Material.accent: app.primaryColor
            running: loadingAnimation.visible


        }

//        Component.onCompleted: rotationAnimation.start()

//        Rectangle {
//            id: clockHand
//            width: 125*app.scaleFactor
//            height: 15*app.scaleFactor
//            x: loadingAnimation.width / 2
//            y: loadingAnimation.height / 2
//            transformOrigin: Item.Left
//            antialiasing: true
//            color: app.appBackgroundColor
//            radius: 10*app.scaleFactor
//        }

//        NumberAnimation {
//            id: rotationAnimation
//            target: clockHand
//            property: "rotation"
//            duration: 1500
//            from: 0
//            to: 360
//            easing.type: Easing.OutExpo
//            loops: Animation.Infinite
//        }

    }
}
