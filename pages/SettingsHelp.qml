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
Settings Help Page
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
                    text: "Settings  "
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
                    text: "The application primary color can be overriden here."
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
                    text: "The override primary color must be in HEX color code format, prefixed with the # symbol (for example: #FFFFFF or #FFF)."
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
                    text: "The override is immediately applied to the application, but will not persist beyond the current session unless the SAVE button is clicked. This will save the override primary color to the device's database."
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
                    text: "To restore the original application primary color, clear out the override primary color field and save."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }



//                //Separator
//                Rectangle {
//                    Layout.fillWidth: true
//                    implicitHeight: 1
//                    color: app.appBorderColorCaseList
//                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 5*app.scaleFactor
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


