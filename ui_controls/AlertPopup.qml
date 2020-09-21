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
    height: 150*app.scaleFactor;

    anchors.centerIn: parent

    property string alertText : ""
    property color backgroundColor: app.appBackgroundColorCaseList
    property color textColor : "red"

    Rectangle {
        anchors.fill: parent
        z:10
        color: app.appBackgroundColorCaseList
        border.color: "red"
        border.width: 3

        ColumnLayout {
            spacing: 0
            anchors.centerIn: parent



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

            Text {
                id: tap
                color: textColor
                width: parent.width * 0.8
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: app.baseFontSize*0.3
                topPadding: 50*app.scaleFactor
                text: "Tap to close..."

            }

         }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                alertPopup.visible = false;
                try {
                  if (enableFormElements) enableFormElements(false);
                } catch(err) {
                  console.log(">>>> enableformelements: ",err.message);
                }

            }
        }
    }
}
