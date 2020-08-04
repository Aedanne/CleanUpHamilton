import QtQuick 2.13
import QtQuick.Layouts 1.13
//import QtQuick.Controls 2.2
//import QtQuick.Controls.Material 2.13
//import QtGraphicalEffects 1.13

//import QtPositioning 5.13


import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Multimedia 1.0

import Esri.ArcGISRuntime 100.5 as EsriRT
import ArcGIS.AppFramework.Platform 1.0


//Rectangle {

//    id:cameraViewPage;
//    anchors.fill: parent;

    CameraDialog {

        onAccepted: {
            console.log("IN CAPTURE MODE");
            if (captureMode === CameraDialog.CameraCaptureModeStillImage) {
                console.log("IN CAPTURE MODE");

                //If position source is enabled and lattitude exists, then add GPS data to image
                if (positionSource.position.coordinate.latitude) addGPSParameters(fileUrl);

                //Check if image is too big and resize
                console.log(">>>>>>>fileUrl="+fileUrl);
                resizeImage(fileUrl);

                selectedImageFilePath = fileUrl;
                console.log(">>>>>>>selectedImageFilePath="+fileUrl);

                //Add this image to the file list for the report
                //TODO: when there are multiples
                attachmentListModel.append({path: selectedImageFilePath.toString(), type: "attachment"})

                visualListModel.initVisualListModel();

                positionSource.stop();


            }

            //Set camera mode off
            app.inCameraMode = 0
        }

        onRejected: {

            //Set camera mode off
            app.inCameraMode = 0
        }
    }
//}
