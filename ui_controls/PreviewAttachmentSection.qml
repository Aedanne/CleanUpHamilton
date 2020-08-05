import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtMultimedia 5.2
import QtGraphicalEffects 1.0
import QtPositioning 5.8


import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.2

import "../ui_controls"
import "../"

Rectangle {
    id: previewImageRect
    width: formPage.width
    height: formPage.height
    color: "#1C1C1C"
    visible: false

    anchors.fill: parent;

    property var source
//    property bool hasAnimation: true
//    property bool isSupportRotate: false
//    property bool isDebug: false
    property bool hasGeoExif: false
    property var fileSize
    property var fileWidth
    property var fileHeight
//    property bool isRename: false
    property alias infoPanelVisible: infoPanel.visible
//    property alias discardBox //: discardConfirmBox
//    property alias renameTextField: renameField
    property string imageExtendedExif: ""
    property string exifPhoneModel: ""
//    property var copy_latitude
//    property var copy_longtitude
//    property var copy_altitude


    signal dirty()
    signal discarded();
    signal refresh()
    signal edited(var imageSource)

    function init(){
        imageExtendedExif = "";
        exifPhoneModel = "";

//        hasAnimation = false;
        photoFrame.x = previewImageRect.x + (createPage_content.width - photoFrame.width) / 2
        photoFrame.y = previewImageRect.y + (createPage_content.height - photoFrame.height) / 2
        photoFrame.rotation = 0;
        photoFrame.scale = 1;
//        hasAnimation = true;

        exifInfo.load(source.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""));
//        var gpsLongValue = exifInfo.gpsLongitude;
//        if(gpsLongValue) hasGeoExif = true;
//        else hasGeoExif = false;
//        console.log("Source", source)
//        console.log("hasGeo", hasGeoExif)
        fileInfo.filePath = exifInfo.filePath;
//        fileSize = getFileSizeString();
        imageObject.load(source.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""))
        fileWidth = imageObject.width;
        fileHeight = imageObject.height;
//        renameField.text = fileInfo.fileName
        console.log("fileWidth, fileHeight:", fileWidth, fileHeight);
        imageExtendedExif = getImageExtendedExif();
        exifPhoneModel = getExifPhoneModel();
    }

//    function getFileSizeString(){
//        var fileSizeInBytes = fileInfo.size;
//        console.log("fileSizeOfImg", fileSizeInBytes)
//        if(fileSizeInBytes>1048576)return (fileSizeInBytes/1048576).toFixed(2)+qsTr("MB");
//        else return (fileSizeInBytes/1024).toFixed(2)+qsTr("KB");
//    }

//    function renameFile(sourcePath, newFileName){
//        var oldName = fileInfo.fileName;
//        if(oldName != newFileName){
//            var fileFolderPath = sourcePath.replace("/"+oldName,"");
//            console.log("filefolderpath:", fileFolderPath);
//            fileFolder.url = fileFolderPath;
//            fileFolder.renameFile(oldName, newFileName);
//            var newSource = sourcePath.replace(oldName,newFileName);
//            source = newSource;
//            init();
//            dirty();
//        }
//    }

    ExifInfo {
        id: exifInfo
    }

    FileInfo {
        id: fileInfo
    }

    FileFolder{
        id: fileFolder
    }

    ImageObject{
        id: imageObject
    }

    PositionSource {
        id: positionSource
        updateInterval: 5000
        active: previewImageRect.visible
    }

    onDiscarded: {
        app.temp = attachmentListModel.get(thumbGridView.currentIndex).path;
        console.log(">>>> thumbGridView.currentIndex: ", thumbGridView.currentIndex, app.temp);
        app.tempImageFilePath = AppFramework.resolvedPath(app.temp);
        fileFolder.removeFile (app.tempImageFilePath);
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: createPage_headerBar
            Layout.alignment: Qt.AlignTop
            color: "#1C1C1C"
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50 * app.scaleFactor
//            z: createPage_content.z+1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            CustomImageButton {
                imageSource: "../images/back.png"
                height: 50 * app.scaleFactor
                width: 50 * app.scaleFactor

//                anchors.rightMargin: 10
//                anchors.leftMargin: 10
//                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    previewImageRect.visible = false;
                    infoPanel.visible = false;
                    refresh();
                }
            }
            Rectangle{
                anchors.bottom: parent.bottom
                height: app.scaleFactor
                width: parent.width
                color: "#cdcdcd"
                opacity: 0.25
            }
        }


        Rectangle {
            id: createPage_content
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#1C1C1C"
            clip: true

            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    photoFrame.x = previewImageRect.x + (createPage_content.width - photoFrame.width) / 2
                    photoFrame.y = previewImageRect.y + (createPage_content.height - photoFrame.height) / 2
                    photoFrame.rotation = 0;
                    photoFrame.scale = 1;
                }
            }

            Rectangle {
                id: photoFrame
                width: parent.width
                height: parent.height
                scale: 1.0
//                Behavior on scale { NumberAnimation { duration: hasAnimation? 200:0} }
//                Behavior on rotation { NumberAnimation { duration: hasAnimation? 200:0} }
//                Behavior on x { NumberAnimation { duration: hasAnimation? 200:0} }
//                Behavior on y { NumberAnimation { duration: hasAnimation? 200:0} }
                color: "transparent"
                border.color: "transparent"
                border.width: 0
                smooth: true
                antialiasing: true
//                x: previewImageRect.x + (createPage_content.width - photoFrame.width) / 2
//                y: previewImageRect.y + (createPage_content.height - photoFrame.height) / 2

                Image {
                    id: image
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: previewImageRect.source? previewImageRect.source : ""
                    antialiasing: true
                    autoTransform: true
                }
                PinchArea {
                    anchors.fill: parent
                    pinch.target: photoFrame
                    pinch.minimumRotation: isSupportRotate? -3600:0
                    pinch.maximumRotation: isSupportRotate? 3600:0
                    pinch.minimumScale: 1
                    pinch.maximumScale: 10
                    pinch.dragAxis: Pinch.XAndYAxis
                    onSmartZoom: {
                        if (pinch.scale > 0) {
                            photoFrame.rotation = 0;
                            photoFrame.scale = Math.min(createPage_content.width, createPage_content.height) / Math.max(image.sourceSize.width, image.sourceSize.height) * 0.85
                            photoFrame.x = createPage_content.x + (createPage_content.width - photoFrame.width) / 2
                            photoFrame.y = createPage_content.y + (createPage_content.height - photoFrame.height) / 2
                        } else {
                            photoFrame.rotation = pinch.previousAngle
                            photoFrame.scale = pinch.previousScale
                            photoFrame.x = pinch.previousCenter.x - photoFrame.width / 2
                            photoFrame.y = pinch.previousCenter.y - photoFrame.height / 2
                        }
                    }

                    onPinchFinished: {
                        if(scale<1.0) photoFrame.scale=1.0;
                        photoFrame.rotation = Math.round(photoFrame.rotation/90)*90
                    }

                    MouseArea {
                        id: dragArea
                        hoverEnabled: true
                        anchors.fill: parent
                        drag.target: photoFrame
                        scrollGestureEnabled: false  // 2-finger-createPage_content gesture should pass through to the createPage_contentable
                        onWheel: {
                            photoFrame.rotation += wheel.angleDelta.x / 120;
                            if (Math.abs(photoFrame.rotation) < 0.6)
                                photoFrame.rotation = 0;
                            var scaleBefore = photoFrame.scale;
                            photoFrame.scale += photoFrame.scale * wheel.angleDelta.y / 120 / 10;

                            if(photoFrame.scale<1.0) photoFrame.scale=1.0;
                            photoFrame.rotation = Math.round(photoFrame.rotation/90)*90
                        }

                        onDoubleClicked: {
                            photoFrame.x = previewImageRect.x + (createPage_content.width - photoFrame.width) / 2
                            photoFrame.y = previewImageRect.y + (createPage_content.height - photoFrame.height) / 2
                            photoFrame.rotation = 0;
                            photoFrame.scale = 1;
                        }

                        onReleased: {
                            if(scale<1.0) photoFrame.scale=1.0;
                            photoFrame.rotation = Math.round(photoFrame.rotation/90)*90
                        }
                    }
                }
            }

            Rectangle{
                id: infoPanel
                anchors.bottom: parent.bottom
                width: parent.width
                height: 307*AppFramework.displayScaleFactor - (exifGpsAltitude.visible? 0:50*app.scaleFactor) - (exifImageDetails.visible? 0:50*app.scaleFactor)
                visible: false
                color: "#282828"
                MouseArea{
                    anchors.fill: parent
                    preventStealing: true
                }

                PinchArea{
                    anchors.fill: parent
                }

                ColumnLayout{
                    anchors.fill: parent
                    anchors.margins: 10*AppFramework.displayScaleFactor
                    anchors.leftMargin: 20*AppFramework.displayScaleFactor
                    anchors.rightMargin: 20*AppFramework.displayScaleFactor
                    spacing: 10*AppFramework.displayScaleFactor

                    RowLayout{
                        Layout.preferredHeight: 43*app.scaleFactor
                        Layout.fillWidth: true
                        spacing: 20*AppFramework.displayScaleFactor
                        ColumnLayout{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 0

                            Text{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                                text: qsTr("Name")
                                color: "#80ffffff"
                                font.pixelSize: app.subtitleFontSize*0.9
                                fontSizeMode: Text.VerticalFit
                                Rectangle{
                                    anchors.fill: parent
                                    color: "transparent"
                                    visible: true
                                    border.width: 1
                                    border.color: "white"
                                }
                            }

                            Rectangle{
                                Layout.preferredHeight: 23*AppFramework.displayScaleFactor
                                Layout.fillWidth: true
                                radius: 3*AppFramework.displayScaleFactor
                                color:  renameField.focus? "white" : "transparent"

                                Text{
                                    id: renameFieldLabel
                                    height: parent.height
                                    width: parent.width
                                    text: fileInfo.fileName
                                    color: "white"
                                    elide: Text.ElideMiddle
                                    font.pixelSize: app.subtitleFontSize
                                    verticalAlignment: Text.AlignVCenter
                                    fontSizeMode: Text.VerticalFit
                                    Rectangle{
                                        anchors.fill: parent
                                        color: "transparent"
                                        visible: true
                                        border.width: 1
                                        border.color: "blue"
                                    }
                                }

                                TextInput{
                                    id: renameField
                                    visible: false

                                        font.pixelSize: app.subtitleFontSize

                                    text: fileInfo.fileName
                                    verticalAlignment:TextInput.AlignVCenter


                                    height: parent.height
                                    width: parent.width
                                    clip: true

                                    property var extension
                                    property var realName

                                    onEditingFinished: {
                                        var renameFieldText = renameField.text;
                                        if(!(renameFieldText.indexOf(".")>0)) {
                                            if(renameFieldText.length>0){
                                                var newFileName = renameField.text + "." +extension;
                                                renameField.text = newFileName;
                                                renameFile(source, newFileName);
                                            } else {
                                                renameField.text = realName + "." +extension;
                                            }
                                        }
                                        focus = false;
                                    }

                                    onFocusChanged: {
                                        if(focus){
                                            var fileName = fileInfo.fileName.split(".");
                                            realName = fileName[0];
                                            extension = fileName[1];
                                            text = realName;
                                        }
                                    }

                                    Rectangle{
                                        anchors.fill: parent
                                        color: "transparent"
                                        visible: true
                                        border.width: 1
                                        border.color: "white"
                                    }
                                }
                            }
                        }

                        IconTemplate {
                            id: renameButton
                            Layout.preferredHeight: 30*AppFramework.displayScaleFactor
                            Layout.preferredWidth: 30*AppFramework.displayScaleFactor
                            imageSize: 16*AppFramework.displayScaleFactor
                            Layout.alignment: Qt.AlignVCenter
                            backgroundColor: "#1C1C1C"
                            imageSource: renameField.focus?"../images/done.png":"../edit.png"
                            radius: width/2
                            onIconClicked: {
                                renameFieldLabel.visible = !renameFieldLabel.visible;
                                renameField.visible = !renameField.visible;
                                renameField.focus = !renameField.focus;
                            }
                        }
                    }

                    RowLayout{
                        Layout.preferredHeight: 40*app.scaleFactor
                        Layout.fillWidth: true
                        spacing: 20*AppFramework.displayScaleFactor
                        clip: true
                        ColumnLayout{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 0

                            Text{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                                text: qsTr("Location")
                                fontSizeMode: Text.VerticalFit

                                color: "#80ffffff"
                                font.pixelSize: app.subtitleFontSize*0.9
                                Rectangle{
                                    anchors.fill: parent
                                    color: "transparent"
                                    visible: true
                                    border.width: 1
                                    border.color: "white"
                                }
                            }

                            Text{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                                text: hasGeoExif? "("+exifInfo.gpsLatitude.toFixed(2)+","+exifInfo.gpsLongitude.toFixed(2)+")" : qsTr("Not Set")
                                color: "white"
                                font.pixelSize: app.subtitleFontSize
                                verticalAlignment: Text.AlignVCenter
                                fontSizeMode: Text.VerticalFit
                                Rectangle{
                                    anchors.fill: parent
                                    color: "transparent"
                                    visible: true
                                    border.width: 1
                                    border.color: "white"
                                }
                            }
                        }

                        IconTemplate {
                            id: locationButton
                            Layout.preferredHeight: 30*AppFramework.displayScaleFactor
                            Layout.preferredWidth: 30*AppFramework.displayScaleFactor
                            imageSize: 16*AppFramework.displayScaleFactor
                            imageSource: hasGeoExif? "../images/delete.png":"../images/add_location.png"
                            backgroundColor: "#1C1C1C"
                            radius: width/2
                            enabled: hasGeoExif || (positionSource.valid && positionSource.position.coordinate.latitude)
                            onIconClicked: {
                                if(hasGeoExif){
                                    exifInfo.removeGpsValue(ExifInfo.GpsLatitude);
                                    exifInfo.removeGpsValue(ExifInfo.GpsLongitude);
                                    exifInfo.save(exifInfo.filePath);
                                    hasGeoExif = false;
                                } else {
                                    exifInfo.gpsLatitude = positionSource.position.coordinate.latitude;
                                    exifInfo.gpsLongitude = positionSource.position.coordinate.longitude;
                                    exifInfo.save(exifInfo.filePath);
                                    hasGeoExif = true;
                                }
                            }
                        }
                    }

                    ColumnLayout{
                        id: exifGpsAltitude
                        Layout.preferredHeight: 40*app.scaleFactor
                        Layout.fillWidth: true
                        spacing: 0
                        visible: exifInfo.gpsAltitude

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: qsTr("Altitude")
                            fontSizeMode: Text.VerticalFit
                            color: "#80ffffff"
                            font.pixelSize: app.subtitleFontSize*0.9
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: exifInfo.gpsAltitude?exifInfo.gpsAltitude.toFixed(2):qsTr("Not Set")
                            color: "white"
                            font.pixelSize: app.subtitleFontSize
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.VerticalFit
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }
                    }

                    ColumnLayout{
                        Layout.preferredHeight: 40*app.scaleFactor
                        Layout.fillWidth: true
                        spacing: 0

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: qsTr("Size")
                            fontSizeMode: Text.VerticalFit
                            color: "#80ffffff"
                            font.pixelSize: app.subtitleFontSize*0.9
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: fileWidth+"x"+fileHeight+"   "+fileSize
                            color: "white"
                            font.pixelSize: app.subtitleFontSize
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.VerticalFit
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }
                    }

                    ColumnLayout{
                        id: exifImageDetails
                        Layout.preferredHeight: 40*app.scaleFactor
                        Layout.fillWidth: true
                        spacing: 0
                        visible: imageExtendedExif>""

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: exifPhoneModel
                            color: "#80ffffff"
                            font.pixelSize: app.subtitleFontSize*0.9
                            fontSizeMode: Text.VerticalFit
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: imageExtendedExif
                            color: "white"
                            font.pixelSize: app.subtitleFontSize
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.VerticalFit
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }
                    }

                    ColumnLayout{
                        Layout.preferredHeight: 40*app.scaleFactor
                        Layout.fillWidth: true
                        spacing: 0

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: qsTr("Created Date")
                            color: "#80ffffff"
                            font.pixelSize: app.subtitleFontSize*0.9
                            fontSizeMode: Text.VerticalFit
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }

                        Text{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20*AppFramework.displayScaleFactor
                            text: exifInfo.created.toLocaleString(Qt.locale(),"MMM d yyyy, hh:mm AP");
                            color: "white"
                            font.pixelSize: app.subtitleFontSize
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.VerticalFit
                            Rectangle{
                                anchors.fill: parent
                                color: "transparent"
                                visible: true
                                border.width: 1
                                border.color: "white"
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: createPage_footerBar
            Layout.alignment: Qt.AlignTop
            color: "#1C1C1C"
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50 * app.scaleFactor
            z: createPage_content.z+1

            Rectangle{
                anchors.top: parent.top
                height: app.scaleFactor
                width: parent.width
                color: "#cdcdcd"
                opacity: 0.25
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            IconTemplate {
                backgroundColor: "#1C1C1C"
                height: 45*app.scaleFactor
                width: 45*app.scaleFactor
                imageSource: "../images/delete.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                iconOverlayColor: "#bebebe"
                onIconClicked: {
//                    discardConfirmBox.visible = true;
                    discarded();
                    infoPanel.visible = false;
                    previewImageRect.visible = false;
                }
            }

            IconTemplate {
                backgroundColor: "#1C1C1C"
                height: 45*app.scaleFactor
                width: 45*app.scaleFactor
                imageSource: "../images/ic_edit_white_48dp.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                enabled: true
                iconOverlayColor: "#bebebe"
                visible: !isGif(previewImageRect.source)

                onIconClicked: {
                    copy_latitude = exifInfo.gpsLatitude;
                    copy_longtitude = exifInfo.gpsLongitude;
                    copy_altitude = exifInfo.gpsAltitude;
                    edited(previewImageRect.source);
                }

                function isGif(filePath) {
                    console.log("filePath", filePath)
                    if (filePath === undefined) return false;
                    return filePath.indexOf(".gif") > 0;
                }
            }

            IconTemplate {
                backgroundColor: "#1C1C1C"
                height: 45*app.scaleFactor
                width: 45*app.scaleFactor
                imageSource: "../images/info.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                iconOverlayColor: infoPanel.visible?"white":"#bebebe"
                onIconClicked: {
                    infoPanel.visible = !infoPanel.visible;
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: app.isIPhoneX ? 20 * app.scaleFactor : 0
        }
    }

    function getImageExtendedExif(){
        var res = [];

        if(exifInfo.isExifValid){
            var aperture = exifInfo.extendedValue(ExifInfo.ExtendedApertureValue);
            if(aperture) res.push("f/"+aperture.toFixed(1));
            var exposureTime = exifInfo.extendedValue(ExifInfo.ExtendedExposureTime);
            if(exposureTime) res.push(exposureTime.toFixed(3));
            var focalLength = exifInfo.extendedValue(ExifInfo.ExtendedFocalLength);
            if(focalLength) res.push(focalLength+"mm")
            var isoSpeedRatings = exifInfo.extendedValue(ExifInfo.ExtendedISOSpeedRatings)
            if(isoSpeedRatings) res.push("ISO"+isoSpeedRatings);
        }

        return res.length>0?res.join("   "):"";
    }

    function getExifPhoneModel(){
        var res = qsTr("Details");

        if(exifInfo.isExifValid){
            var make = exifInfo.imageValue(ExifInfo.ImageMake);
            var model = exifInfo.imageValue(ExifInfo.ImageModel);
            if(make>"" && model>"") res = make+" "+model;
        }

        return res;
    }

//    ConfirmBox {
//        id: discardConfirmBox
//        anchors.fill: parent
//        text: qsTr("Are you sure you want to discard the changes?")
//        onAccepted: {
//            discarded();
//            infoPanel.visible = false;
//            previewImageRect.visible = false;
//        }
//    }
}
