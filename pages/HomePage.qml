import QtQuick 2.7
import QtQuick.Layouts 1.13

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.7


Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: app.pageBackgroundColor


    Item{
        id: homePageContainer
        anchors.fill: parent
        ColumnLayout {

            anchors.fill: parent
            spacing: 0

            //top
            Rectangle {
                id: topContainer
                color: app.pageBackgroundColor
                Layout.fillWidth: true

                //Set background image
                AnimatedImage {
                    id: backgroundImage
                    anchors.fill: parent
                    source: app.homePageBackgroundImageURL
                    fillMode: Image.PreserveAspectCrop
                    visible: true
                }

                Rectangle {
                    anchors.fill: parent
                    visible: backgroundImage.status === Image.Ready
                    gradient: Gradient {
                        GradientStop { position: 1.0; color: "#99000000";}
                        GradientStop { position: 0.0; color: "#22000000";}
                    }
                }
            }
        }
    }
}
