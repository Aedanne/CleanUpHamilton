import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.13

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

    property var descText;
    property int maxLimit: 200
    property int currChars;
    property string titleText: ""

    //Camera picture properties==========================================================
    property string fileLocation: "../images/temp.png"
    property int defaultImgRes: 1024



    //Used for editing exchangeable image (exif) file medatadata
    ExifInfo{
        id: exifInfo
    }

    function initFeatureService() {
        //load the feature server when page is loaded, if not already running
        if (casesFeatureTable.loadStatus != Enums.LoadStatusLoaded) {
            console.log(">>>> Form page initFeatureService() -- loading feature layer...");
            casesFeatureTable.load();
        }
    }


    //Header custom QML =================================================================
    header: HeaderSection {
        id: formPageHeader
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
            spacing: 0

            anchors {
                fill: parent
                margins: 20 * app.scaleFactor
            }

            //Location placeholder
            RowLayout{

                spacing: 0;
                visible: true;

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Location: "+ app.currentLonLat
                    color: app.appSecondaryTextColor;
                    bottomPadding: 5 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    text: "";
                    color: app.appSecondaryTextColor
                    bottomPadding: 5 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }




            Label {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.4
                font.bold: true
                text: "Select incident to report:"
                color: app.appSecondaryTextColor;
                topPadding: 20 * app.scaleFactor
                bottomPadding: 5 * app.scaleFactor
            }

            ComboBox {
                id: typeComboBox
                Layout.fillWidth: true
                currentIndex: -1
                font.bold: true
                font.pixelSize: app.baseFontSize*.4
                displayText: currentIndex === -1 ? "Please Choose..." : currentText
                enabled: !formMissingData.visible

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
                onCurrentIndexChanged: {

                    console.log(">>>> Combo Box selected: " + typeIndex.get(currentIndex).text);
                    app.reportType = typeComboBox.displayText

                    initFeatureService();
                }

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
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Enter description: "
                    color: app.appSecondaryTextColor;
                    topPadding: 20 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: "(" + currChars + "/" + maxLimit + ")";
                    color: (currChars == maxLimit) ? "red" : app.appSecondaryTextColor;
                    topPadding: 20 * app.scaleFactor
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
//                        width: parent.width*.8
                        Material.accent: app.backgroundAccent
                        background: null
                        padding: 5 * scaleFactor
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        placeholderText: "Enter additional information..."
                        color: app.appPrimaryTextColor
                        text:""
                        enabled: !formMissingData.visible

                        onTextChanged: {
                           currChars = descriptionField.text.length
                           if (currChars >= maxLimit) {
                              descriptionField.text = descriptionField.text.substring(0, maxLimit);
                           }

                           console.log(">>>> char count: " + (maxLimit - descriptionField.text.length))
                           console.log(">>>> line count"+ (descriptionField.contentHeight / descriptionField.lineCount))
                        }

                        onActiveFocusChanged: {


                        }
                    }
                }
            }

            RowLayout {

                spacing: 0;
                visible: true;

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Add photos:"
                    color: app.appSecondaryTextColor;
                    topPadding: 20 * app.scaleFactor
                    bottomPadding: 2 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: "(" + app.attListModel.count + "/" + maxAttachments + ")";
                    color: (app.attListModel.count == maxAttachments) ? "red" : app.appSecondaryTextColor;
                    topPadding: 20 * app.scaleFactor
                    bottomPadding: 2 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }


            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75 * scaleFactor
//                border.color: app.appPrimaryTextColor
//                border.width: 1 * scaleFactor

                RowLayout {

                    anchors.fill: parent;
                    Layout.alignment: Qt.AlignLeft
                    spacing: 10*app.scaleFactor

                    IconTemplate {
                        imgRadius: 2
                        containerSize: 50*app.scaleFactor
                        imageSource: "../images/camera.png"
                        color: (app.attListModel.count === app.maxAttachments) ? Qt.lighter("#6e6e6e", 0.5) : "#6e6e6e"
                        Layout.alignment: Qt.AlignLeft
                        enabled: (app.attListModel.count === app.maxAttachments) ? false: !formMissingData.visible

                        maxAttach: (app.attListModel.count === app.maxAttachments) ? true: false

                        onIconClicked: {

                            //Device location
                            positionSource.start();

                            //Start camera
                            cameraDialog.open();

                        }
                    }


                    //Datamodel for displaying the preview photos
                    ListModel {
                        id: displayPreviewListModel

                        Component.onCompleted: {
                            displayPreviewListModel.initDisplayPreviewListModel();
                        }

                        function initDisplayPreviewListModel(){
                            var temp;

                            //clear the previews before reloading from attListModel
                            displayPreviewListModel.clear();

                            var attachCount = 0;
                            for (var i = 0; i < app.maxAttachments; i++) {

                                console.log(">>>>>>app.attListModel.count", app.attListModel.count);

                                if(i < app.attListModel.count){
                                    console.log(">>>>>> i < app.attListModel.count, i=" + i + " ... ", app.attListModel.count);
                                    temp = app.attListModel.get(i);
                                    var tempPath = temp.path

                                    //Fix file path url if windows vs android
                                    exifInfo.load(tempPath.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""));

                                    displayPreviewListModel.append({path: tempPath});

                                    console.log(">>>>>displayPreviewListModel.size", displayPreviewListModel.count);

                                    attachCount++;
                                } else {
                                    displayPreviewListModel.append({path: ""})
                                }
                            }

                            app.countAttachments = attachCount;
                        }
                    }


                    //Display thumbnail of images using gridview
                    Rectangle {
                        id: thumbnailRectangle
                        color: "transparent"
                        Layout.preferredWidth: parent.width*0.80
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignCenter

                        clip:true

                        GridView {
                            id: thumbGridView
                            width: parent.width
                            height: parent.height
//                            focus: true
                            visible: true
                            model: displayPreviewListModel
                            cellWidth: parent.width/3
                            cellHeight: parent.height

                            delegate: Item {
                                width: thumbGridView.cellWidth*1.1
                                height: thumbGridView.cellHeight

                                ImageIconTemplate {
                                    id: previewPhotoIcons
                                    enabled: !formMissingData.visible
                                    imgSource: path
                                    onImageIconClicked: {
                                        if (app.attListModel.count > 0) {
                                            console.log(">>> image clicked - thumbgridview >>> " + "path:" + path)
                                            thumbGridView.currentIndex = index;
                                            if (thumbGridView.currentIndex < app.attListModel.count) {

                                                console.log(">>> thumbGridView.currentIndex >>> " + thumbGridView.currentIndex)
                                                previewSection.source = path;
                                                previewSection.visible = true
                                                previewSection.init();

                                                //hide header and footer
                                                formPageFooter.visible = false;
                                                formPageHeader.visible = false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } //End rectangle for thumbnail previewBtn


            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: ""
                color: app.appPrimaryTextColor;
                topPadding: 200 * app.scaleFactor
            }

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


        //Arcgis CameraDialog QML Type ========================================
        //This will open up the camera view
        CameraDialog {

            id: cameraDialog
            enabled: !formMissingData.visible

            onAccepted: {

                if (captureMode === CameraDialog.CameraCaptureModeStillImage) {

                    //If position source is enabled and lattitude exists, then add GPS data to image
                    if (positionSource.position.coordinate.latitude) addGPSParameters(fileUrl);

                    //Check if image is too big and resize
                    console.log(">>>>>>>fileUrl="+fileUrl);
                    resizeImage(fileUrl);

                    app.tempImageFilePath = fileUrl;
                    console.log(">>>>>>>app.tempImageFilePath="+fileUrl);

                    //Append multiple attachments to list model
                    app.attListModel.append({path: app.tempImageFilePath.toString(), type: "attachment"})

                    displayPreviewListModel.initDisplayPreviewListModel();

                    positionSource.stop();


                }
            }
        }


        //Photo to include is cast as ImageObject type for loading and transforming
        ImageObject {
            id: imageObject
        }


        PreviewAttachmentSection {
            id: previewSection

            onDiscarded: {
                console.log(">>>> thumbGridView.currentIndex", thumbGridView.currentIndex);
                app.attListModel.remove(thumbGridView.currentIndex);
                displayPreviewListModel.initDisplayPreviewListModel();
            }

            onRefresh: {
                displayPreviewListModel.initDisplayPreviewListModel();
            }

        }
    }


    //Handles connection to ArcGIS Waikato feature server for Clean-up Hamilton project
    FeatureLayer {

        ServiceFeatureTable {
            id: casesFeatureTable
            url: app.featureServerURL

            onLoadStatusChanged: {
                console.log(">>>> onLoadStatusChanged --- " + loadStatus);
            }

            onAddFeatureStatusChanged: {
                console.log(">>>> onAddFeaturesStatusChanged --- " + addFeatureStatus);
                if (addFeatureStatus === Enums.TaskStatusCompleted) {
                    console.log(">>>> successfully added feature");
                    //apply edits to the feature layer
//                    applyEdits();
                }
            }

            onApplyEditsStatusChanged: {
               console.log(">>>> onApplyEditsStatusChanged --- " + applyEditsStatus);
               if (applyEditsStatus === Enums.TaskStatusCompleted) {
                   console.log(">>>> successfully updated feature");
                   app.clearData();
               }
            }



            //No updates, just new report cases .... FOR NOW....
//            onUpdateFeatureStatusChanged: {
//               console.log(">>>> onUpdateFeatureStatusChanged ---");
//               if (updateFeatureStatus === Enums.TaskStatusCompleted) {
//                   // apply the edits to the feature server endpoint
//                   casesFeatureTable.applyEdits();
//                }
//            }
        }
    }

    AlertPopup {
        id: formMissingData
        alertText: "Select incident to report.";
    }


    //Footer custom QML =================================================================
    footer: FooterSection {
        id: formPageFooter
//        visible: camera.cameraStatus != Camera.ActiveStatus
        logMessage: "In Form Page - Footer..."
        rightButtonText: "SUBMIT"
        overrideRightIconSrc: "../images/send.png"
//        overrideRightIconSz: 20
        enabled: !formMissingData.visible
    }


    //Function to resize image if exceeds 1024
    function resizeImage(path) {
        console.log(">>>> resizeImage() from camera: ", path)

        var imageInfo = AppFramework.fileInfo(path);
        if (!imageInfo.exists) {
            console.error(">>>>> Image invalid:", path);
            return;
        }

        if (!imageObject.load(path)) {
            console.error(">>>>> Can't load:", path);
            return;
        }

        if (imageObject.width > defaultImgRes) {
            console.log(">>>>> Resizing image:", imageObject.width, "x", imageObject.height, "size:", imageInfo.size);
            imageObject.scaleToWidth(defaultImgRes);
        } else {
            console.log(">>>>> Does not need image resizing:", imageObject.width, "<=", defaultImgRes);
            return;
        }

        if (!imageObject.save(path)) {
            console.error(">>>>> Can't save to path:", path);
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


    //Submit data to feature server - load feature layer
    function submitReportData() {

        if (casesFeatureTable.loadStatus === Enums.LoadStatusLoaded) {
            //Create JSON for data to submit
            var reportAttributes = buildAttributesJSON();

            // create a new feature using the mouse's map point
            var reportFeature = casesFeatureTable.createFeatureWithAttributes(reportAttributes, app.currentLocationPoint);

            // add attachments
            if (app.countAttachments > 0) {
                console.log(">>>> add attachments to feature.... ");

                for (var i = 0; i < app.attListModel.count; i++) {
                    var img = app.attListModel.get(i);
                    console.log(">>>> Attaching image: " + img + " >>> " + img["path"]);
                    reportFeature.attachments.addAttachment(img["path"], "image/jpeg", "Attachment"+(i+1));
                }

            }

            console.log(">>> submitReportData(): casesFeatureTable.canAdd() -- " + casesFeatureTable.canAdd())
            console.log(">>> submitReportData(): casesFeatureTable.canUpdate() -- " + casesFeatureTable.editable)

            console.log(">>>> reportFeature = " + reportFeature);

            // add the new feature to the feature table
            casesFeatureTable.addFeature(reportFeature);

        }


    }



    function buildAttributesJSON() {
        //Set global properties
        app.reportType = typeComboBox.displayText;
        app.reportDescription = descriptionField.text;
        app.reportDate = new Date();

        console.log(">>>> Pre-submit data check:");
        console.log(">>>> reportType: " + app.reportType);
        console.log(">>>> reportDescription: " + app.reportDescription);
        console.log(">>>> reportDate: " + app.reportDate);

        var reportAttributes = {
                "Type" : app.reportType,
                "Description" : app.reportDescription,
                "ReportedDate" : app.reportDate
        };

        console.log(">>>> JSON Report Attributes: " + reportAttributes);

        return reportAttributes;

    }




}

