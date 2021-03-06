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


import '../ui_controls'
import '../images'


/*
Cases List Help Page
*/


Item {

    id: help
    visible: false
    width: parent.width*0.90
    height: parent.height*0.90

    Layout.alignment: Qt.AlignRight | Qt.AlignTop
    anchors.centerIn: parent

    property color backgroundColor: app.appBackgroundColor
    property color textColor : app.appSecondaryTextColor

    property string imgRubbish: '../images/type_rubbish.png'
    property string imgOther: '../images/type_other.png'
    property string imgGraffiti: '../images/type_graffiti.png'
    property string imgBroken: '../images/type_broken.png'

    property string imgAssignedGreen: '../images/assigned_green.png'
    property string imgAssignedGray: '../images/assigned_gray.png'
    property string imgAssignedYellow: '../images/assigned_yellow.png'

    property string imgAssignToMe: '../images/assigntome.png'
    property string imgCancel: '../images/cancel.png'
    property string imgComplete: '../images/complete.png'
    property string imgEdit: '../images/edit_black.png'
    property string imgRevert: '../images/revert.png'
    property string imgAttachment: '../images/paperclip.png'


    Rectangle {
        anchors.fill: parent
        color: app.appBackgroundColor
        border.color: app.primaryColor
        border.width: 5
        radius: 3

        Rectangle {
            anchors.centerIn: parent
            color: app.appBackgroundColor
            width: parent.width*0.80
            height: parent.height*0.90
            id: topSection

            ColumnLayout {
                spacing: 0
                Layout.alignment: Qt.AlignRight | Qt.AlignTop

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: 'Reported Cases  '
                    color: app.appPrimaryTextColor
                    wrapMode: Text.Wrap
                    bottomPadding: 5 * app.scaleFactor
                    font.bold: true
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: 'This page shows a filterable list of reported cases based on the area selected in the Reported Cases Map.\nActions are disabled/grayed out based on the status and if the case is assigned to a different user.'
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
                    color: 'transparent'
                }

                //Report types ---------------------------------------
                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgGraffiti
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Represents a report type: Graffiti'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgBroken
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Represents a report type: Broken items'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgRubbish
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Represents a report type: Illegal rubbish dumping'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgOther
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Represents a report type: Other'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 5*app.scaleFactor
                    color: 'transparent'
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
                    color: 'transparent'
                }


                //Assignment status ----------------------------------------
                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgAssignedGreen
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Reported case is assigned to logged in user'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgAssignedGray
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Reported case is unassigned'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgAssignedYellow
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'Reported case is assigned to a different user'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 5*app.scaleFactor
                    color: 'transparent'
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
                    color: 'transparent'
                }

                //Actions ------------------------------------------------
                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgAssignToMe
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'ACTION: Assign case to logged in user'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgAttachment
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'ACTION: View case image attachments'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgEdit
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'ACTION: Edit reported case details'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgCancel
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'ACTION: Cancel reported case'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgRevert
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'ACTION: Rollback case to previous status'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 2*app.scaleFactor
                    color: 'transparent'
                }

                RowLayout {

                    Image {
                        Layout.preferredWidth: 20*app.scaleFactor
                        Layout.preferredHeight: 20*app.scaleFactor
                        source: imgComplete
                        antialiasing: true
                        autoTransform: true
                    }

                    Label {
                        text: 'ACTION: Mark reported case as complete'
                        font.pixelSize: app.baseFontSize*0.3
                        font.bold: false
                        maximumLineCount: 1
                        color: app.appSecondaryTextColor
                    }
                }
            }
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log('>>>> HELP PAGE: Clicking within mouse area......')
            help.visible = false
        }
    }

}
