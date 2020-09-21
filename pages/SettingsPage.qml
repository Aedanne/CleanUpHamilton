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
import "../images"
import "../assets"


/*
Settings page for Clean-Up Hamilton app
*/

Page {

    id:formPage;

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;


    //Header custom QML =================================================================
    header: HeaderSection {
        id: formPageHeader
        logMessage: ">>>>  Header: SETTINGS PAGE INFO PAGE";

    }




    //Main body of the page =============================================================

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



            //Location placeholder
            RowLayout{

                spacing: 0;
                visible: true;

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Application Primary Color: "
                    color: app.defaultPrimaryColor
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

            }
            //Location placeholder
            RowLayout{

                spacing: 0;
                visible: true;

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: app.defaultPrimaryColorText
                    color: app.defaultPrimaryColor
                    topPadding: 5 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
            }

            Rectangle {
                Layout.preferredWidth: 150*app.scaleFactor
                Layout.preferredHeight: 75*app.scaleFactor
                color: app.defaultPrimaryColor
            }

            RowLayout{

                spacing: 0;
                visible: true;

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: "Override Primary Color: "
                    color: app.primaryColor;
                    topPadding: 50 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

            }
            RowLayout{

                spacing: 0;
                visible: true;


                TextField {
                    font.pixelSize: app.baseFontSize*.4
                    text: app.overridePrimaryColor
                    color: app.overridePrimaryColor !== '' ? app.overridePrimaryColor : app.primaryColor
                    topPadding: 5 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor

                    onTextChanged: {
                        app.overridePrimaryColor = text
                        app.localOverrideColor = text
                    }

                }
            }

            Rectangle {
                Layout.preferredWidth: 150*app.scaleFactor
                Layout.preferredHeight: 75*app.scaleFactor
                color: app.overridePrimaryColor !== '' ? app.overridePrimaryColor : "transparent"
            }


            //padding
            RowLayout{

                spacing: 0;
                visible: true;

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: ""
                    color: app.defaultPrimaryColor
                    topPadding: 75 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: ""
                    color: "transparent"
                    topPadding: 75 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
            }
        }
    }

    SettingsHelp {
        id: help
    }

    //Footer custom QML =================================================================
    footer: FooterSection {
        id: formPageFooter
        logMessage: "In Form Page - Footer..."
        rightButtonText: "SAVE"
        overrideRightIconSrc: "../images/save.png"
    }



}
