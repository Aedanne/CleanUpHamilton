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
    readonly property color primaryColor: Qt.darker("#CF5300",0.9) //"#DA674A" //"#255D83"
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
    readonly property real headerFontSize: baseFontSize*0.60

    // Stackview properties
    property int steps: -1



    // Main body, title==================================================================
    Component{
        id: homePageComponent
        HomePage {
            width: parent.width
            opacity: 1
            descText1: qsTr("Clean-Up")
            descText2: qsTr("Hamilton")
            onOpenMenu: {
                console.log("In home page component > open menu");
                sideMenuDrawer.open();
            }
            //Navigating to the form page from home page
            onNextPage: {
//                switch(action) {
//                    case "fileareport":
                        formStackView.loadFormPage();
                    //more cases to add later
//                }
            }
        }
    }


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
                case "fileareport":
                    console.log("In menu drawer > fileareport");
                        formStackView.loadFormPage();
                    break;
                case "settings":
                    console.log("In menu drawer > settings");
                        formStackView.loadSettingsPage();
                    break;
                case "about":
                    console.log("In menu drawer > about");
                        formStackView.loadAboutPage();
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
            action:"fileareport";
            type: "delegate";
            name: qsTr("File a Report");
            iconSource: "../images/add_note.png"
        }
        ListElement {
            action:"divider";
            type: "";
            name: "divider";
            iconSource: ""
        }
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
            titleText:qsTr("About")
            descText: qsTr("TODO: \nABOUT")
            onOpenMenu: {
                sideMenuDrawer.open();
            }
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {

            }
        }
    }

    //Settings component when menu option selected
    Component{
        id: settingsPageComponent
        SettingsPage{
            titleText:qsTr("Settings")
            descText: qsTr("TODO: \nSettings")
            onOpenMenu: {
                sideMenuDrawer.open();
            }
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {

            }
        }
    }

    Component {
        id: formPageComponent

        FormPage {
            titleText:qsTr("New Report")
            descText: qsTr("TODO: \nFile a Report")
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadSetLocationPage();
            }
        }
    }

    Component {
        id: setLocationPageComponent

        SetLocationPage {
            titleText:qsTr("Set Location")
            descText: qsTr("TODO: \nSet Location")
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {

            }
        }
    }


    //Creating stackview for form pages =================================================
    StackView {
        id: formStackView
        anchors.fill: parent
        initialItem: homePageComponent

        function loadHomePage() {
            console.log("Inside StackView.loadHomePage()")
            while (formStackView.count > 0)
                formStackView.pop()

            push(formStackView.initialItem)

            //TODO: to clear any data from this point on
            steps = -1;
        }

        //Load form page
        function loadFormPage() {
            console.log("Inside StackView.loadFormPage()")
            push(formPageComponent);
        }

        //Load About Page
        function loadAboutPage() {
            console.log("Inside StackView.loadAboutPage()")
            push(aboutPageComponent);
        }

        //Load Settings Page
        function loadSettingsPage() {
            console.log("Inside StackView.loadSettingsPage()")
            push(settingsPageComponent);
        }

        //Load SetLocation Page
        function loadSetLocationPage() {
            console.log("Inside StackView.loadSetLocationPage()")
            push(setLocationPageComponent);
        }
    }





}






