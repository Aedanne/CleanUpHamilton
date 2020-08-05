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

    id: rootPreview

    property var source

    //Native behavior methods
    signal discarded();
    signal refresh();

    Layout.preferredWidth: parent.width
    Layout.preferredHeight: parent.height
    color: app.cameraViewBackgroundColor
    visible: false
    anchors.fill: parent

    //Initialize objects for preview page
    function init(){

        //Calculate center for image frame
        imageFrame.x = rootPreview.x + (mainPreviewSection.width - imageFrame.width) / 2
        imageFrame.y = rootPreview.y + (mainPreviewSection.height - imageFrame.height) / 2
        imageFrame.rotation = 0;
        imageFrame.scale = 1;

        exifInfo.load(source.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""));
        imageObject.load(source.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""))
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: previewHeaderRect
            color: app.cameraViewBackgroundColor
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 75 * app.scaleFactor
            z: mainPreviewSection.z+1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            IconTemplate {
                backgroundColor: app.camer
                height: 25*app.scaleFactor
                width: 25*app.scaleFactor
                imageSource: "../images/delete.png"
                anchors.rightMargin: 10
                anchors.leftMargin: 15
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                iconOverlayColor: "#FFFFFF"
                onIconClicked: {
                    console.log(">>>> rootPreview.source: " + rootPreview.source)
                    discarded();
                    rootPreview.visible = false; //Go back to previous page after deleting
                }
            }

            IconTemplate {
                imageSource: "../images/clear.png"
                height: 25*app.scaleFactor
                width: 25*app.scaleFactor
                anchors.rightMargin: 15
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                iconOverlayColor: "#FFFFFF"
                onIconClicked: {
                    console.log(">>>> rootPreview.source: " + rootPreview.source )
                    rootPreview.visible = false;
                    infoPanel.visible = false;
                    refresh();
                }
            }
        }


        Rectangle {
            id: mainPreviewSection
            Layout.fillHeight: true
            Layout.fillWidth: true
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            color: app.cameraViewBackgroundColor
            clip: true

            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {

                    //recenter
                    imageFrame.x = rootPreview.x + (mainPreviewSection.width - imageFrame.width) / 2
                    imageFrame.y = rootPreview.y + (mainPreviewSection.height - imageFrame.height) / 2
                    imageFrame.rotation = 0;
                    imageFrame.scale = 1;
                }
            }

            Rectangle {
                id: imageFrame
                width: parent.width
                height: parent.height
                scale: 1.0

                smooth: true
                antialiasing: true

                color: "transparent"
                border.color: "transparent"
                border.width: 0

                //Load the image being previewed
                Image {
                    id: image
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: rootPreview.source
                    antialiasing: true
                    autoTransform: true
                }

                //Pinch settings for screen
                PinchArea {
                    anchors.fill: parent
                    pinch.target: imageFrame
                    pinch.minimumScale: 1
                    pinch.maximumScale: 10
                    pinch.dragAxis: Pinch.XAndYAxis

                    onPinchFinished: {
                        if(scale<1.0) imageFrame.scale=1.0;
                        imageFrame.rotation = Math.round(imageFrame.rotation/90)*90
                    }

                    MouseArea {
                        id: dragArea
                        hoverEnabled: true
                        anchors.fill: parent
                        drag.target: imageFrame
                        scrollGestureEnabled: false

                        onWheel: {
                            imageFrame.rotation += wheel.angleDelta.x / 120;
                            if (Math.abs(imageFrame.rotation) < 0.6)
                                imageFrame.rotation = 0;
                            var scaleBefore = imageFrame.scale;
                            imageFrame.scale += imageFrame.scale * wheel.angleDelta.y / 120 / 10;

                            if(imageFrame.scale<1.0) imageFrame.scale=1.0;
                            imageFrame.rotation = Math.round(imageFrame.rotation/90)*90
                        }

                        //Recenter and resize to original
                        onDoubleClicked: {
                            imageFrame.x = rootPreview.x + (mainPreviewSection.width - imageFrame.width) / 2
                            imageFrame.y = rootPreview.y + (mainPreviewSection.height - imageFrame.height) / 2
                            imageFrame.rotation = 0;
                            imageFrame.scale = 1;
                        }

                        onReleased: {
                            if(scale<1.0) imageFrame.scale=1.0;
                            imageFrame.rotation = Math.round(imageFrame.rotation/90)*90
                        }
                    }
                }
            }
        }

        Rectangle {
            id: previewFooterRect
            Layout.alignment: Qt.AlignTop
            color: app.cameraViewBackgroundColor
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50 * app.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: app.isIPhoneX ? 20 * app.scaleFactor : 0
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 5000
        active: rootPreview.visible
    }

    ExifInfo {
        id: exifInfo
    }

    ImageObject{
        id: imageObject
    }

    //Delete image signal
    onDiscarded: {
        app.tempPath = attachmentListModel.get(thumbGridView.currentIndex).path;
        console.log(">>>> thumbGridView.currentIndex: ", thumbGridView.currentIndex, app.tempPath);

        app.tempImageFilePath = AppFramework.resolvedPath(app.tempPath);
        fileFolder.removeFile (app.tempImageFilePath);
    }

}



