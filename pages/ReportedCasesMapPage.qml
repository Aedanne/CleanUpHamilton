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
Staff Workflow Reported Cases Map Page
*/


Page {

    id:reportedCasesMapPage;

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;

    property int assignedCount;
    property int pendingCount;
    property ArcGISFeature reportFeature;
    property string debugText;
    property bool querying;

    anchors.fill: parent;


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: ">>>> Header: REPORTED CASES MAP PAGE";
    }


    //Main body of the page =============================================================
    //Map and MapView QML Types

    contentItem: Rectangle{

        ColumnLayout {

            anchors.fill: parent

            MapView {
                id:mapView;

                Layout.preferredWidth: parent.width
                Layout.fillHeight: parent.height*0.7
                Layout.maximumWidth: 600 * app.scaleFactor
                Layout.alignment: Qt.AlignHCenter

                property real initialMapRotation: 0;

                rotationByPinchingEnabled: true;
                zoomByPinchingEnabled: true;

                locationDisplay {
                    positionSource: PositionSource {}
                    compass: Compass {}
                }

                // Set starting map to Clean-Up Hamilton webmap
                Map{
                    id: map;
                    initUrl: app.webMapRootUrl + app.staffWebMapId;

                    initialViewpoint: viewPoint
                    maxScale: 2
                    minScale: 1

                    // start the location display when map is loaded
                    onLoadStatusChanged: {
                        panToLocation();
                    }


                }

                //Map control buttons
                Column{
                    id:mapButtons;
                    spacing: 5 * app.scaleFactor;
                    anchors {
                        verticalCenter: parent.verticalCenter;
                        right: parent.right;
                        margins: 5 * scaleFactor;
                    }

                    Button{
                        id:myLocButton;
                        Image{
                            id: mylocImage;
                            source:"../images/my_loc.png";
                            height: 30 * scaleFactor;
                            width: height;
                            anchors.centerIn: parent;
                        }

                        ColorOverlay{
                            anchors.fill: mylocImage;
                            source: mylocImage;
                            color: app.mapBorderColor;
                        }

                        onHoveredChanged: hovered ? myLocButton.opacity = 1 : myLocButton.opacity = .5;
                        height: 40 * scaleFactor;
                        width : height;
                        opacity: .5;

                        onClicked: {
                            if (!mapView.locationDisplay.started) {
                                panToLocation();
                            } else {
                                mapView.locationDisplay.stop();
                            }
                        }
                    }
                }

                onMouseClicked:{
                    if(mapView.map.loadStatus === Enums.LoadStatusLoaded){
                        panToLocation();                       
                    }
                }

                onDrawStatusChanged: {
                    app.reportedCasesMapView = mapView
                    if (map.loadStatus === Enums.LoadStatusLoaded) {
                        queryFeaturesInExtent();
                    }

                }


            }



            Rectangle {
                id: featureCountRect
                color: app.appBackgroundColor
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 30 * app.scaleFactor

                RowLayout {
                    spacing: 0
                    anchors.centerIn: parent


                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: "Pending: "
                        color: app.appPrimaryTextColor;
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }
                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: pendingCount;
                        color: app.appSecondaryTextColor
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }


                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: "    "
                        color: app.appPrimaryTextColor;
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }

                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: "Assigned: "
                        color: app.appPrimaryTextColor;
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }
                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: assignedCount;
                        color: app.appSecondaryTextColor
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }
                }
            }



        }
    }

    // initial viewPoint
//    ViewpointCenter {
//        id: viewPoint
//        center: Point {
//            y: -37.7833;
//            x: 175.2833;
//            spatialReference: SpatialReference { wkid: 3857 }
//        }
//    }

    ViewpointExtent {
        id: viewPoint
        extent: Envelope {
            xMin: 19506648.3632595
            yMin: -4550696.42243646
            xMax: 19517176.4848016
            yMax: -4548519.5856226
            spatialReference: SpatialReference { wkid: 102100 }
        }
    }

    FeatureLayer {
        id: reportedCasesFeatureLayer

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

                     map.retryLoad();

                } else if (queryFeaturesStatus === Enums.TaskStatusInProgress) {
                    console.log(">>>> QUERY: reportFeature --- TASK IN PROGRESS: ");
                    querying = true;
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


    QueryParameters {
        id: params
    }

    ReportedCasesMapHelp {
        id: help
    }


    //Footer custom QML =================================================================
    footer: FooterSection {
        logMessage: "In Reported Cases Page - Footer..."
    }

    //Pan to current location
    function panToLocation() {
        mapView.locationDisplay.start();
        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
    }

    //Function to query the current extent
    function queryFeaturesInExtent() {

        // set the where clause
        params.whereClause = "1=1 and (CurrentStatus = 'Assigned' or CurrentStatus = 'Pending') ";
        //Find the current map extent
        params.geometry = mapView.visibleArea
        // start the query

        casesFeatureTable.queryFeatures(params);

        map.load();
        app.reportedCasesMapExtent = mapView.visibleArea


    }

}
