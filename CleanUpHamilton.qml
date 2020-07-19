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
    property int menuCurrentIndex: 0

    // App color properties
    readonly property color primaryColor:"#255D83"
    readonly property color accentColor: Qt.lighter(primaryColor,1.2)
    readonly property color appBackgroundColor: lightTheme? "#FAFAFA":"#303030"
    readonly property color appDialogColor: lightTheme? "#FFFFFF":"424242"
    readonly property color appPrimaryTextColor: lightTheme? "#000000":"#FFFFFF"
    readonly property color appSecondaryTextColor: Qt.darker(appPrimaryTextColor)
    readonly property color homePageTitleTextColor:"#FCFCFC"
    readonly property color listViewDividerColor:"#19000000"


    // App size properties
    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: (app.width < 450*app.scaleFactor) ? (35 * scaleFactor) : (40 * scaleFactor)
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize
    readonly property real captionFontSize: 0.6 * app.baseFontSize

    // HomePage is default page
    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: homePage
    }

    //TODO: Need to adjust text position
    Component{
        id: homePage

        HomePage {
            width: parent.width
            opacity: 1
            descText1: qsTr("Clean-Up")
            descText2: qsTr("Hamilton City")
            onOpenMenu: {
                drawer.open();
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


    Drawer {
        id: drawer
        //width: Math.min(parent.width, parent.height, 600*app.scaleFactor) * 0.80
        width: parent.width * 0.70
        height: parent.height
        Material.elevation: 40
        Material.background: app.appDialogColor

        edge: Qt.LeftEdge
        dragMargin: 0
        contentItem: SideMenuPage {
            currentIndex: menuCurrentIndex
            menuModel: drawerModel
            onMenuSelected: {
                drawer.close();
                switch(action){
                case "page1":
                    loader.sourceComponent = page1ViewPage;
                    break;
                case "page2":
                    loader.sourceComponent = page2ViewPage;
                    break;
                case "about":
                    loader.sourceComponent = aboutViewPage;
                    break;
                default:
                    break;
                }
            }
        }

    }

    ListModel{
        id: drawerModel
        ListElement {action:"page1"; type: "delegate"; name: qsTr("Page 1"); iconSource: ""}
        ListElement {action:"page2"; type: "delegate"; name: qsTr("Page 2"); iconSource: ""}
        ListElement {action:""; type: "divider"; name: ""; iconSource: ""}
        ListElement {action:"about"; type: "delegate"; name: qsTr("About"); iconSource: ""}

    }

//    Component{
//        id: page2ViewPage
//        BasePage{
//            titleText:qsTr("Page 2")
//            descText: qsTr("This is page 2")
//            onOpenMenu: {
//                drawer.open();
//            }
//        }
//    }

//    Component{
//        id: aboutViewPage
//        BasePage{
//            titleText: qsTr("About")
//            descText: qsTr("This is an about page")
//            onOpenMenu: {
//                drawer.open();
//            }
//        }
//    }
}






