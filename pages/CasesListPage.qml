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
    property int imgSize: 40 * app.scaleFactor

    property string imgRubbish: "../images/type_rubbish.png"
    property string typeRubbish: 'Illegal rubbish dumping'

    property string imgOther: "../images/type_other.png"
    property string typeOther: 'Other'

    property string imgGraffiti: "../images/type_graffiti.png"
    property string typeGraffiti: 'Graffiti'

    property string imgBroken: "../images/type_broken.png"
    property string typeBroken: 'Broken items'

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


        Label {
                font.pixelSize: app.baseFontSize*.5
                font.bold: true
                text: "Case Status:  "
                color: app.appPrimaryTextColor;
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom


            }

        ComboBox {
                id: statusComboBox
                currentIndex: statusIndex
                font.bold: true
                font.pixelSize: app.baseFontSize*.5
                displayText: currentStatusValue
                width: parent.width


                delegate: ItemDelegate {
                    width: parent.width
                    contentItem: Text {
                        text: modelData
                        color: app.appSecondaryTextColor
                        font: statusComboBox.font
                        verticalAlignment: Text.AlignVCenter

                    }
                    highlighted: statusComboBox.highlightedIndex === index

                }

                model: ListModel {
                    id: statusIndexList
                    ListElement { text: "Pending"; }
                    ListElement { text: "Assigned";  }
                    ListElement { text: "Completed";  }
                    ListElement { text: "Cancelled";  }

                }

                onCurrentIndexChanged: {
                    statusIndex = currentIndex
                    debugText = ">>>> onCurrentIndexChanged: Status Combo Box selected: " + statusIndexList.get(currentIndex).text;
                    console.log(debugText);

                    currentStatusValue = statusIndexList.get(currentIndex).text;
                    queryFeaturesByStatusAndExtent();

                }

                contentItem: Text {
                        leftPadding: 5 * app.scaleFactor
                        rightPadding: statusComboBox.indicator.width + statusComboBox.spacing

                        text: statusComboBox.displayText
                        font: statusComboBox.font
                        color: app.appSecondaryTextColor
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

                        // delegate content
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 72 * app.scaleFactor
                            border.color: app.accentColor
                            border.width: 1


                            clip: true

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 72 * app.scaleFactor
                                    border.color: app.accentColor
                                    border.width: 1

                                    Label {
                                        Layout.fillWidth: true
                                        text: "OBJECTID: " + objectId
                                        color: app.appSecondaryTextColor
                                        font.pixelSize: app.baseFontSize*.3
                                        maximumLineCount: 1
                                        clip: true
                                        elide: Text.ElideRight
                                    }

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSize
                                        height: imgSize
                                        source: (type===typeRubbish?imgRubbish:(type===typeGraffiti?imgGraffiti:(type===typeBroken?imgBroken:imgOther)))
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

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 72 * app.scaleFactor
                                    border.color: app.accentColor
                                    border.width: 1

                                    Label {
                                        Layout.fillWidth: true
                                        text: "TYPE: " + type + "  ---  DESCRIPTION: " + description
                                        color: app.appSecondaryTextColor
                                        font.pixelSize: app.baseFontSize*.3
                                        clip: true
                                    }

                                    Image{
                                        anchors.centerIn: parent
                                        width: imgSize
                                        height: imgSize
                                        source: "../images/assigntome.png";
                                        visible: true;
                                        enabled: true;
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log(">>> MOUSE AREA: 4")
                                        }
                                    }

                                }
                            }
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
                    while (queryFeaturesResult.iterator.hasNext) {
                        caseFeature = queryFeaturesResult.iterator.next();

                        console.log(" caseFeature.attributes. ", caseFeature.attributes.attributeNames)
                        var objectIdF = caseFeature.attributes.attributeValue("OBJECTID");
                        var typeF = caseFeature.attributes.attributeValue("Type");
                        var descriptionF = caseFeature.attributes.attributeValue("Description");
                        var currentStatusF = caseFeature.attributes.attributeValue("CurrentStatus");
                        var assignedUserF = caseFeature.attributes.attributeValue("AssignedUser");
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
        params.whereClause = " 1=1 and (CurrentStatus = '" + currentStatusValue + "') ";
        console.log(">>>> CasesListPage: Inside queryFeaturesByStatusAndExtent() params.whereClause ----- ", params.whereClause)

        //Find the current map extent
        params.geometry = app.reportedCasesMapExtent//app.reportedCasesMapView.visibleArea

        // start the query
        casesListFeatureTable.queryFeaturesWithFieldOptions(params, Enums.QueryFeatureFieldsLoadAll);

    }

}
