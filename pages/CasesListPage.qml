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
    property string currentStatus;
    property string currentText: "Pending"
    property int statusIndex: 0

    anchors.fill: parent;


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: CASES List PAGE";
    }


    //Main body of the page =============================================================
    //Map and MapView QML Types

    Label {
        id: topRow
        font.pixelSize: app.baseFontSize*.3
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
            displayText: currentText
//            width: parent.width * 0.6

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

                queryFeaturesByStatusAndExtent();
                currentStatus = statusIndexList.get(currentIndex).text;

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


    contentItem: Rectangle{

        anchors.top: statusComboBox.bottom
//        anchors.topMargin: 30 * app.scaleFactor


        ColumnLayout {

            anchors.fill: parent
            anchors.topMargin: 50 * app.scaleFactor

            ListView {
                id: listView

                width: Math.min(parent.width, 600 * scaleFactor)
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
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
                            Layout.preferredHeight: 72 * scaleFactor

                            clip: true

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 16 * scaleFactor
                                }

                                Rectangle {
                                    Layout.preferredWidth: 32 * scaleFactor
                                    Layout.preferredHeight: 32 * scaleFactor
                                    radius: 16 * scaleFactor
                                    Layout.alignment: Qt.AlignVCenter

                                    clip: true

                                    color: "#EFEFEF"


                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 24 * scaleFactor
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: contentLayout.height
                                    Layout.alignment: Qt.AlignVCenter

                                    ColumnLayout {
                                        id: contentLayout
                                        width: parent.width
                                        spacing: 6 * scaleFactor

                                        Label {
                                            Layout.fillWidth: true
                                            text: "OBJECTID: " + objectId
                                            color: app.appSecondaryTextColor
                                            font.pixelSize: app.baseFontSize*.3
                                            maximumLineCount: 1
                                            clip: true
                                            elide: Text.ElideRight
                                        }

                                        Label {
                                            Layout.fillWidth: true
                                            text: "TYPE: " + type + "  ---  DESCRIPTION: " + description
                                            color: app.appSecondaryTextColor
                                            font.pixelSize: app.baseFontSize*.3
                                            clip: true
                                        }
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 16 * app.scaleFactor
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: app.appBackgroundColor
                                anchors.bottom: parent.bottom
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if(listView.currentIndex === index) listView.currentIndex = -1
                                    else listView.currentIndex = index;
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
                        var objectId = caseFeature.attributes.attributeValue("OBJECTID");
                        var type = caseFeature.attributes.attributeValue("Type");
                        var description = caseFeature.attributes.attributeValue("Description");
                        var currentStatus = caseFeature.attributes.attributeValue("CurrentStatus");
                        var assignedUser = caseFeature.attributes.attributeValue("AssignedUser");
                        var assignedDate = caseFeature.attributes.attributeValue("AssignedDate");


                        console.log(">>>> QUERY: caseFeature --- values: ");
                        console.log(">>>> objectId: ", objectId);
                        console.log(">>>> type: ", type);
                        console.log(">>>> description: ", description);
                        console.log(">>>> currentStatus: ", currentStatus);
                        console.log(">>>> assignedUser: ", assignedUser);
                        console.log(">>>> assignedDate: ", assignedDate);

                        casesListModel.append({objectId: objectId,
                                               description:description,
                                               type: type,
                                               currentStatus: currentStatus,
                                               assignedUser: assignedUser,
                                               assignedDate: assignedDate
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
        console.log(">>>> CasesListPage: Inside queryFeaturesByStatusAndExtent() ----- ")
        casesListModel.clear();

        // set the where clause
        if (currentStatus === '') currentStatus = 'Pending'
        params.whereClause = " 1=1 and (CurrentStatus = '" + currentStatus + "') ";
        console.log(">>>> CasesListPage: Inside queryFeaturesByStatusAndExtent() params.whereClause ----- ", params.whereClause)

        //Find the current map extent
        params.geometry = app.reportedCasesMapView.visibleArea

        // start the query
        casesListFeatureTable.queryFeaturesWithFieldOptions(params, Enums.QueryFeatureFieldsLoadAll);

    }

}
