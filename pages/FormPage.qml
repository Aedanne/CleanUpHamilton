import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
//import QtQuick.Controls.Styles 1.4
import QtPositioning 5.13


import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Multimedia 1.0

import Esri.ArcGISRuntime 100.5
import ArcGIS.AppFramework.Platform 1.0





import "../ui_controls"


/*
Form page for Clean-Up Hamilton app
*/

Page {

    id:formPage;
    anchors.fill: parent;

    signal nextPage();
    signal previousPage();

    property string titleText:""
    property var descText;
    property int maxLimit: 200
    property int currChars;

    //Camera picture properties==========================================================
    property string activeTool:""
    property string fileLocation: "../images/temp.png"
    property int defaultImgRes: 1024
    property var photoAction: "take_photo"
    property string selectedImageFilePath: ""

    //Used for media that will be included with the report
    ListModel{
        id: fileListModel
    }

    //Used for editing exchangeable image (exif) file medatadata
    ExifInfo{
        id: exifInfo
    }

    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: FORM PAGE INFO PAGE";
    }


    //Main body of the page =============================================================

    //Position of the device - will be used for tracking GPS information in the photos
    PositionSource {
        id: positionSource
        updateInterval: 5000
        active: false
    }

    contentItem: Rectangle {
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: 50 * app.scaleFactor

        ColumnLayout {
            Layout.preferredWidth: parent.width*0.75;
            spacing: 1

            anchors {
                fill: parent
                margins: 20 * AppFramework.displayScaleFactor
            }

            Label {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: "Select incident to report:"
                color: app.appSecondaryTextColor;
                bottomPadding: 5 * app.scaleFactor
            }

            ComboBox {
                id: typeComboBox
                Layout.fillWidth: true
                currentIndex: -1
                font.bold: true
                font.pixelSize: app.baseFontSize*.4
//                font.family: app.appFontTTF
                displayText: currentIndex === -1 ? "Please Choose..." : currentText

                delegate: ItemDelegate {
                    width: parent.width
                    contentItem: Text {
                        text: modelData
                        color: app.appPrimaryTextColor
                        font: typeComboBox.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: typeComboBox.highlightedIndex === index
                }

                model: ListModel {
                    id: typeIndex
                    ListElement { text: "Graffiti"; }
                    ListElement { text: "Broken items";  }
                    ListElement { text: "Illegal rubbish dumping";  }
                    ListElement { text: "Other";  }
                }

                width: 200
                onCurrentIndexChanged: console.log(typeIndex.get(currentIndex).text + ", " + typeIndex.get(currentIndex).color)

                contentItem: Text {
                        leftPadding: 5 * app.scaleFactor
                        rightPadding: typeComboBox.indicator.width + typeComboBox.spacing

                        text: typeComboBox.displayText
                        font: typeComboBox.font
                        color: (typeComboBox.currentIndex === -1) ? "red": app.appPrimaryTextColor
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
            }

            RowLayout{

                spacing: 0;
                visible: true;
//                anchors.fill: parent;

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.5
                    font.bold: true
                    text: "Enter description: "
                    color: app.appSecondaryTextColor;
                    topPadding: 30 * app.scaleFactor
                    bottomPadding: 10 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: "(" + currChars + "/" + maxLimit + ")";
                    color: (currChars == maxLimit) ? "red" : app.appSecondaryTextColor;
                    topPadding: 30 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75 * scaleFactor
                border.color: app.appPrimaryTextColor
                border.width: 1 * scaleFactor
                radius: 4
                ScrollView {
                    anchors.fill: parent
                    contentItem: parent

                    TextArea {
                        id: descriptionField
                        width: parent.width*.8
                        Material.accent: app.backgroundAccent
                        background: null
                        padding: 5 * scaleFactor
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        placeholderText: "Enter additional information..."
                        color: app.appPrimaryTextColor
                        text:""

                        onTextChanged: {
                           currChars = descriptionField.text.length
                           if (currChars >= maxLimit) {
                              descriptionField.text = descriptionField.text.substring(0, maxLimit);
                           }

                           console.log("char count: " + (maxLimit - descriptionField.text.length))
                           console.log("line count"+ (descriptionField.contentHeight / descriptionField.lineCount))
                        }

                        onActiveFocusChanged: {


                        }
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: "Add photos:"
                color: app.appSecondaryTextColor;
                topPadding: 30 * app.scaleFactor
                bottomPadding: 5 * app.scaleFactor
            }


            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75 * scaleFactor
//                border.color: app.appPrimaryTextColor
//                border.width: 1 * scaleFactor

                RowLayout {

                    anchors.fill: parent;
                    Layout.alignment: Qt.AlignLeft

                    IconTemplate{

                        containerSize: 50*AppFramework.displayScaleFactor
                        imageSource: "../images/camera.png"
                        color: "#6e6e6e"
                        Layout.alignment: Qt.AlignLeft

                        onIconClicked: {
                            activeTool = photoAction

                            //Device location
                            positionSource.start();

                            //Start camera
                            cameraDialog.open();
                        }
                    }


                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 75 * scaleFactor
//                        border.color: app.appPrimaryTextColor
//                        border.width: 1 * scaleFactor

                        Label {
                            horizontalAlignment: Text.AlignHCenter;
                            verticalAlignment: Text.AlignVCenter;
                            Text {
                                id: placeHolder
                                text: qsTr("TODO: image section")
                                color: "red"
                                font.pixelSize: app.baseFontSize*0.6
                                horizontalAlignment: Text.AlignHCenter;
                                verticalAlignment: Text.AlignVCenter;
                                leftPadding: 20 * app.scaleFactor
                                topPadding: 20 * app.scaleFactor
                            }
                        }
                    }

                }
            }



            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: ""
                color: app.appPrimaryTextColor;
                topPadding: 200 * app.scaleFactor
            }


        }


        //Arcgis CameraDialog QML Type ========================================
        //This will open up the camera view
        CameraDialog {
            id:cameraDialog

            onAccepted: {
                if (captureMode === CameraDialog.CameraCaptureModeStillImage) {

                    //If position source is enabled and lattitude exists, then add GPS data to image
                    if (positionSource.position.coordinate.latitude) addGPSParameters(fileUrl);

                    //Check if image is too big and resize
                    console.log("fileUrl="+fileUrl);
                    resizeImage(fileUrl);

                    selectedImageFilePath = fileUrl;

                    //Add this image to the file list for the report
                    //TODO: when there are multiples
                    fileListModel.append({path: selectedImageFilePath.toString(), type: "attachment"})

                    visualListModel.initVisualListModel();

                    positionSource.stop()
                }
            }
        }


        //Photo to include is cast as ImageObject type for loading and transforming
        ImageObject {
            id: imageObject
        }

        //Arcgis appframework for checking permissions
        //Not needed for Android - overrides
//        PermissionDialog {
//            id: permissionDialog
//            openSettingsWhenDenied: true
//            onAccepted: {
//                if (activeTool == photoAction) {
//                    if (Permission.checkPermission(Permission.PermissionTypeCamera) === Permission.PermissionResultGranted) {
//                        cameraDialog.open()
//                    }
//                }
//            }

//            onRejected: {
//                console.log("Camera permission rejected...");
//            }
//        }




        }



    //Footer custom QML =================================================================
    footer: FooterSection {
        logMessage: "In Form Page - Footer..."
        rightButtonText: "SAVE"
        overrideRightIconSrc: "../images/save.png"
    }


    //Function to resize image if exceeds 1024
    function resizeImage(path) {
        console.log("Resize image function from camera: ", path)

        var imageInfo = AppFramework.fileInfo(path);
        if (!imageInfo.exists) {
            console.error("Image does not exist:", path);
            return;
        }

        if (!imageObject.load(path)) {
            console.error("Unable to load image:", path);
            return;
        }

        if (imageObject.width > defaultImgRes) {
            console.log("Resizing image:", imageObject.width, "x", imageObject.height, "size:", imageInfo.size);
            imageObject.scaleToWidth(defaultImgRes);
        } else {
            console.log("Image does not need to be resized:", imageObject.width, "<=", defaultImgRes);
            return;
        }

        if (!imageObject.save(path)) {
            console.error("Unable to save image:", path);
            return;
        }

        //Refresh updated image in device
        imageInfo.refresh();
    }


    //Arcgis appframework code snippet for adding GPS data to image using current location
    function addGPSParameters(filePath) {

        exifInfo.load(filePath);
        exifInfo.setImageValue(ExifInfo.ImageDateTime, new Date());
        exifInfo.setImageValue(ExifInfo.ImageSoftware, app.info.title);
        exifInfo.setExtendedValue(ExifInfo.ExtendedDateTimeOriginal, new Date());

        if (positionSource.position.latitudeValid) exifInfo.gpsLatitude = positionSource.position.coordinate.latitude;
        if (positionSource.position.longitudeValid) exifInfo.gpsLongitude = positionSource.position.coordinate.longitude;
        if (positionSource.position.altitudeValid) exifInfo.gpsAltitude = positionSource.position.coordinate.altitude;
        if (positionSource.position.horizontalAccuracyValid) {
            exifInfo.setGpsValue(ExifInfo.GpsHorizontalPositionError, positionSource.position.horizontalAccuracy);
        }

        if (positionSource.position.directionValid) {
            exifInfo.setGpsValue(ExifInfo.GpsTrack, positionSource.position.direction);
            exifInfo.setGpsValue(ExifInfo.GpsTrackRef, "T");
        }

        exifInfo.save(filePath);
    }


}

