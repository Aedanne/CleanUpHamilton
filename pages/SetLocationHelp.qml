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
Set Location Help Page
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

    property string imgMyLoc: "../images/my_loc.png"
    property string imgPin: "../images/pin.png"



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
                    text: "Set Report Location  "
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
                    text: "This map is used to set the location of the incident being reported."
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
                    text: "If the GPS location is enabled for this application, the current location of the device will load in the map."
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
                    text: "If the application is not given permission to access the device location, manually pan and zoom in/out of the map to locate the correct location for this report."
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
                    text: "The pin icon represents the location that will be included in the report. This is represented as coordinates displayed in the My Location section."
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
                        source: imgPin
                        antialiasing: true
                        autoTransform: true
                    }

                    Label{
                        text: 'Represents the report location'
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

