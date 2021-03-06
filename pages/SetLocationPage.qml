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

import Esri.ArcGISRuntime 100.2


import '../ui_controls'
import '../images'
import '../assets'

/*
Main mapping page for Clean-Up Hamilton app
*/


Page {

    id:formPage

    signal nextPage()
    signal previousPage()

    property string titleText:''
    property var descText


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: '>>>> Header:  SET LOCATION INFO PAGE'
    }


    //Main body of the page =============================================================
    //Map and MapView QML Types

    contentItem: Rectangle {

        ColumnLayout {

            anchors.fill: parent

            MapView {
                id:mapView

                Layout.preferredWidth: parent.width
                Layout.fillHeight: parent.height*0.7
                Layout.maximumWidth: 600 * app.scaleFactor
                Layout.alignment: Qt.AlignHCenter

                property real initialMapRotation: 0

                rotationByPinchingEnabled: true
                zoomByPinchingEnabled: true

                locationDisplay {
                    positionSource: PositionSource {}
                    compass: Compass {}
                }


                // Set starting map to Clean-Up Hamilton webmap
                Map{
                    id:map
                    initUrl: app.webMapRootUrl + app.webMapId

                    maxScale: 2
                    minScale: 1

                    // start the location display when map is loaded
                    onLoadStatusChanged: {
                        panToLocation()
                    }
                }

                //Default point - Hamilton coords, WGS84 projection
                Point {
                    id: pointInit
                    y: -37.7833
                    x: 175.2833
                    spatialReference: SpatialReference { wkid: 4326 }
                }

                Image {
                    id: centerPin
                    source: '../images/pin.png'
                    width: 40 * app.scaleFactor
                    height: 40 * app.scaleFactor
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.verticalCenter
                    }
                    visible: true
                }

                //Map control buttons
                Column {
                    id:mapButtons
                    spacing: 5 * app.scaleFactor
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        margins: 5 * scaleFactor
                    }

                    Button {
                        id:myLocButton
                        Image {
                            id: mylocImage
                            source:'../images/my_loc.png'
                            height: 30 * scaleFactor
                            width: height
                            anchors.centerIn: parent
                        }

                        ColorOverlay {
                            anchors.fill: mylocImage
                            source: mylocImage
                            color: app.mapBorderColor
                        }

                        onHoveredChanged: hovered ? myLocButton.opacity = 1 : myLocButton.opacity = .5
                        height: 45 * scaleFactor
                        width : height
                        opacity: .5

                        onClicked: {
                            if (!mapView.locationDisplay.started) {
                                panToLocation()
                            } else {
                                mapView.locationDisplay.stop()
                            }
                        }
                    }
                }

                onMouseClicked: {
                    if (mapView.map.loadStatus === Enums.LoadStatusLoaded) {
                        panToLocation()
                    }
                }

                onCurrentViewpointCenterChanged: {
                    getLonLatValue()
                }
            }

            Rectangle {
                id: locationLonLatRect
                color: app.appBackgroundColor
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 30 * app.scaleFactor

                RowLayout {
                    spacing: 0
                    anchors.centerIn: parent


                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: 'My Location: '
                        color: app.appPrimaryTextColor
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }

                    Label {
                        font.pixelSize: app.baseFontSize*.5
                        text: app.currentLonLat
                        color: app.appSecondaryTextColor
                        topPadding: 5 * app.scaleFactor
                        bottomPadding: 5 * app.scaleFactor
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                    }
                }
            }
        }
    }

    SetLocationHelp {
        id: help
    }

    //Footer custom QML =================================================================
    footer: FooterSection {
        logMessage: 'In Set Location Page - Footer...'
    }

    //Location page functions ===========================================================

    //Pan to current location
    function panToLocation() {
        mapView.locationDisplay.start()
        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter

        //Log current mapview center point
        console.log('>>>> mapView.currentViewpointCenter>>>>', mapView.currentViewpointCenter.center)
        var currLonLat = getLonLatValue()
        console.log('>>>> Long and Lat: ', currLonLat)

        app.currentLocationPoint = mapView.currentViewpointCenter.center
        app.currentLonLat = currLonLat
    }

    function getLonLatValue() {
        var centerLocation = (mapView.currentViewpointCenter &&
                              mapView.currentViewpointCenter.center &&
                              mapView.map.loadStatus === Enums.LoadStatusLoaded) ?
                                    CoordinateFormatter.toLatitudeLongitude(mapView.currentViewpointCenter.center, Enums.LatitudeLongitudeFormatDecimalDegrees, 3)
                                    : ''

        app.currentLocationPoint = mapView.currentViewpointCenter.center
        app.currentLonLat = centerLocation
        console.log('>>>> Long and Lat: ', app.currentLonLat)

        return centerLocation
    }
}
