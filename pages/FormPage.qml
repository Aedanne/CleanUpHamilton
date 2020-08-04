import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.13

import QtPositioning 5.13


import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Multimedia 1.0

import Esri.ArcGISRuntime 100.5 as EsriRT
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
    property string activeTool:""
    property string fileLocation: "../images/temp.png"
    property int defaultImgRes: 1024
    property var photoAction: "take_photo"
    property string selectedImageFilePath: ""

    //Used for media that will be included with the report
    ListModel{
        id: attachmentListModel
    }

    //Used for editing exchangeable image (exif) file medatadata
    ExifInfo{
        id: exifInfo
    }

    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: FORM PAGE INFO PAGE";
        overrideText: app.inCameraMode ? qsTr("Add Photo Evidence") : qsTr("Add Report Details")
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
                margins: 20 * AppFramework.displayScaleFactor
            }

            Label {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.4
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
                    text: "(" + attachmentListModel.count + "/" + maxAttachments + ")";
                    color: (attachmentListModel.count == maxAttachments) ? "red" : app.appSecondaryTextColor;
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

                    IconTemplate{

                        containerSize: 50*AppFramework.displayScaleFactor
                        imageSource: "../images/camera.png"
                        color: (attachmentListModel.count === app.maxAttachments) ? Qt.lighter("#6e6e6e", 0.5) : "#6e6e6e"
                        Layout.alignment: Qt.AlignLeft
                        enabled: (attachmentListModel.count === app.maxAttachments) ? false: true
                        maxAttach: (attachmentListModel.count === app.maxAttachments) ? true: false

                        onIconClicked: {
                            if (!maxAttach) {
                               app.inCameraMode = 1;
                            }

                            //Device location
                            positionSource.start();

                            //Start camera
                            cameraViewPage.open();


                        }



                    }


                    //Datamodel for displaying the photos
                    ListModel {
                        id: visualListModel

                        Component.onCompleted: {
                            visualListModel.initVisualListModel();
                        }

                        function initVisualListModel(){
                            var temp;
                            visualListModel.clear()
                            var hasTag;
//                            var countVideos = 0;
//                            var countAudio = 0;
                            var countAttach = 0;
                            for (var i = 0; i < app.maxAttachments; i++) {

                                console.log(">>>>>>attachmentListModel.count", attachmentListModel.count);

                                if(i < attachmentListModel.count){
                                    console.log(">>>>>> i<attachmentListModel.count i=" + i + " ... ", attachmentListModel.count);
                                    temp = attachmentListModel.get(i);
                                    var tempPath = temp.path;
                                    var tempType = temp.type;

                                    exifInfo.load(tempPath.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""));

//                                    if(exifInfo.gpsLongitude && exifInfo.gpsLatitude) {
//                                        hasTag = true;
//                                    } else {
//                                        hasTag = false;
//                                    }
//                                    if(tempType === "attachment2") countVideos++;
//                                    if(tempType === "attachment3") countAudio++;
                                    visualListModel.append({path: tempPath, type: tempType, hasTag: hasTag});

                                    console.log(">>>>>visualListModel.size", visualListModel.count);

                                    countAttach++;
                                }else{
                                    visualListModel.append({path: "", type:"placehold", hasTag: false})
                                }
                            }
//                            hasVideoAttachment = countVideos > 0;
//                            hasAudioAttachment = countAudio > 0;
                            app.countAttachments = countAttach;
                        }
                    }


                    //Display thumbnail of images usign gridview
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
                            focus: true
                            visible: true
                            model: visualListModel
                            cellWidth: parent.width/3
                            cellHeight: parent.height

                            delegate: Item {
                                width: thumbGridView.cellWidth
                                height: thumbGridView.cellHeight

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width-16*app.scaleFactor
                                    height: parent.height-16*app.scaleFactor
                                    color: "transparent"
                                    radius: 4
                                    border.color: "#80cccccc"
                                    border.width: 1*app.scaleFactor


                                    Image {
                                        id: myIcon
                                        source: path
                                        width: parent.width
                                        height: parent.heigh
                                        fillMode: Image.PreserveAspectCrop
                                        anchors.centerIn: parent
                                        autoTransform: true
                                        visible: true
                                        cache: false
                                        sourceSize.width: width
                                        sourceSize.height: height
                                    }

                                    Rectangle{
                                        width: 16*app.scaleFactor
                                        height: 16*app.scaleFactor
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.topMargin: 4*app.scaleFactor
                                        anchors.leftMargin: 4*app.scaleFactor
                                        clip: true

                                        color: "#80ffffff"
                                        visible: hasTag
                                        Image{
                                            id: indicatorImg
                                            width: 12*app.scaleFactor
                                            height: 12*app.scaleFactor
                                            source: "../images/location.png"
                                            anchors.centerIn: parent
                                        }
                                        ColorOverlay{
                                            anchors.fill: indicatorImg
                                            source: indicatorImg
                                            color: "#6E6E6E"
                                        }
                                    }

                                    MouseArea {
                                        enabled: true
                                        onClicked: {

                                                thumbGridView.currentIndex = index;
                                                previewSection.source = path;
                                                previewSection.visible = true
                                                previewSection.init();

                                        }
                                    }
                                }
                            }
                        }
                    }





//                    ConfirmBox{
//                        id: deleteAlertBox
//                        anchors.fill: parent
//                        standardButtons: StandardButton.Yes | StandardButton.No
//                        onAccepted: {
//                            var filename =  AppFramework.fileInfo(selectedFilePath).fileName

//                            if(attachmentsFolder.fileExists(filename)){
//                                attachmentsFolder.removeFile(filename)
//                            }
//                            app.appModel.remove(thumbGridView.currentIndex)

//                            visualListModel.initVisualListModel()


//                        }
//                    }





                    Popup {
                        id: popupOption
                        padding: 10
                        width:  isSmallScreen?parent.width:thumbGridView.width
                        height: app.isIPhoneX ?fldialog.height + 16 * scaleFactor:fldialog.height
                        x: Math.round((parent.width - width) / 2)
                        y: Math.round((parent.height - height) )

                        Material.background: app.pageBackgroundColor
                        modal: true
                        focus: true

                        contentItem:Rectangle {

                            id:gridpopup
                            width:popupOption - 20 * scaleFactor
                            height:app.isIPhoneX?fldialog.height + 16 * scaleFactor:fldialog.height
                            color: app.pageBackgroundColor

                            ColumnLayout{
                                id:fldialog
                                spacing: 1 * app.scaleFactor

                                anchors.leftMargin: 10 * scaleFactor
                                anchors.rightMargin: 10 * scaleFactor


                                Text{

                                    Layout.topMargin: 10 * scaleFactor
                                    text:selectedFileName
                                    Layout.preferredWidth:gridpopup.width - 20 * scaleFactor
                                    elide: Text.ElideRight
                                    font.pixelSize: app.subtitleFontSize
                                    font.family: app.customTitleFont.name
                                    color: app.textColor

                                }
                                RowLayout{
                                    spacing: 8 * app.scaleFactor
                                    Text{

                                        text:selectedFileSuffix
                                        font.pixelSize: app.subtitleFontSize
                                        font.family: app.customTextFont.name
                                        color: app.subtitleColor

                                    }
                                    Rectangle {
                                        id:icon
                                        width: 4
                                        height:4
                                        radius: 2
                                        color: app.textColor
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                    Text{
                                        text:fileSize
                                        font.pixelSize: app.subtitleFontSize
                                        font.family: app.customTextFont.name
                                        color: app.textColor
                                    }



                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 10 * scaleFactor
                                    color: "transparent"

                                }

                                Rectangle {
                                    Layout.preferredWidth: gridpopup.width - 20 * scaleFactor

                                    Layout.preferredHeight: 1
                                    color: blk_030
                                    opacity: 0.6
                                }
                                Rectangle {

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 16 * scaleFactor
                                    color: "transparent"

                                }
                                Rectangle {
                                    id:buttonbox
                                    Layout.preferredWidth: gridpopup.width - 20 * scaleFactor
                                    Layout.preferredHeight: 50 * scaleFactor
                                    Layout.bottomMargin: app.isIPhoneX?26 * scaleFactor: 16 * scaleFactor


                                    color: "transparent"
                                    CustomImageButton {
                                        labelText: qsTr("Delete")
                                        btnColor:"#FF0000"
//                                        buttonFill: false
                                        anchors.left:buttonbox.left

                                        btnHeight: parent.height
                                        btnWidth: (buttonbox.width - 20 * scaleFactor)/2



                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
//                                                popupOption.close()

//                                                deleteAlertBox.text = qsTr("Are you sure you want to delete the file?")+"\n";
//                                                deleteAlertBox.visible = true;


                                                var filename =  AppFramework.fileInfo(selectedFilePath).fileName

                                                if(attachmentsFolder.fileExists(filename)){
                                                    attachmentsFolder.removeFile(filename)
                                                }
                                                attachmentListModel.remove(thumbGridView.currentIndex)

                                                visualListModel.initVisualListModel()

                                                return;

                                            }
                                        }
                                    }
                                    CustomImageButton {
                                        id: previewBtn
                                        anchors.right: buttonbox.right
                                        labelText: qsTr("Preview")
//                                        buttonColor: app.buttonColor
//                                        buttonFill: true
                                        btnHeight: parent.height
                                        btnWidth: (buttonbox.width - 20 * scaleFactor)/2

                                        visible: AppFramework.network.isOnline

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                popupOption.close()

                                                AppFramework.clipboard.share(selectedFileUrl)
                                            }
                                        }
                                    }

                                }





                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight:10 * scaleFactor
                                    color: "transparent"

                                }
                            }
                        }
                    }





                    PreviewAttachmentSection {
                        id: previewSection

                        onDiscarded: {
                            console.log("thumbGridView.currentIndex", thumbGridView.currentIndex);
                            attachmentListModel.remove(thumbGridView.currentIndex);
                            visualListModel.initVisualListModel();
                        }
                        onEdited: {
                            previewSection.infoPanelVisible = false;
                            var component = imageEditorComponent;
                            imageEditor = component.createObject(rectContainer);
                            imageEditor.visible = true;
                            imageEditor.workFolder = outputFolder;
                            imageEditor.exif_latitude = previewSection.copy_latitude;
                            imageEditor.exif_longtitude = previewSection.copy_longtitude;
                            imageEditor.exif_altitude = previewSection.copy_altitude;

                            //copy
                            var pictureUrl = source;
                            var pictureUrlInfo = AppFramework.urlInfo(pictureUrl);
                            var picturePath = pictureUrlInfo.localFile;
                            var assetInfo = AppFramework.urlInfo(picturePath);

                            var outputFileName;

                            var suffix = AppFramework.fileInfo(picturePath).suffix;
                            var fileName = AppFramework.fileInfo(picturePath).baseName+AppFramework.createUuidString(2);
                            var a = suffix.match(/&ext=(.+)/);
                            if (Array.isArray(a) && a.length > 1) {
                                suffix = a[1];
                            }

                            if (assetInfo.scheme === "assets-library") {
                                pictureUrl = assetInfo.url;
                            }

                            outputFileName = "draft" + "-" + fileName + "." + suffix;

                            var outputFileInfo = outputFolder.fileInfo(outputFileName);

                            outputFolder.removeFile(outputFileName);
                            outputFolder.copyFile(picturePath, outputFileInfo.filePath);

                            pictureUrl = outputFolder.fileUrl(outputFileName);

                            fixRotate(pictureUrl)

                            imageEditor.pasteImage(pictureUrl);
                        }
                        onDirty: {
                            attachmentListModel.set(thumbGridView.currentIndex, {path: source, type: "attachment"});
                            visualListModel.initVisualListModel();
                        }
                        onRefresh: {
                            visualListModel.initVisualListModel();
                        }
                    }


//                    Component {
//                        id: imageEditorComponent

//                        ImageEditor {
//                            anchors.fill: parent
//                            visible: false

//                            onSaved: {
//                                app.appModel.set(thumbGridView.currentIndex, {path: saveUrl.toString(), type: "attachment"});
//                                visualListModel.initVisualListModel();
//                                previewSection.visible = false;
//                            }
//                        }
//                    }

                    Component {
                        id: imageViewerComponent
                        AttachmentReviewPage {
                            anchors.fill: parent
                            visible: false

                            onSaved: {
                                previewImage.source = "../images/placeholder.png";
                                previewImage.source = newFileUrl;

                                var path = AppFramework.resolvedPath(newFileUrl);
                                var filePath = "file:///" + path
                                filePath = filePath.replace("////","///");

                                attachmentListModel.set(thumbGridView.currentIndex, {path: filePath, type: "attachment"});
                                visualListModel.initVisualListModel();

                            }
                        }
                    }

                }
            } //End rectangle for thumbnail previewBtn

            //Location placeholder
            RowLayout{

                spacing: 0;
                visible: true;

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Location: PLACEHOLDER"
                    color: app.appSecondaryTextColor;
                    topPadding: 20 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    text: "";
                    color: app.appSecondaryTextColor
                    topPadding: 20 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
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
        CameraViewPage {
            id: cameraViewPage
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
//                        cameraViewPage.open()
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
        visible: !app.inCameraMode
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

