import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.5

Item {

    id: alertPopup
    visible: false
    width: 290*app.scaleFactor;
    height: 100*app.scaleFactor;

    anchors.centerIn: parent

    property string alertText : ""
    property color backgroundColor: "#FFFFFF"
    property color textColor : "red"

    Rectangle {
        anchors.fill: parent
        z:10
        color: app.appBackgroundColor
        opacity: 0.9
        border.color: "red"
        border.width: 5



        radius: 3;


        Text {
            anchors.centerIn: parent
            id: alertPopupText
            color: textColor
            width: parent.width * 0.8
            wrapMode: Text.Wrap
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: app.baseFontSize*0.5
            text: alertText
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                alertPopup.visible = false;
                enableFormElements(false);
            }
        }


    }

}
