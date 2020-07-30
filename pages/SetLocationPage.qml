import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
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


import "../ui_controls"

/*
Main mapping page for Clean-Up Hamilton app
*/


Page {

    id:formPage;
    anchors.fill: parent;

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: SET LOCATION INFO PAGE";
    }


    //Main body of the page =============================================================
    //Map and MapView QML Types

    contentItem: Rectangle{
        anchors.top:header.bottom;

        MapView {
            id:mapView;

            property real initialMapRotation: 0;
            anchors.fill:parent;

            anchors {
                left: parent.left;
                right: parent.right;
                top: titleRect.bottom;
                bottom: parent.bottom;
            }

            rotationByPinchingEnabled: true;
            zoomByPinchingEnabled: true;

            locationDisplay {
                positionSource: PositionSource {}
                compass: Compass {}
            }

            // Set starting map to Clean-Up Hamilton webmap
            Map{
                id:map;
                initUrl: app.webMapRootUrl + app.webMapId;

                // start the location display when map is loaded
                onLoadStatusChanged: {
                    panToLocation();
                }
            }

//            //Add Cases layer
//            GraphicsOverlay {
//                id: casesOverlay;
//            }

//            //Default point - Hamilton coords, WGS84 projection
//            Point {
//                id: pointInit;
//                y: -37.7833;
//                x: 175.2833;
//                spatialReference: SpatialReference { wkid: 4326 };
//            }

//            SimpleMarkerSymbol {
//                id: pointSymbol;
//                style: Enums.SimpleMarkerSymbolStyleDiamond;
//                color: "orange";
//                size: 10;
//            }

//            Graphic {
//                id: pointGraphic;
//                symbol: pointSymbol;
//                geometry: pointInit;
//            }

            Image {
                id: centerPin;
                source: "../images/pin.png";
                width: 40 * app.scaleFactor;
                height: 40 * app.scaleFactor;
                anchors {
                    horizontalCenter: parent.horizontalCenter;
                    bottom: parent.verticalCenter;
                }
                visible: true;
            }

            //Add default point to layer
//            Component.onCompleted: {
//                casesOverlay.graphics.append(pointGraphic);
//            }

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
        }
    }



    //Footer custom QML =================================================================
    footer: FooterSection {
        logMessage: "In Set Location Page - Footer..."
    }

    //Pan to current location
    function panToLocation() {
        mapView.locationDisplay.start();
        mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
    }

}
