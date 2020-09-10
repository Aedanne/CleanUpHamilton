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

    property ArcGISFeature reportFeature;
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
                id: statusIndex
                ListElement { text: "Pending"; }
                ListElement { text: "Assigned";  }
                ListElement { text: "Completed";  }
                ListElement { text: "Cancelled";  }
            }

            onCurrentIndexChanged: {
                debugText = ">>>> Status Combo Box selected: " + statusIndex.get(currentIndex).text;
                console.log(debugText);

//                        initFeatureService();
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

        ColumnLayout {

            anchors.fill: parent


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


    QueryParameters {
        id: params
    }


    FeatureLayer {

        ServiceFeatureTable {
            id: casesFeatureTable
            url: app.featureServerURL

            onLoadStatusChanged: {
                debugText = ">>>> onLoadStatusChanged --- " + loadStatus;
                console.log(debugText);
            }

            onQueryFeaturesStatusChanged: {

                if (queryFeaturesStatus === Enums.TaskStatusCompleted) {
                    assignedCount = 0
                    pendingCount = 0
                    querying = false

                    //Update the display counts
                    while (queryFeaturesResult.iterator.hasNext) {
                        reportFeature = queryFeaturesResult.iterator.next();

                        var status = reportFeature.attributes.attributeValue("CurrentStatus");
                        console.log(">>>> QUERY: reportFeature --- status: " + status);
                        if (status === 'Pending') {
                            pendingCount = pendingCount + 1
                        } else if (status === 'Assigned') {
                            assignedCount = assignedCount + 1
                        }

                     }

                } else if (queryFeaturesStatus === Enums.TaskStatusInProgress) {
                    console.log(">>>> QUERY: reportFeature --- TASK IN PROGRESS: ");
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

        // set the where clause
        params.whereClause = "1=1 and (CurrentStatus = " + currentStatus + ") ";
        //Find the current map extent
        params.geometry = app.reportedCasesMapView.visibleArea
        // start the query
        casesFeatureTable.queryFeatures(params);
    }

}
