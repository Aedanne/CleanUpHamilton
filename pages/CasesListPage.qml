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
Staff Workflow Cases List Page
*/


Page {

    id:casesListPage;

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;

    property ArcGISFeature caseFeature;
    property string debugText;
    property bool querying;
    property string currentStatusValue;
    property int statusIndex: 0
    property int imgSizeTop: 55 * app.scaleFactor
    property int imgSizeBottom: 35 * app.scaleFactor

    property string imgRubbish: "../images/type_rubbish.png"
    property string typeRubbish: 'Illegal rubbish dumping'

    property string imgOther: "../images/type_other.png"
    property string typeOther: 'Other'

    property string imgGraffiti: "../images/type_graffiti.png"
    property string typeGraffiti: 'Graffiti'

    property string imgBroken: "../images/type_broken.png"
    property string typeBroken: 'Broken items'

    property string imgAssignedGreen: "../images/assigned_green.png"
    property string imgAssignedGray: "../images/assigned_gray.png"
    property string imgAssignedYellow: "../images/assigned_yellow.png"

    property string imgAssignToMe: "../images/assigntome.png"
    property string imgCancel: "../images/cancel.png"
    property string imgComplete: "../images/complete.png"
    property string imgEdit: "../images/edit_black.png"
    property string imgRevert: "../images/revert.png"
    property string imgAttachment: "../images/paperclip.png"



    anchors.fill: parent;


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: CASES List PAGE";
    }


    //Main body of the page =============================================================

    Label {
        id: topRow
        font.pixelSize: app.baseFontSize*.1
        font.bold: true
        text: " "
        color: app.appPrimaryTextColor;
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignBottom
    }

    RowLayout{

        spacing: 0;
        visible: true;
        anchors.top: topRow.bottom
        anchors.bottomMargin: 20*app.scaleFactor
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.fill: parent


//        Label {
//                font.pixelSize: app.baseFontSize*.5
//                font.bold: true
//                text: "Case Status:  "
//                color: app.appPrimaryTextColor;
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignBottom


//            }

        ComboBox {
                id: statusComboBox
                currentIndex: statusIndex
                font.bold: true
                font.pixelSize: app.baseFontSize*.5
                displayText: currentStatusValue
                implicitWidth: app.width


                Layout.fillWidth: true


                delegate: ItemDelegate {
                    Layout.fillWidth: true
                    width: parent.width
                    contentItem: Text {
                        text: modelData
                        width: app.width
                        color: app.appPrimaryTextColor
                        font: statusComboBox.font
                        verticalAlignment: Text.AlignVCenter

                    }
                    highlighted: statusComboBox.highlightedIndex === index

                }

                model: ListModel {
                    id: statusIndexList
                    ListElement { text: "Case Status: Pending"; }
                    ListElement { text: "Case Status: Assigned";  }
                    ListElement { text: "Case Status: Completed";  }
                    ListElement { text: "Case Status: Cancelled";  }
                    ListElement { text: "Case Status: Assigned [USER]";  }
                    ListElement { text: "Case Status: Completed [USER]";  }
                    ListElement { text: "Case Status: Cancelled [USER]";  }

                }

                onCurrentIndexChanged: {
                    statusIndex = currentIndex
                    debugText = ">>>> onCurrentIndexChanged: Status Combo Box selected: " + statusIndexList.get(currentIndex).text;
                    console.log(debugText);

                    currentStatusValue = statusIndexList.get(currentIndex).text;
                    queryFeaturesByStatusAndExtent();

                }

                contentItem: Text {
                        Layout.fillWidth: true
                        width: parent.width
                        leftPadding: 10 * app.scaleFactor
                        rightPadding: statusComboBox.indicator.width + statusComboBox.spacing

                        text: statusComboBox.displayText
                        font: statusComboBox.font
                        color: app.appPrimaryTextColor
                        verticalAlignment: Text.AlignVCenter


                }
            }



    }

    Label {
        id: bottomRow
        font.pixelSize: app.baseFontSize*.2
        font.bold: true
        text: " "
        color: app.appPrimaryTextColor;
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignBottom
    }

    contentItem: Rectangle{

        ColumnLayout {

            anchors.fill: parent
            anchors.topMargin: 50 * app.scaleFactor

            //Separator
//            Rectangle {
//                Layout.fillWidth: true
//                Layout.preferredHeight: 10 * app.scaleFactor
//                border.color: "transparent"
//                color: app.appBackgroundColorDarkGray
//            }

            ListView {
                id: listView

                width: Math.min(parent.width, 600 * scaleFactor)
                height: parent.height
//                anchors.horizontalCenter: parent.horizontalCenter
                clip: true

                currentIndex: -1

                spacing: 0

                model: casesListModel

                delegate: Item {
                    width: parent.width
                    height: isVisible ? delegateLayout.height : 0

                    property bool isOpenButtons: false
                    property bool isVisible: true

                    Behavior on height {
                        NumberAnimation { duration: 200 }
                    }

                    clip: true

                    ColumnLayout {
                        id: delegateLayout
                        width: parent.width
                        spacing: 0

                        //Separator
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
//                            border.color: app.appBackgroundColorDarkGray
                            color: app.appBorderColorCaseList
                        }

                        // delegate content - top section of each list item
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 72 * app.scaleFactor
//                            border.width: 1



                            clip: true

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                //Report type - rubbish, graffiti, other, broken items
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 72 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList


                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeTop
                                        height: imgSizeTop
                                        source: (type===typeRubbish?imgRubbish:(type===typeGraffiti?imgGraffiti:(type===typeBroken?imgBroken:imgOther)))
                                        visible: true;
                                        enabled: true;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: 1")
                                        }
                                    }

                                }

                                // Assignment status
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 72 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeTop
                                        height: imgSizeTop
                                        source: (assignedUser===''?imgAssignedGray:(assignedUser===app.portalUser?imgAssignedGreen:imgAssignedYellow))
                                        visible: true;
                                        enabled: true;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: 2")
                                        }
                                    }

                                }

                                // Attachment view icon
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 72 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeTop
                                        height: imgSizeTop
                                        source: imgAttachment
                                        visible: true;
                                        enabled: true;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: 3")
                                        }
                                    }

                                }
                            }
                        }

                        //Separator
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
//                            border.color: app.appBackgroundColorDarkGray
                            color: "transparent"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 25 * app.scaleFactor
                            border.color: app.appBackgroundColorCaseList
                            color: app.appBackgroundColorCaseList
//                            Layout.alignment: Qt.AlignVCenter

                            Label {
                                Layout.fillWidth: true
                                text: "   [#"+objectId+"] Description: " + description
                                color: app.appSecondaryTextColor
                                font.pixelSize: app.baseFontSize*.4
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                topPadding: 2 * app.scaleFactor
                                maximumLineCount: 1
//                                clip: true
                                visible: true
                            }
                        }

                        //Separator
//                        Rectangle {
//                            Layout.fillWidth: true
//                            implicitHeight: 1
////                            border.color: app.appBackgroundColorDarkGray
//                            color: app.appBorderColorCaseList
//                        }


                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50 * app.scaleFactor

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                //Padding
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: currentStatus === 'Pending' ? true : false;

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
                                        visible: currentStatus === 'Pending' ? true : false;
                                        enabled: currentStatus === 'Pending' ? true : false;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                }

                                //Assign to me
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: currentStatus === 'Pending' ? true : false;

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
                                        source: imgAssignToMe
                                        visible: currentStatus === 'Pending' ? true : false;
                                        enabled: currentStatus === 'Pending' ? true : false;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: Bottom 1")
                                        }
                                    }

                                }


                                //Edit
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: true

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
                                        source: imgEdit
                                        visible: true;
                                        enabled: true;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: Bottom 2")
                                        }
                                    }

                                }

                                //Cancel item
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: currentStatus === 'Assigned' ? true : false;

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
                                        source: imgCancel
                                        visible: currentStatus === 'Assigned' ? true : false;
                                        enabled: currentStatus === 'Assigned' ? true : false;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: Bottom 3")
                                        }
                                    }

                                }

                                //Revert status of item
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: currentStatus !== 'Pending' ? true : false;

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
                                        source: imgRevert
                                        visible: currentStatus !== 'Pending' ? true : false;
                                        enabled: currentStatus !== 'Pending' ? true : false;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: Bottom 4")
                                        }
                                    }

                                }

                                //Complete case
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: currentStatus === 'Assigned' ? true : false;

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
                                        source: imgComplete
                                        visible: currentStatus === 'Assigned' ? true : false;
                                        enabled: currentStatus === 'Assigned' ? true : false;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: Bottom 5")
                                        }
                                    }

                                }

                                //Padding
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50 * app.scaleFactor
                                    color: app.appBackgroundColorCaseList
                                    visible: currentStatus === 'Pending' ? true : false;

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSizeBottom
                                        height: imgSizeBottom
//                                        source: imgAssignToMe
                                        visible: currentStatus === 'Pending' ? true : false;
                                        enabled: currentStatus === 'Pending' ? true : false;
                                        fillMode: Image.PreserveAspectCrop
                                    }

                                }

                            }
                        }

                        //Separator
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
//                            border.color: app.appBackgroundColorDarkGray
                            color: app.appBorderColorCaseList
                        }

                        //Separator
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20 * app.scaleFactor
//                            border.color: "transparent"
                            color: "transparent"
                        }

                    }
                }
            }
        }
    }


    ListModel{
        id: casesListModel
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


    QueryParameters {
        id: params
    }


    FeatureLayer {

        ServiceFeatureTable {
            id: casesListFeatureTable
            url: app.featureServerURL

            onLoadStatusChanged: {
                debugText = ">>>> CasesListPage: onLoadStatusChanged --- " + loadStatus;
                console.log(debugText);
                queryFeaturesByStatusAndExtent()
            }

            onQueryFeaturesStatusChanged: {

                if (queryFeaturesStatus === Enums.TaskStatusCompleted) {
                    querying = false

                    console.log(">>>> Cases List: Query: ", queryFeaturesResult)

                    //Update the display counts
                    if (queryFeaturesResult.iterator != null) {
                        while (queryFeaturesResult.iterator.hasNext) {
                            caseFeature = queryFeaturesResult.iterator.next();

                            console.log(" caseFeature.attributes. ", caseFeature.attributes.attributeNames)
                            var objectIdF = caseFeature.attributes.attributeValue("OBJECTID");
                            var typeF = caseFeature.attributes.attributeValue("Type");
                            var tempDesc = caseFeature.attributes.attributeValue("Description");
                            var descriptionF = tempDesc === null ? '' : (tempDesc.length > 35 ? (tempDesc.substr(0,35)+'...') : tempDesc);
                            var currentStatusF = caseFeature.attributes.attributeValue("CurrentStatus");
                            var tempUser = caseFeature.attributes.attributeValue("AssignedUser");
                            var assignedUserF = tempUser === null ? '': tempUser;
                            var assignedDateF = caseFeature.attributes.attributeValue("AssignedDate");


                            console.log(">>>> QUERY: caseFeature --- values: ");
                            console.log(">>>> objectId: ", objectIdF);
                            console.log(">>>> type: ", typeF);
                            console.log(">>>> description: ", descriptionF);
                            console.log(">>>> currentStatus: ", currentStatusF);
                            console.log(">>>> assignedUser: ", assignedUserF);
                            console.log(">>>> assignedDate: ", assignedDateF);

                            casesListModel.append({objectId: objectIdF,
                                                   description:descriptionF,
                                                   type: typeF,
                                                   currentStatus: currentStatusF,
                                                   assignedUser: assignedUserF,
                                                   assignedDate: assignedDateF
                                                  })
                         }
                    }

                } else if (queryFeaturesStatus === Enums.TaskStatusInProgress) {
                    console.log(">>>> QUERY: caseFeature --- TASK IN PROGRESS: ");
                    querying = true;
                }
            }
        }
    }



    //Footer custom QML =================================================================
    footer: FooterSection {
        logMessage: "In Cases List Page - Footer..."
        rightButtonText: "HOME"
        overrideRightIconSrc: "../images/home.png";
//        overrideRightIconSz: 30
    }


    //Function to query the current extent
    function queryFeaturesByStatusAndExtent() {
        casesListModel.clear();

        // set the where clause
        if (currentStatusValue === '') currentStatusValue = 'Pending'
        var queryStatus = (currentStatusValue.includes('Pending') ? 'Pending' :
                             (currentStatusValue.includes('Assigned') ? 'Assigned' :
                             (currentStatusValue.includes('Cancelled') ? 'Cancelled' : 'Completed')));

        var queryUserStr = currentStatusValue.includes('USER') ? " and (CurrentUser = '" + app.portalUser + "')" : '';
        var queryString = " 1=1 and (CurrentStatus = '" + queryStatus + "') "

        params.whereClause = queryString + queryUserStr;
        console.log(">>>> CasesListPage: Inside queryFeaturesByStatusAndExtent() params.whereClause ----- ", params.whereClause)

        //Find the current map extent
        params.geometry = app.reportedCasesMapExtent//app.reportedCasesMapView.visibleArea

        // start the query
        casesListFeatureTable.queryFeaturesWithFieldOptions(params, Enums.QueryFeatureFieldsLoadAll);

    }

}
