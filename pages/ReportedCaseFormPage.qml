import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.13

import QtPositioning 5.13


import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Multimedia 1.0

import Esri.ArcGISRuntime 100.5
import ArcGIS.AppFramework.Platform 1.0


import "../ui_controls"


/*
Reported Case Form page for Clean-Up Hamilton app
*/

Page {

    id:reportedCaseformPage;
//    anchors.fill: parent;

    signal nextPage();
    signal previousPage();

    property var descText;
    property int maxLimit: 200
    property int currChars;
    property string titleText: ""

    property int attIndex;
    property string qryString;
    property int objectID;

    property bool isDebug: true;
    property string debugText: "Debug on";

    //Attributes
    property int reportedCaseTypeIndex
    property string workerNote
    property string reportedCaseDescription
    property string reportedCaseLonLat
    property string reportedCaseCurrentStatus
    property string reportedCaseAssignedDate
    property string reportedCaseAssignedUser
    property string reportedCaseReportedDateString
    property int reportedCaseObjectId

    property string imgRubbish: "../images/type_rubbish.png"
    property string typeRubbish: 'Illegal rubbish dumping'

    property string imgOther: "../images/type_other.png"
    property string typeOther: 'Other'

    property string imgGraffiti: "../images/type_graffiti.png"
    property string typeGraffiti: 'Graffiti'

    property string imgBroken: "../images/type_broken.png"
    property string typeBroken: 'Broken items'



    //Used for editing exchangeable image (exif) file medatadata
//    ExifInfo{
//        id: exifInfo
//    }

//    function initFeatureService() {
//        //load the feature server when page is loaded, if not already running
//        if (casesFeatureTable.loadStatus != Enums.LoadStatusLoaded) {
//            debugText = ">>>> Form page initFeatureService() -- loading feature layer...";
//            console.log(debugText);
//            casesFeatureTable.load();
//        }
//    }

    function init() {
        //Load data from feature object
        //Attachments, attributes
        const reportFeature = app.reportedCaseFeature

        console.log(">>>> reportFeature: ", reportFeature)
        console.log(">>>> reportFeature.attributes. ", reportFeature.attributes.attributeNames)

        var typeF = reportFeature.attributes.attributeValue("Type");
        if (typeF === typeGraffiti) {
            typeComboBox.currentIndex = 0
        } else if (typeF === typeBroken) {
            typeComboBox.currentIndex = 1
        } else if (typeF === typeRubbish) {
            typeComboBox.currentIndex = 2
        } else {
            typeComboBox.currentIndex = 3
        }

        reportedCaseDescription = reportFeature.attributes.attributeValue("Description");

        var currentStatusF = reportFeature.attributes.attributeValue("CurrentStatus");
        var tempUser = reportFeature.attributes.attributeValue("AssignedUser");
        var assignedUserF = tempUser === null ? '': tempUser;
        var assignedDateF = reportFeature.attributes.attributeValue("AssignedDate");
        var reportedDateF = reportFeature.attributes.attributeValue("ReportedDate");
        var reportedDateStrF = reportedDateF.toString();
        var lastUpdateF = reportFeature.attributes.attributeValue("LastUpdate");
        var tempWorkerNote =  reportFeature.attributes.attributeValue("WorkerNote")
        var workerNoteF = tempWorkerNote === null ? '' : (tempWorkerNote.length > 55 ? (tempWorkerNote.substr(0,55)+'...') : tempWorkerNote)
        var lastUpdateStrF = (lastUpdateF !== null ? lastUpdateF.toString() : '')


    }


    //Header custom QML =================================================================
    header: HeaderSection {
        id: formPageHeader
        logMessage: "TODO: REPORTED CASE FORM PAGE INFO PAGE";

    }




    //Main body of the page =============================================================

    //Position of the device - will be used for tracking GPS information in the photos
//    PositionSource {
//        id: positionSource
//        updateInterval: 5000
//        active: false

//    }

    contentItem: Rectangle {
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: 50 * app.scaleFactor
        color: app.appBackgroundColor

        ColumnLayout {
            Layout.preferredWidth: parent.width*0.75;
            spacing: 0

            anchors {
                fill: parent
                margins: 20 * app.scaleFactor
            }


            RowLayout{

                spacing: 0;
                visible: true;

                Label {
//                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    font.bold: true
                    text: "Report Type "
                    color: app.appPrimaryTextColor;
//                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }


                ComboBox {
                    id: typeComboBox
                    Layout.fillWidth: true
                    currentIndex: reportedCaseTypeIndex
                    font.bold: true
                    font.pixelSize: app.baseFontSize*.4
                    displayText: currentIndex === -1 ? "Please Choose..." : currentText

                    delegate: ItemDelegate {
                        width: parent.width
                        contentItem: Text {
                            text: modelData
                            color: app.appSecondaryTextColor
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
                    onCurrentIndexChanged: {
                        debugText = ">>>> Combo Box selected: " + typeIndex.get(currentIndex).text;
                        console.log(debugText);
                        reportedCaseTypeIndex = currentIndex;
                    }

                    contentItem: Text {
                            leftPadding: 5 * app.scaleFactor
                            rightPadding: typeComboBox.indicator.width + typeComboBox.spacing

                            text: typeComboBox.displayText
                            font: typeComboBox.font
                            color: (typeComboBox.currentIndex === -1) ? "red": app.appSecondaryTextColor
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                }
            }



            RowLayout {

                spacing: 0;
                visible: true;
//                anchors.fill: parent;

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    font.bold: true
                    text: "Description: "
                    color: app.appPrimaryTextColor;
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: reportedCaseDescription
                    color: app.appSecondaryTextColor;
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    wrapMode: Text.Wrap
                    maximumLineCount: 5
                }
            }




            //Location placeholder
            RowLayout{

                spacing: 0;
                visible: true;

                Label {
//                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    font.bold: true
                    text: "Report Location "
                    color: app.appPrimaryTextColor;
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: app.currentLonLat
                    color: app.appSecondaryTextColor
                    font.bold: true
    //                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
    //                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }





            RowLayout{

                spacing: 0;
                visible: isDebug;

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: debugText
                    color: 'red';
                    topPadding: 25 * app.scaleFactor
                }
            }

            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.2
                font.bold: true
                text: ""
                color: app.appPrimaryTextColor;
                verticalAlignment: Text.AlignTop
                topPadding: 200 * app.scaleFactor
            }

        }

    }






    QueryParameters {
        id: params
        maxFeatures: 1
    }




    //Footer custom QML =================================================================
    footer: FooterSection {
        id: formPageFooter
        logMessage: "In Form Page - Footer..."
        rightButtonText: "SAVE"
        overrideRightIconSrc: "../images/save.png"
//        overrideRightIconSz: 20
    }


    //Function to update record
    function updateFeature(feature, actionType, currentStatusVal, workerNoteVal, index) {

        console.log(">>>> CasesListPage: updateFeature()", feature, "  actionType:", actionType)

        var workerNoteSubStr = '';
        if (actionType === 'AssignToMe') {
            workerNoteSubStr = 'Pending to Assigned from Case List Page. ';
            feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
            feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
            feature.attributes.replaceAttribute("AssignedDate", new Date());
        } else if (actionType === 'Revert') {
            workerNoteSubStr = 'Reverted from ';
            if (currentStatusVal === 'Assigned') {
                workerNoteSubStr = workerNoteSubStr + 'Assigned to Pending from Case List Page. ';
                feature.attributes.replaceAttribute("CurrentStatus", "Pending");
                feature.attributes.replaceAttribute("AssignedUser", null);
                feature.attributes.replaceAttribute("AssignedDate", null);
            } else if (currentStatusVal === 'Cancelled') {
                workerNoteSubStr = workerNoteSubStr + 'Cancelled to Assigned from Case List Page. ';
                feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
                feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
                feature.attributes.replaceAttribute("AssignedDate", new Date());
                feature.attributes.replaceAttribute("CancelledUser", null);
                feature.attributes.replaceAttribute("CancelledDate", null);
            } else if (currentStatusVal === 'Completed') {
                workerNoteSubStr = workerNoteSubStr + 'Completed to Assigned from Case List Page. ';
                feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
                feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
                feature.attributes.replaceAttribute("AssignedDate", new Date());
                feature.attributes.replaceAttribute("CompletedUser", null);
                feature.attributes.replaceAttribute("CompletedDate", null);
            }
        } else if (actionType === 'Complete') {
            workerNoteSubStr = 'Marked Completed from Case List Page. ';
            feature.attributes.replaceAttribute("CurrentStatus", "Completed");
            feature.attributes.replaceAttribute("CompletedUser", app.portalUser);
            feature.attributes.replaceAttribute("CompletedDate", new Date());
        } else if (actionType === 'Cancel') {
            workerNoteSubStr = 'Marked Cancelled from Case List Page. ';
            feature.attributes.replaceAttribute("CurrentStatus", "Cancelled");
            feature.attributes.replaceAttribute("CancelledUser", app.portalUser);
            feature.attributes.replaceAttribute("CancelledDate", new Date());
        }

        var workerNote = workerNoteSubStr + workerNoteVal;
        workerNote = workerNote.substr(0,250);
        feature.attributes.replaceAttribute("WorkerNote", workerNote );

        //Update these values regardless of type of edit
        feature.attributes.replaceAttribute("LastUpdateUser", app.portalUser);
        feature.attributes.replaceAttribute("LastUpdate", new Date());

        // update the feature in the feature table asynchronously
        console.log(">>>> CasesListPage: updateFeature() - performing update");
        querying = true;
        casesListFeatureTable.updateFeature(feature);

    }





}

