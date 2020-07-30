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


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: FORM PAGE INFO PAGE";
    }


    //Main body of the page =============================================================
//    Rectangle{
//        anchors.fill: parent;
//        color: app.appBackgroundColor;
//        width: parent.width*0.75;
//        Layout.alignment: Qt.AlignCenter;

//        Label{
//            Material.theme: app.lightTheme? Material.Light : Material.Dark;
//            anchors.centerIn: parent;
//            font.pixelSize: app.titleFontSize;
//            font.bold: true;
//            wrapMode: Text.Wrap;
//            padding: 16*app.scaleFactor;
//            text: descText > ""? descText:"";
//            leftPadding: 100;
//        }
//    }

    //Position of the device
    PositionSource {
        id: positionSource
        updateInterval: 5000
        active: false
    }

    contentItem: Rectangle{
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: 50 * app.scaleFactor

        ColumnLayout{

            Layout.preferredWidth: parent.width*0.75;
            spacing: 1

            anchors {
                fill: parent
                margins: 20 * AppFramework.displayScaleFactor
            }

            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: "Select incident to report:"
                color: app.appPrimaryTextColor;
            }

            ComboBox {
                id: typeComboBox
                Layout.fillWidth: true
                currentIndex: 0
                font.bold: true
                font.pixelSize: app.baseFontSize*.4

                delegate: ItemDelegate {
                    width: parent.width
                    contentItem: Text {
                        text: modelData
                        color: app.appSecondaryTextColor
                        font: control.font
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
                onCurrentIndexChanged: console.debug(cbItems.get(currentIndex).text + ", " + cbItems.get(currentIndex).color)
            }

            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: "Enter description:"
                color: app.appPrimaryTextColor;
                topPadding: 20 * app.scaleFactor
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 100 * scaleFactor
                border.color: app.appPrimaryTextColor
                border.width: 1 * scaleFactor
                radius: 2
                ScrollView {
                    anchors.fill: parent
                    contentItem: parent

                    TextArea {
                        id: descriptionField
                        width: parent.width*.8
                        Material.accent: "#8f499c"
                        padding: 5 * scaleFactor
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        placeholderText: "Enter additional information..."
                        text: ""
//                        style: TextAreaStyle {
//                                textColor: app.appPrimaryTextColor
//                                selectionColor: "gray"
//                                selectedTextColor: app.appPrimaryTextColorInverted
//                                backgroundColor: "gray"
//                        }

//                        background: Rectangle {
//                                implicitWidth: 200
//                                implicitHeight: 40
//                                border.color: control.enabled ? "#21be2b" : "transparent"
//                            }

                    }
                }
            }


//            Row{
//                Layout.alignment: Qt.AlignHCenter
//                width: Math.min(parent.width*0.80, 600*app.scaleFactor)
//                spacing: 1

//                ColumnLayout{
//                    width: iconwidth*app.scaleFactor
//                    enabled: true

                    IconTemplate{
                        containerSize: 20 * app.scaleFactor
                        imageSource: "../images/camera.png"
                        color: "#6e6e6e"
                        Layout.alignment: Qt.AlignHCenter
                        onIconClicked: {
                            activeTool="take_picture"
                            if (Qt.platform.os === "ios" || Qt.platform.os === "android"){
                                if(Permission.checkPermission(Permission.PermissionTypeLocationAlwaysInUse) === Permission.PermissionResultGranted)
                                {
                                    if (Qt.platform.os === "android") {
                                        positionSource.start();
                                    }
                                    else
                                        positionSource.active = true;
                                }
                            }
                            else
                            {
                                positionSource.start();
                            }

                            if(Qt.platform.os === "android" || Qt.platform.os === "ios")
                            {
                                if(Permission.checkPermission(Permission.PermissionTypeCamera) === Permission.PermissionResultGranted)
                                {
                                    cameraDialog.captureMode = CameraDialog.CameraCaptureModeStillImage
                                    if(Qt.platform.os !== "ios" && Qt.platform.os !== "android")
                                        cameraDialog.z = 88

                                    cameraDialog.open()
                                }
                                else
                                {
                                    permissionDialog.permission = PermissionDialog.PermissionDialogTypeCamera;

                                    permissionDialog.open()
                                }



                            }
                            else
                            {
                                cameraDialog.z = 88
                                cameraDialog.open()
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        font.pixelSize: app.baseFontSize*.5
                        font.family: app.customTextFont.name
                        color: app.textColor
                        text: qsTr("Camera")
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        fontSizeMode: Text.Fit
                    }
//                }
//            }




        }

    }

    CameraDialog{
        id:cameraDialog

        onAccepted: {
            if(captureMode === CameraDialog.CameraCaptureModeStillImage)
            {
                if(positionSource.position.coordinate.latitude)
                    addGPSParameters(fileUrl)
                resizeImage(fileUrl)
                app.selectedImageFilePath = fileUrl

                appModel.append(
                            {path: app.selectedImageFilePath.toString(), type: "attachment"}
                            )

                photoReady = true
                visualListModel.initVisualListModel();

                if (Qt.platform.os === "android") {
                    positionSource.stop()
                }
                else
                    positionSource.active = false;


            }
            else
            {


                if(!videoFolder.exists)
                    videoFolder.makeFolder()
                var fileInfo = AppFramework.fileInfo(fileUrl);
                var vfolder = fileInfo.folder
                var iscopied = vfolder.copyFile(fileInfo.fileName,videoFolder.path + "/"+ fileInfo.fileName)

                vfolder.removeFile(fileUrl)
                var  videoFileInfo = videoFolder.fileInfo(fileInfo.fileName)
                app.selectedImageFilePath = videoFileInfo.filePath

                var videopath = "file://" + videoFolder.path + "/"+ fileInfo.fileName //videoFileInfo.filePath//fileUrl


                appModel.append({path: videopath, type: "attachment2"})

                visualListModel.initVisualListModel();
            }
        }
    }



    //Footer custom QML =================================================================
    footer: FooterSection {
        logMessage: "In Form Page - Footer..."
    }

}

