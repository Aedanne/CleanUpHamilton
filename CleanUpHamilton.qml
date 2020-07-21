//Clean-Up Hamilton Student Project
//Using ESRI ArcGIS frameworks and libraries

import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.7

import "controls"
import "pages"
import "images"

App{
    id: app
    width: 420
    height: 640

    property bool lightTheme: true

    // App-level color properties===============================================================
    readonly property color primaryColor: "#CF5300"//"#DA674A" //"#255D83"
    readonly property color accentColor: Qt.lighter(primaryColor,1.2)
    readonly property color appBackgroundColor: lightTheme? "#FAFAFA":"#303030"
    readonly property color appDialogColor: lightTheme? "#FFFFFF":"424242"
    readonly property color menuBackgroundColor: "#DA674A"
    readonly property color appPrimaryTextColor: lightTheme? "#000000":"#FFFFFF"
    readonly property color menuPrimaryTextColor: Qt.lighter("#FFFFFF",1.5)
    readonly property color appSecondaryTextColor: Qt.darker(appPrimaryTextColor)
    readonly property color homePageTitleTextColor:"#FCFCFC"
    //readonly property color listViewDividerColor:"#19000000"

    // App-level size properties================================================================
    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: (app.width < 450*app.scaleFactor) ? (35 * scaleFactor) : (40 * scaleFactor)
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize
    readonly property real captionFontSize: 0.6 * app.baseFontSize




    // HomePage is default page==========================================================
    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: homePageComponent
        width: parent.width*0.7
    }



    // Main body, title==================================================================
    Component{
        id: homePageComponent
        HomePage {
            width: parent.width
            opacity: 1
            descText1: qsTr("Clean-Up")
            descText2: qsTr("Hamilton")
            onOpenMenu: {
                sideMenuDrawer.open();
            }
        }
    }


//    Rectangle{
//        id: mask
//        anchors.fill: parent
//        color: "black"
//        opacity: drawer.position*0.54
//        Material.theme: app.lightTheme ? Material.Light : Material.Dark
//    }




    // QML type for side menu============================================================
    Drawer {
        id: sideMenuDrawer
        width: parent.width * 0.70
        height: parent.height

        Material.elevation: 40
        Material.background: app.appDialogColor

        edge: Qt.LeftEdge
        dragMargin: 0
        contentItem: SideMenuPage {
            //currentIndex: currIndex
            menuModel: sideMenuDrawerModel
            onMenuSelected: {
                sideMenuDrawer.close();
                switch(action){
                case "settings":
                    loader.sourceComponent = settingsPageComponent;
                    break;
                case "about":
                    loader.sourceComponent = aboutPageComponent;
                    break;
                default:
                    break;
                }
            }
        }
    }

    // Side menu options to send to drawer model=========================================
    ListModel{
        id: sideMenuDrawerModel

        ListElement {
            action:"about";
            type: "delegate";
            name: qsTr("About");
            iconSource: "../images/info.png"
        }
        ListElement {
            action:"settings";
            type: "delegate";
            name: qsTr("Settings");
            iconSource: "../images/gear.png"
        }

    }


    //About component when menu option selected
    Component{
        id: aboutPageComponent
        AboutPage{
            titleText:qsTr("")
            descText: qsTr("TODO: ABOUT")
            onOpenMenu: {
                sideMenuDrawer.open();
            }
        }
    }

    //Settings component when menu option selected
    Component{
        id: settingsPageComponent
        SettingsPage{
            titleText:qsTr("")
            descText: qsTr("TODO: Settings")
            onOpenMenu: {
                sideMenuDrawer.open();
            }
        }
    }


}






