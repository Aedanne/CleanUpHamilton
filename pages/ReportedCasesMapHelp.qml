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
Reported Cases Map Help Page
*/


Item {

    id: help
    visible: false
    width: parent.width*0.90;
    height: parent.height;

    Layout.alignment: Qt.AlignRight | Qt.AlignTop
    anchors.centerIn: parent

    property color backgroundColor: app.appBackgroundColor
    property color textColor : app.appSecondaryTextColor

    property string imgRubbish: "../images/type_rubbish.png"
    property string imgOther: "../images/type_other.png"
    property string imgGraffiti: "../images/type_graffiti.png"
    property string imgBroken: "../images/type_broken.png"

    property string imgMyLoc: "../images/my_loc.png"



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
                    text: "Reported Cases Map "
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
                    text: "This map acts as a filter and is used to set the work area for cases that will be included in the worklist in the next page. If GPS location is enabled on the device for this application, the map will display the current location. Otherwise, pan and zoom in/out of the map to set the work area."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: "Only cases that are currently in Pending and Assigned status will display in this map. The counts for each status are displayed below. When the map area is changed, this will submit a query request and the cases displayed in the map will be updated accordingly."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: "Once satisfied with the work area shown in the map, click the Next button to proceed to the Reported Cases worklist."
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
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: imgGraffiti
                        antialiasing: true
                        autoTransform: true
                    }

                    Label{
                        text: 'Represents a report type: Graffiti'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 1;
                        color: app.appSecondaryTextColor;
                    }
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: "transparent"
                }

                RowLayout{
                    Image{
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: imgBroken
                        antialiasing: true
                        autoTransform: true
                    }

                    Label{
                        text: 'Represents a report type: Broken items'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 1;
                        color: app.appSecondaryTextColor;
                    }
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: "transparent"
                }

                RowLayout{
                    Image{
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: imgRubbish
                        antialiasing: true
                        autoTransform: true
                    }

                    Label{
                        text: 'Represents a report type: Illegal rubbish dumping'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 1;
                        color: app.appSecondaryTextColor;
                    }
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: "transparent"
                }

                RowLayout{
                    Image{
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: imgOther
                        antialiasing: true
                        autoTransform: true
                    }

                    Label{
                        text: 'Represents a report type: Other'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 1;
                        color: app.appSecondaryTextColor;
                    }
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 5*app.scaleFactor
                    color: "transparent"
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
                        source: imgMyLoc
                        antialiasing: true
                        autoTransform: true
                    }


                    Label{
                        text: 'Triggers the device GPS location, if enabled'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 1;
                        color: app.appSecondaryTextColor;
                    }
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

