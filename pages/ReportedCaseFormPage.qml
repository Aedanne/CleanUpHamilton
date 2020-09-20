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
    property string reportedCaseWorkerNote
    property string reportedCaseDescription
    property string reportedCaseLonLat
    property string reportedCaseCurrentStatus
    property string reportedCaseAssignedDate
    property string reportedCaseAssignedUser
    property string reportedCaseReportedDateString
    property string reportedCaseLastUpdateUser
    property string reportedCaseLastUpdate
    property int reportedCaseObjectId
    property AttachmentListModel reportedCaseAttListModel

    property string imgRubbish: "../images/type_rubbish.png"
    property string typeRubbish: 'Illegal rubbish dumping'

    property string imgOther: "../images/type_other.png"
    property string typeOther: 'Other'

    property string imgGraffiti: "../images/type_graffiti.png"
    property string typeGraffiti: 'Graffiti'

    property string imgBroken: "../images/type_broken.png"
    property string typeBroken: 'Broken items'

    property string imgAssignToMe: "../images/assigntome.png"
    property string imgCancel: "../images/cancel.png"
    property string imgComplete: "../images/complete.png"
    property string imgEdit: "../images/edit_black.png"
    property string imgRevert: "../images/revert.png"
    property string imgAttachment: "../images/paperclip.png"

    property int imgSizeBottom: 28 * app.scaleFactor
    property bool querying: false;



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
                    font.pixelSize: app.baseFontSize*.4
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
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Description: "
                    color: app.appPrimaryTextColor;
                    topPadding: 15 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    text: reportedCaseDescription
                    color: app.appSecondaryTextColor;
                    topPadding: 15 * app.scaleFactor
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
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Report Location "
                    color: app.appPrimaryTextColor;
                    topPadding: 15 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
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
                    font.pixelSize: app.baseFontSize*.4
                    text: debugText
                    visible: false
                    color: 'red';
                    topPadding: 25 * app.scaleFactor
                }
            }


            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 53 * app.scaleFactor

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    //Padding
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor
                        visible: reportedCaseCurrentStatus !== 'Assigned' ? true : false;

                        Image{
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            visible: reportedCaseCurrentStatus !== 'Assigned' ? true : false;
                            enabled: reportedCaseCurrentStatus !== 'Assigned' ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }

                    }

                    //Assign to me
                    Rectangle {
                        id: assigntome
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor
                        visible: reportedCaseCurrentStatus === 'Pending' ? true : false;

                        Image{
                            id: assign
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            source: imgAssignToMe
                            visible: reportedCaseCurrentStatus === 'Pending' ? true : false;
                            enabled: reportedCaseCurrentStatus === 'Pending' ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }

                        DropShadow {
                                anchors.fill: assign
                                horizontalOffset: 2
                                verticalOffset: 2
                                radius: 4.0
                                samples: 17
                                color: "#aa000000"
                                source: assign
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                updateFeature(app.reportedCaseFeature, 'AssignToMe', reportedCaseCurrentStatus, reportedCaseWorkerNote);
                            }
                        }

                    }

                    // Attachment view icon
                    Rectangle {
                        id: attachmentview
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor

                        Image{
                            id: viewAttachment
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            source: imgAttachment
                            visible: true;
                            enabled: true;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }

                        DropShadow {
                                anchors.fill: viewAttachment
                                horizontalOffset: 2
                                verticalOffset: 2
                                radius: 4.0
                                samples: 17
                                color: "#aa000000"
                                source: viewAttachment
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log(">>> MOUSE AREA: View Attachments, featureId:", reportedCaseObjectId, reportedCaseFeature)
                                attachmentViewer.visible = true;
                                reportedCaseAttListModel = app.reportedCaseFeature.attachments
                            }
                        }

                    }

                    //Cancel item
                    Rectangle {
                        id: cancelitem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor
                        visible: reportedCaseCurrentStatus === 'Assigned' ? true : false;

                        Image{
                            id: cancel
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            source: imgCancel
                            visible: reportedCaseCurrentStatus === 'Assigned' ? true : false;
                            enabled: (reportedCaseCurrentStatus === 'Assigned' && reportedCaseAssignedUser === app.portalUser) ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }



                        DropShadow {
                                anchors.fill: cancel
                                horizontalOffset: 2
                                verticalOffset: 2
                                radius: 4.0
                                samples: 17
                                color: "#aa000000"
                                source: cancel
                                visible: reportedCaseAssignedUser === app.portalUser ? true : false;
                        }

                        ColorOverlay {
                                anchors.fill: cancel
                                source: cancel
                                color: app.disabledIconColor
                                visible: reportedCaseAssignedUser === app.portalUser ? false : true;
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (reportedCaseAssignedUser === app.portalUser) {
                                    updateFeature(app.reportedCaseFeature, 'Cancel', reportedCaseCurrentStatus, reportedCaseWorkerNote)
                                } else {
                                   console.log(">>>> DISABLED: NOT ASSIGNED USER: updateFeature(feature, 'Cancel', currentStatus)")
                                }
                            }
                        }

                    }

                    //Revert status of item
                    Rectangle {
                        id: revertitem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor
                        visible: reportedCaseCurrentStatus !== 'Pending' ? true : false;

                        Image{
                            id: revert
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            source: imgRevert
                            visible: reportedCaseCurrentStatus !== 'Pending' ? true : false;
                            enabled: (reportedCaseCurrentStatus !== 'Pending' && reportedCaseAssignedUser === app.portalUser) ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }

                        DropShadow {
                                anchors.fill: revert
                                horizontalOffset: 2
                                verticalOffset: 2
                                radius: 4.0
                                samples: 17
                                color: "#aa000000"
                                source: revert
                                visible: reportedCaseAssignedUser === app.portalUser ? true : false;
                        }

                        ColorOverlay {
                                anchors.fill: revert
                                source: revert
                                color: app.disabledIconColor
                                visible: reportedCaseAssignedUser === app.portalUser ? false : true;
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (reportedCaseAssignedUser === app.portalUser) {
                                    updateFeature(app.reportedCaseFeature, 'Revert', reportedCaseCurrentStatus, reportedCaseWorkerNote)
                                } else {
                                   console.log(">>>> DISABLED: NOT ASSIGNED USER: updateFeature(feature, 'Revert', currentStatus)")
                                }

                            }
                        }

                    }

                    //Complete case
                    Rectangle {
                        id: completeitem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor
                        visible: reportedCaseCurrentStatus === 'Assigned' ? true : false;

                        Image{
                            id: complete
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            source: imgComplete
                            visible: reportedCaseCurrentStatus === 'Assigned' ? true : false;
                            enabled: (reportedCaseCurrentStatus === 'Assigned' && reportedCaseAssignedUser === app.portalUser) ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }

                        DropShadow {
                                anchors.fill: complete
                                horizontalOffset: 2
                                verticalOffset: 2
                                radius: 4.0
                                samples: 17
                                color: "#aa000000"
                                source: complete
                                visible: reportedCaseAssignedUser === app.portalUser ? true : false;
                        }

                        ColorOverlay {
                                anchors.fill: complete
                                source: complete
                                color: app.disabledIconColor
                                visible: reportedCaseAssignedUser === app.portalUser ? false : true;
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (reportedCaseAssignedUser === app.portalUser) {
                                    updateFeature(app.reportedCaseFeature, 'Complete', reportedCaseCurrentStatus, reportedCaseWorkerNote)
                                } else {
                                   console.log(">>>> DISABLED: NOT ASSIGNED USER: updateFeature(feature, 'Complete', currentStatus)")
                                }

                            }
                        }

                    }

                    //Padding
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColor
                        visible: reportedCaseCurrentStatus !== 'Assigned' ? true : false;

                        Image{
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            visible: reportedCaseCurrentStatus !== 'Assigned' ? true : false;
                            enabled: reportedCaseCurrentStatus !== 'Assigned' ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }
                    }
                }
            }



            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.2
                font.bold: true
                text: ""
                color: app.appPrimaryTextColor;
                verticalAlignment: Text.AlignTop
                topPadding: 50 * app.scaleFactor
            }

        }

    }






    QueryParameters {
        id: params
        maxFeatures: 1
    }


    // Attachment Viewer Overlay ================================================

    Rectangle {
        id: attachmentViewer
        visible: false
        width: app.width;
        height: app.height;
        anchors.centerIn: parent
        color: "transparent"

        ColumnLayout {
            spacing: 0

            Rectangle {
                id: topArea
                visible: true
                width: app.width;
                height: app.height*0.25;
                opacity: 0.65

                MouseArea {
                    anchors.fill: topArea
                    onClicked: {
                        console.log("outside......")
                        attachmentViewer.visible = false
                    }
                }

            }

            Item {
                width: app.width;
                height: app.height*0.5;
                anchors.centerIn: parent

                SwipeView {
                    id: swipeView
                    visible: true
                    anchors.fill: parent

                    Repeater {
                        model: reportedCaseAttListModel

                        Item {
                            id: delegateAttachments


                            Rectangle {
                                color: app.cameraViewBackgroundColor
                                visible: true
                                anchors.top: parent.top
                                height: parent.height

                                Image {
                                    id: attachment
                                    horizontalAlignment: Qt.AlignHCenter
                                    height: parent.height
                                    fillMode: Image.PreserveAspectFit
                                    source: attachmentUrl
                                    onSourceChanged: {
                                        console.log(">>>> Attachment Viewer Section: Src: ",source)
                                    }
                                }
                            }

                            Button {
                                width: 25*app.scaleFactor
                                enabled: index > 0
                                onClicked: delegateAttachments.SwipeView.view.decrementCurrentIndex()
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                contentItem: Image {
                                    source: '../images/back.png';
                                    visible: true
                                    enabled: index > 0
                                    fillMode: Image.PreserveAspectFit
                                    width: 25*app.scaleFactor
                                    height: 50*app.scaleFactor

                                }
                            }

                            Button {
                                width: 25*app.scaleFactor
                                enabled: index < delegateAttachments.SwipeView.view.count - 1
                                onClicked: delegateAttachments.SwipeView.view.incrementCurrentIndex()
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                contentItem: Image {
                                    width: 25*app.scaleFactor
                                    source: '../images/next.png';
                                    visible: true
                                    enabled: index < delegateAttachments.SwipeView.view.count - 1
                                    fillMode: Image.PreserveAspectFit
                                    height: 50*app.scaleFactor

                                }
                            }
                        }
                    }
                }
            }


            Rectangle {
                id: bottomArea
                visible: true
                width: app.width;
                height: app.height*0.25;
                opacity: 0.65

                MouseArea {
                    anchors.fill: bottomArea
                    onClicked: {
                        console.log("outside......")
                        attachmentViewer.visible = false
                    }
                }
            }
        }
    }


    BusyIndicator {
        id: busy
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.centerIn: parent
        anchors.topMargin: 200*app.scaleFactor
        Material.accent: app.primaryColor
        running: querying
    }


    //Footer custom QML =================================================================
    footer: FooterSection {
        id: formPageFooter
        logMessage: "In Form Page - Footer..."
        rightButtonText: "SAVE"
        overrideRightIconSrc: "../images/save.png"
//        overrideRightIconSz: 20
    }



    //===================================================================================

    function init() {
        //Load data from feature object
        //Attachments, attributes
        querying = false
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

        reportedCaseCurrentStatus = reportFeature.attributes.attributeValue("CurrentStatus");
        reportedCaseAssignedUser = reportFeature.attributes.attributeValue("AssignedUser");
        var assignedDate = reportFeature.attributes.attributeValue("AssignedDate");
        reportedCaseAssignedDate = (assignedDate !== null ? assignedDate.toString() : '')
        reportedCaseReportedDateString = reportFeature.attributes.attributeValue("ReportedDate").toString();
        reportedCaseWorkerNote = reportFeature.attributes.attributeValue("WorkerNote")
        reportedCaseLastUpdateUser =  reportFeature.attributes.attributeValue("LastUpdateUser");
        var lastUpdateDate = reportFeature.attributes.attributeValue("LastUpdate");
        reportedCaseLastUpdate = (lastUpdateDate !== null ? lastUpdateDate.toString() : '')


    }

    //Function to update record
    function updateFeature(feature, actionType, currentStatusVal, workerNoteVal) {

        console.log(">>>> ReportedCaseFormPage: updateFeature()", feature, "  actionType:", actionType)
//        app.lastStatusCaseList = reportedCaseCurrentStatus

        var workerNoteSubStr = '';
        if (actionType === 'AssignToMe') {
            workerNoteSubStr = 'EDIT: Pending to Assigned from Case List Page. ';
            feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
            feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
            feature.attributes.replaceAttribute("AssignedDate", new Date());
        } else if (actionType === 'Revert') {
            workerNoteSubStr = 'EDIT: Reverted from ';
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
            workerNoteSubStr = 'EDIT: Marked Completed from Case List Page. ';
            feature.attributes.replaceAttribute("CurrentStatus", "Completed");
            feature.attributes.replaceAttribute("CompletedUser", app.portalUser);
            feature.attributes.replaceAttribute("CompletedDate", new Date());
        } else if (actionType === 'Cancel') {
            workerNoteSubStr = 'EDIT: Marked Cancelled from Case List Page. ';
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
        console.log(">>>> ReportedCaseFormPage: updateFeature() - performing update");

        querying = true;
        app.reportedCasesFeatureService.updateFeature(feature);

        //Hide actions
        cancelitem.visible = false
        completeitem.visible = false
        revertitem.visible = false
        assigntome.visible = false
        attachmentview.visible = false


        nextPage()
        //Load next page from stack


    }





}

