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
    property int maxLimit: 250
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
    property string imgTakeOver: "../images/takeover.png"
    property string imgCancel: "../images/cancel.png"
    property string imgComplete: "../images/complete.png"
    property string imgEdit: "../images/edit_black.png"
    property string imgRevert: "../images/revert.png"
    property string imgAttachment: "../images/paperclip.png"

    property int imgSizeBottom: 28 * app.scaleFactor
    property bool querying: false;
    property string localWorkerNote: ''



    //Header custom QML =================================================================
    header: HeaderSection {
        id: formPageHeader
        logMessage: "TODO: REPORTED CASE FORM PAGE INFO PAGE";

    }




    //Main body of the page =============================================================

    contentItem: Rectangle {
        Layout.preferredWidth: app.width
        Layout.preferredHeight: parent.height
        color: app.appBackgroundColor

        ColumnLayout {/*
            Layout.preferredWidth: parent.width*0.9;*/
            spacing: 0

            anchors {
                fill: parent
                leftMargin: 20 * app.scaleFactor
                rightMargin: 20 * app.scaleFactor
                topMargin: 15 * app.scaleFactor
            }

            Rectangle {
                Layout.preferredHeight: parent.height*0.85
                Layout.preferredWidth: app.width
                Layout.fillWidth: true
                color: app.appBackgroundColor
                id: mainCol

                ColumnLayout {
                    width: mainCol.width;
                    Layout.fillWidth: true
                    spacing: 0


                    Label {
                        font.pixelSize: app.baseFontSize*.4
                        text: "[Case#"+reportedCaseObjectId+"] Report Type: "
                        color: app.appPrimaryTextColor;
                        wrapMode: Text.Wrap
                        font.bold: true
                    }



                    ComboBox {
                        id: typeComboBox
                        Layout.preferredWidth: parent.width;
                        Layout.fillWidth: true
                        currentIndex: reportedCaseTypeIndex
                        font.bold: true
                        font.pixelSize: app.baseFontSize*.4
                        displayText: currentIndex === -1 ? "Please Choose..." : currentText

                        delegate: ItemDelegate {
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

//                            width: 200
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
                                color: app.appSecondaryTextColor
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                    }







                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Location: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: false
                            text: reportedCaseLonLat
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }
                    }



                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Report Date: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: false
                            text: reportedCaseReportedDateString
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }
                    }

                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Report Description: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }


                    }

                    TextArea {
                        Material.accent: "transparent"
        //                padding: 5 * scaleFactor
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        color: app.appSecondaryTextColor
                        text: reportedCaseDescription
                        enabled: false
                        background: null
                        font.pixelSize: app.baseFontSize*.3
                        bottomPadding: 10*app.scaleFactor
                        Layout.preferredWidth: parent.width
                    }


                    //Separator
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: app.appBorderColorCaseList
                    }

                    RowLayout{
                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Current Status: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 10 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: true
                            text: reportedCaseCurrentStatus
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 10 * app.scaleFactor
                        }
                    }

                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Assigned User: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: false
                            text: reportedCaseAssignedUser
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }
                    }

                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Assigned Date: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: false
                            text: reportedCaseAssignedDate
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }
                    }

                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Last Update By: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: false
                            text: reportedCaseLastUpdateUser
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }
                    }

                    RowLayout{

                        spacing: 5;
                        visible: true;

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            text: "Last Update: "
                            color: app.appPrimaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }

                        Label {
                            font.pixelSize: app.baseFontSize*.35
                            font.bold: false
                            text: reportedCaseLastUpdate
                            color: app.appSecondaryTextColor;
                            wrapMode: Text.Wrap
                            topPadding: 5 * app.scaleFactor
                        }
                    }

                    Label {
                        font.pixelSize: app.baseFontSize*.35
                        text: "Saved Worker Note: "
                        color: app.appPrimaryTextColor;
                        wrapMode: Text.Wrap
                        topPadding: 5 * app.scaleFactor
                    }


                    TextArea {
                        Material.accent: "transparent"
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        color: app.appSecondaryTextColor
                        text: reportedCaseWorkerNote
                        enabled: false
                        background: null
                        font.pixelSize: app.baseFontSize*.3
                        bottomPadding: 10*app.scaleFactor
                        Layout.preferredWidth: parent.width
                    }


                    //Separator
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: app.appBorderColorCaseList
                    }



                    Label {
                        font.pixelSize: app.baseFontSize*.35
                        text: "New Worker Note: "
                        color: app.appPrimaryTextColor;
                        wrapMode: Text.Wrap
                        topPadding: 10 * app.scaleFactor
                        bottomPadding: 5*app.scaleFactor
                    }

                    Rectangle {
                        Layout.preferredHeight: 50 * scaleFactor
                        border.color: app.appSecondaryTextColor
                        Layout.fillWidth: true
                        border.width: 1 * scaleFactor
                        radius: 2
                        ScrollView {
                            anchors.fill: parent
                            contentItem: parent

                            TextArea {
                                id: newWorkerNote
                                Layout.preferredWidth: parent.width
                                Material.accent: app.backgroundAccent
                                background: null
                                padding: 3 * scaleFactor
                                selectByMouse: true
                                wrapMode: TextEdit.WrapAnywhere
                                placeholderText: " Additional details required to save changes..."
                                color: app.appSecondaryTextColor
                                font.pixelSize: app.baseFontSize*.3
                                text: localWorkerNote

                                onTextChanged: {
                                   var currChars = newWorkerNote.text.length
                                   if (currChars >= maxLimit) {
                                      newWorkerNote.text = newWorkerNote.text.substring(0, maxLimit);
                                   }
                                   localWorkerNote = newWorkerNote.text;
                                }
                            }
                        }
                    }


                    Text {
                        font.pixelSize: app.baseFontSize*.2
                        font.bold: true
                        text: ""
                        color: app.appPrimaryTextColor;
                        verticalAlignment: Text.AlignTop
                        topPadding: 50 * app.scaleFactor
                    }
                }
            }


            Rectangle {
                anchors.bottom: footer.top
                Layout.fillWidth: true
                Layout.preferredHeight: 53 * app.scaleFactor
                color: app.appBackgroundColorCaseList

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    //Padding
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColorCaseList
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
                        color: app.appBackgroundColorCaseList
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
                                if (localWorkerNote === '') {
                                    caseFormMissingData.visible = true
                                } else {
                                    updateFeature(app.reportedCaseFeature, 'AssignToMe', reportedCaseCurrentStatus);
                                }
                            }
                        }

                    }


                    //Takeover
                    Rectangle {
                        id: takeovercase
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColorCaseList
                        visible: (reportedCaseCurrentStatus !== 'Pending' && reportedCaseAssignedUser !== app.portalUser) ? true : false;

                        Image{
                            id: takeover
                            anchors.centerIn: parent
                            width: imgSizeBottom
                            height: imgSizeBottom
                            source: imgTakeOver
                            visible: (reportedCaseCurrentStatus !== 'Pending' && reportedCaseAssignedUser !== app.portalUser) ? true : false;
                            enabled: (reportedCaseCurrentStatus !== 'Pending' && reportedCaseAssignedUser !== app.portalUser) ? true : false;
                            fillMode: Image.PreserveAspectFit
                            antialiasing: true;
                        }

                        DropShadow {
                                anchors.fill: takeover
                                horizontalOffset: 2
                                verticalOffset: 2
                                radius: 4.0
                                samples: 17
                                color: "#aa000000"
                                source: takeover
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (localWorkerNote === '') {
                                    caseFormMissingData.visible = true
                                } else {
                                    updateFeature(app.reportedCaseFeature, 'TakeOver', reportedCaseCurrentStatus);
                                }
                            }
                        }

                    }

                    // Attachment view icon
                    Rectangle {
                        id: attachmentview
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColorCaseList

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
                        color: app.appBackgroundColorCaseList
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

                                if (localWorkerNote === '') {
                                    caseFormMissingData.visible = true
                                } else {
                                    if (reportedCaseAssignedUser === app.portalUser) {
                                        updateFeature(app.reportedCaseFeature, 'Cancel', reportedCaseCurrentStatus)
                                    } else {
                                       console.log(">>>> DISABLED: NOT ASSIGNED USER: updateFeature(feature, 'Cancel', currentStatus)")
                                    }
                                }
                            }
                        }

                    }

                    //Revert status of item
                    Rectangle {
                        id: revertitem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColorCaseList
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
                                if (localWorkerNote === '') {
                                    caseFormMissingData.visible = true
                                } else {
                                    if (reportedCaseAssignedUser === app.portalUser) {
                                        updateFeature(app.reportedCaseFeature, 'Revert', reportedCaseCurrentStatus)
                                    } else {
                                       console.log(">>>> DISABLED: NOT ASSIGNED USER: updateFeature(feature, 'Revert', currentStatus)")
                                    }
                                }

                            }
                        }

                    }

                    //Complete case
                    Rectangle {
                        id: completeitem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColorCaseList
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
                                if (localWorkerNote === '') {
                                    caseFormMissingData.visible = true
                                } else {
                                    if (reportedCaseAssignedUser === app.portalUser) {
                                        updateFeature(app.reportedCaseFeature, 'Complete', reportedCaseCurrentStatus)
                                    } else {
                                       console.log(">>>> DISABLED: NOT ASSIGNED USER: updateFeature(feature, 'Complete', currentStatus)")
                                    }
                                }
                            }
                        }

                    }

                    //Padding
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 53 * app.scaleFactor
                        color: app.appBackgroundColorCaseList
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
                topPadding: 20 * app.scaleFactor
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


    FeatureLayer {

        ServiceFeatureTable {
            id: caseEditFeatureTable
            url: app.featureServerURL

            onLoadStatusChanged: {
                console.log(">>>> ReportedCaseFormPage: onLoadStatusChanged --- " + loadStatus);
            }

            onApplyEditsStatusChanged: {
               console.log(">>>> ReportedCaseFormPage: onApplyEditsStatusChanged --- " + loadStatus);
               if (applyEditsStatus === Enums.TaskStatusCompleted) {
                   debugText = ">>>> ReportedCaseFormPage :  successfully edited feature"
                   nextPage()
               }
            }

            onUpdateFeatureStatusChanged: {
                console.log(">>>> ReportedCaseFormPage: onUpdateFeatureStatusChanged --- " + loadStatus);
                if (updateFeatureStatus === Enums.TaskStatusCompleted) {
                    console.log(">>>> ReportedCaseFormPage :  successfully updated feature");
                    applyEdits();
                }
            }

        }
    }

    AlertPopup {
        id: caseFormMissingData
        alertText: ("New worker note is \nrequired to continue.") ;
    }



    //Footer custom QML =================================================================
    footer: FooterSection {
        id: formPageFooter
        logMessage: "In ReportedCaseForm Page - Footer..."
        rightButtonText: "SAVE"
        overrideRightIconSrc: "../images/save.png"
        footerActionString: "CaseEditSave"
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
        reportedCaseObjectId = reportFeature.attributes.attributeValue("OBJECTID");
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

    //Function to only save edits to record, no other action

    function updateFeatureSave() {
        const feature = app.reportedCaseFeature
        console.log("\n\n\n>>>> ReportedCaseFormPage: updateFeatureSave()", feature, "  actionType: save")
        updateFeature(app.reportedCaseFeature, 'Save', reportedCaseCurrentStatus)
    }

    //Function to update record
    function updateFeature(feature, actionType, currentStatusVal) {

        console.log("\n\n\n>>>> ReportedCaseFormPage: updateFeature()", feature, "  actionType:", actionType)
        app.lastStatusCaseList = app.lastStatusCaseListFull
        app.lastStatusCaseListFull = ''

        var workerNoteSubStr = localWorkerNote
        if (actionType === 'AssignToMe') {
            feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
            feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
            feature.attributes.replaceAttribute("AssignedDate", new Date());
        } else if (actionType === 'TakeOver') {
            //No changes to the status
            feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
            feature.attributes.replaceAttribute("AssignedDate", new Date());
        } else if (actionType === 'Revert') {
            if (currentStatusVal === 'Assigned') {
                feature.attributes.replaceAttribute("CurrentStatus", "Pending");
                feature.attributes.replaceAttribute("AssignedUser", null);
                feature.attributes.replaceAttribute("AssignedDate", null);
            } else if (currentStatusVal === 'Cancelled') {
                feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
                feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
                feature.attributes.replaceAttribute("AssignedDate", new Date());
                feature.attributes.replaceAttribute("CancelledUser", null);
                feature.attributes.replaceAttribute("CancelledDate", null);
            } else if (currentStatusVal === 'Completed') {
                feature.attributes.replaceAttribute("CurrentStatus", "Assigned");
                feature.attributes.replaceAttribute("AssignedUser", app.portalUser);
                feature.attributes.replaceAttribute("AssignedDate", new Date());
                feature.attributes.replaceAttribute("CompletedUser", null);
                feature.attributes.replaceAttribute("CompletedDate", null);
            }
        } else if (actionType === 'Complete') {
            feature.attributes.replaceAttribute("CurrentStatus", "Completed");
            feature.attributes.replaceAttribute("CompletedUser", app.portalUser);
            feature.attributes.replaceAttribute("CompletedDate", new Date());
        } else if (actionType === 'Cancel') {
            feature.attributes.replaceAttribute("CurrentStatus", "Cancelled");
            feature.attributes.replaceAttribute("CancelledUser", app.portalUser);
            feature.attributes.replaceAttribute("CancelledDate", new Date());
        }

        var workerNote = workerNoteSubStr + ' ' + reportedCaseWorkerNote;
        workerNote = workerNote.substr(0,250);
        feature.attributes.replaceAttribute("WorkerNote", workerNote );

        feature.attributes.replaceAttribute("Type", typeComboBox.displayText );

        //Update these values regardless of type of edit
        feature.attributes.replaceAttribute("LastUpdateUser", app.portalUser);
        feature.attributes.replaceAttribute("LastUpdate", new Date());

        // update the feature in the feature table asynchronously
        console.log(">>>> ReportedCaseFormPage: updateFeature() - performing update");

        querying = true;
        caseEditFeatureTable.updateFeature(feature);

        //Hide actions
        cancelitem.visible = false
        completeitem.visible = false
        revertitem.visible = false
        assigntome.visible = false
        attachmentview.visible = false
        takeovercase.visible = false


    }





}

