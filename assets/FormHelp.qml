import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtPositioning 5.8
import QtSensors 5.3
import QtMultimedia 5.2
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Networking 1.0
import ArcGIS.AppFramework.Platform 1.0

import Esri.ArcGISRuntime 100.7


import "../ui_controls"
import "../images"


/*
Form Help Page
*/


Item {

    id: help
    visible: false
    width: parent.width*0.90;
    height: parent.height*0.90;

    Layout.alignment: Qt.AlignRight | Qt.AlignTop
    anchors.centerIn: parent

    property color backgroundColor: app.appBackgroundColor
    property color textColor : app.appSecondaryTextColor

    property string imgCamera: "../images/camera.png"



    Rectangle {
        anchors.fill: parent
        color: app.appBackgroundColor
        border.color: app.primaryColor
        border.width: 5
        radius: 3

        Rectangle {
            anchors.centerIn: parent
            color: app.appBackgroundColor
            width: parent.width*0.80;
            height: parent.height*0.90;
            id: topSection


            ColumnLayout {
                spacing: 0
                Layout.alignment: Qt.AlignRight | Qt.AlignTop

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: "Add Report Details  "
                    color: app.appPrimaryTextColor;
                    wrapMode: Text.Wrap
                    bottomPadding: 5 * app.scaleFactor
                    font.bold: true
                }


                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: "This page is used to provide the required and optional information about the report."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }


                Label {
                    font.pixelSize: app.baseFontSize*.3
                    text: "Required fields: (denoted with *)"
                    color: 'red'
                    wrapMode: Text.Wrap
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: "Report Type\nSupporting Photos\nReport Location"
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                    leftPadding: 15*app.scaleFactor
                }
                Label {
                    font.pixelSize: app.baseFontSize*.3
                    text: "Optional fields: "
                    color: app.appSecondaryTextColor
                    wrapMode: Text.Wrap
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: "Description"
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                    leftPadding: 15*app.scaleFactor
                }
                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: "Report Location is derived from the location selected in the previous map.\n\nDescription is highly recommended, especially when report type is 'Other'.\n\nAt least 1 supporting photo is required."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }




                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: app.appBorderColorCaseList
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 5*app.scaleFactor
                    color: "transparent"
                }

                //Report types
                RowLayout{
                    Image{
                        id: myloc
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: imgCamera
                        antialiasing: true
                        autoTransform: true
                    }


                    Label{
                        text: 'Triggers the device camera to capture \nimages of the incident'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 2;
                        color: app.appSecondaryTextColor;
                    }
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: "transparent"
                }
            }
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log(">>>> HELP PAGE: Clicking within mouse area......")
            help.visible = false
        }
    }

}


