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
Cases List Help Page
*/


Rectangle {
    id: help
    visible: false
    Layout.preferredWidth: parent.width
    Layout.preferredHeight: parent.height
    color: app.appBackgroundColor


    property string imgRubbish: "../images/type_rubbish.png"
    property string imgOther: "../images/type_other.png"
    property string imgGraffiti: "../images/type_graffiti.png"
    property string imgBroken: "../images/type_broken.png"

    property string imgAssignedGreen: "../images/assigned_green.png"
    property string imgAssignedGray: "../images/assigned_gray.png"
    property string imgAssignedYellow: "../images/assigned_yellow.png"

    property string imgAssignToMe: "../images/assigntome.png"
    property string imgCancel: "../images/cancel.png"
    property string imgComplete: "../images/complete.png"
    property string imgEdit: "../images/edit_black.png"
    property string imgRevert: "../images/revert.png"
    property string imgAttachment: "../images/paperclip.png"


    ColumnLayout {
        spacing: 0

        anchors {
//            fill: parent
            leftMargin: 40 * app.scaleFactor
            rightMargin: 40 * app.scaleFactor
            topMargin: 15 * app.scaleFactor
        }

        Rectangle {
            Layout.preferredHeight: parent.height*0.85
            Layout.preferredWidth: app.width*0.9
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: app.appBackgroundColor
            id: mainCol
//            left: 20*app.scaleFactor

            ColumnLayout {
                width: mainCol.width;
                Layout.fillWidth: true
                spacing: 0

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: "Reported Cases  "
                    color: app.appPrimaryTextColor;
                    wrapMode: Text.Wrap
                    topPadding: 10 * app.scaleFactor
                    bottomPadding: 10 * app.scaleFactor
                    font.bold: true
                }


                TextArea {
                    Material.accent: "transparent"
                    selectByMouse: true
                    wrapMode: TextEdit.WrapAnywhere
                    color: app.appSecondaryTextColor
                    text: "This page shows a filterable list of reported cases based on the area selected in the Reported Cases Map."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    bottomPadding: 5*app.scaleFactor
                    Layout.preferredWidth: parent.width
                    Layout.fillWidth: true

                }

                TextArea {
                    Material.accent: "transparent"
                    selectByMouse: true
                    wrapMode: TextEdit.WrapAnywhere
                    color: app.appSecondaryTextColor
                    text: "The cases can be filtered using the status dropdown."
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    bottomPadding: 5*app.scaleFactor
                    Layout.preferredWidth: parent.width
                    Layout.fillWidth: true
                }


                RowLayout{
                    anchors.fill: parent;
                    visible: true;
                    enabled: true;

                    Image{
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: imgGraffiti
                        visible: true
                        antialiasing: true
                        autoTransform: true
                    }
                    Label{
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
                        text: 'Represents a report type: Graffiti'
                        font.pixelSize: app.baseFontSize*0.3;
                        font.bold: false
                        maximumLineCount: 1;
                        color: app.appSecondaryTextColor;
                        visible: true;

                    }
                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgBroken
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Represents a report type: Broken'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgRubbish
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Represents a report type: Illegal rubbish dumping'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgOther
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Represents a report type: Other'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }


//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgAssignedGray
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Report case is unassigned.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgAssignedGreen
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Report case is assigned to the current logged in user.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgAssignedYellow
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Report case is assigned to a different user.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }



//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgAssignToMe
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Report case is pending status and can be assigned.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgAttachment
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'View case image attachments.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgEdit
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Access the Reported Case Edit page.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgCancel
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Cancel this case. Disabled if assigned to a different user.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgRevert
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Rollback to previous status. Disabled if assigned to a different user.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }

//                RowLayout{

//                    anchors.fill: parent;
//                    spacing: 7*app.scaleFactor;
//                    visible: true;
//                    enabled: true;


//                    Image{
//                        Layout.preferredWidth: 25*app.scaleFactor
//                        Layout.preferredHeight: 25*app.scaleFactor
//                        source: imgComplete
//                        visible: true
//                        antialiasing: true
//                        autoTransform: true
//                    }
//                    Label{
//                        Layout.fillWidth: true;
//                        Layout.fillHeight: true;
//                        verticalAlignment: Text.AlignVCenter;
//                        text: 'Complete case. Disabled if assigned to a different user.'
//                        font.pixelSize: app.baseFontSize*0.3;
//                        font.bold: false
//                        maximumLineCount: 1;
//                        color: app.appSecondaryTextColor;
//                        visible: true;

//                    }
//                }
            }
        }




    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("outside......")
            help.visible = false
        }
    }

}
