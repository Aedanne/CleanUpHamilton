/**
Clean-Up Hamilton Student Project
Using ESRI ArcGIS frameworks and libraries
Charisse Hanson
*/

import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0

import ArcGIS.AppFramework.Networking 1.0
import ArcGIS.AppFramework.Multimedia 1.0
import ArcGIS.AppFramework.Notifications 1.0
import ArcGIS.AppFramework.WebView 1.0
import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.5
import ArcGIS.AppFramework.Sql 1.0
import ArcGIS.AppFramework.Platform 1.0

import "ui_controls"
import "pages"
import "images"

App{
    id: app
    width: 460
    height: 750

    property bool lightTheme: true
    property string version: "1.0.5"

    // App-level color properties========================================================
    readonly property color primaryColor: "#30475e"//'#1f4068'//"#555555"//Qt.darker("#CF5300",0.9) //"#255D83"
    readonly property color accentColor: Qt.lighter(primaryColor,1.2)
    readonly property color appBackgroundColor: lightTheme? "#FAFAFA":"#303030"
    readonly property color appDialogColor: lightTheme? "#FFFFFF":"424242"
    readonly property color menuBackgroundColor: "#DA674A"
    readonly property color appPrimaryTextColor: lightTheme? '#555555':"#FFFFFF"
    readonly property color menuPrimaryTextColor: Qt.lighter("#FFFFFF",1.5)
    readonly property color appSecondaryTextColor: lightTheme? '#8A8A8A':"#FFFFFF"
    readonly property color homePageTitleTextColor:"#FCFCFC"
    readonly property color appPrimaryTextColorInverted: lightTheme? "#FFFFFF":'#555555'
    readonly property color backgroundAccent: '#AEAEAE'
    //readonly property color listViewDividerColor:"#19000000"
    readonly property color cameraViewBackgroundColor: "#1C1C1C"

    // App-level size properties=========================================================
    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: (app.width < 450*app.scaleFactor) ? (35 * scaleFactor) : (40 * scaleFactor)
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize
    readonly property real captionFontSize: 0.6 * app.baseFontSize
    readonly property real headerFontSize: baseFontSize*0.60
    readonly property real btnHdrFtrHeightSize: 50*app.scaleFactor

    //Map properties=====================================================================
    readonly property string webMapRootUrl: "https://waikato.maps.arcgis.com/home/item.html?id="
    readonly property string webMapId: "bedb6a09b8b54d9f866f49de216b87c7"  //Clean-Up Hamilton Default Map
    readonly property color mapBorderColor: "#303030"
    property Point currentLocationPoint
    property string currentLonLat
    readonly property string featureServerURL: "https://services1.arcgis.com/gjbU5qa8FJmAPFZX/arcgis/rest/services/Cases/FeatureServer/0"

    //Database properties================================================================
    property var attributesArray
    property var attributesArrayCopy
    property var savedReportLocationJson
    property var localDB

    //Report data properties=============================================================
    property string reportType
    property string reportDescription
    property date reportDate

    //Attachment properties==============================================================
    property int countAttachments: 0
    property int maxAttachments: 3
    property string tempImageFilePath: ""
    property string tempPath: ""
    property alias attListModel:attachmentListModel

    //Misc properties====================================================================


    ListModel {
        id: attachmentListModel
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
                console.log(">>>> In home page component > open menu");
                sideMenuDrawer.open();
            }
            //Navigating to the form page from home page
            onNextPage: {
//                switch(action) {
//                    case "fileareport":

                        //Changing the order - file a report will open with the location
                        formStackView.loadSetLocationPage();

//                        formStackView.loadFormPage();
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
                    console.log(">>>> In menu drawer > fileareport");
                        formStackView.loadSetLocationPage();
                    break;
                case "settings":
                    console.log(">>>> In menu drawer > settings");
                        formStackView.loadSettingsPage();
                    break;
                case "about":
                    console.log(">>>> In menu drawer > about");
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
            descText: qsTr("TODO: \nABOUT\nVersion:"+ app.version)
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
            titleText:qsTr("Add Report Details")
            descText: qsTr("TODO: \nFile a Report")
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadSubmitPage();
            }
        }
    }

    Component {
        id: setLocationPageComponent

        SetLocationPage {
            titleText:qsTr("Set Report Location")
            descText: qsTr("TODO: \nSet Location")
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadFormPage();
            }
        }
    }

    Component {
        id: setSubmitPageComponent

        SubmitPage {
            titleText:qsTr("Report Submitted!")

            onNextPage: {
                formStackView.loadHomePage();
            }
        }
    }


    //Creating stackview for form pages =================================================
    StackView {
        id: formStackView
        anchors.fill: parent
        initialItem: homePageComponent

        function loadHomePage() {
            console.log(">>>> Inside StackView.loadHomePage()")
            while (formStackView.count > 0)
                formStackView.pop()

            push(formStackView.initialItem);



        }

        //Load form page
        function loadFormPage() {
            console.log(">>>> Inside StackView.loadFormPage()")
            push(formPageComponent);
        }

        //Load About Page
        function loadAboutPage() {
            console.log(">>>> Inside StackView.loadAboutPage()")
            push(aboutPageComponent);
        }

        //Load Settings Page
        function loadSettingsPage() {
            console.log(">>>> Inside StackView.loadSettingsPage()")
            push(settingsPageComponent);
        }

        //Load SetLocation Page
        function loadSetLocationPage() {
            console.log(">>>> Inside StackView.loadSetLocationPage()")
            push(setLocationPageComponent);
        }

        //Load Submit Page
        function loadSubmitPage() {
            console.log(">>>> Inside StackView.loadSubmitPage()")
            push(setSubmitPageComponent);
        }

    }


    //Creating database for application==================================================

    SqlDatabase {
        id: db

        property FileInfo fileInfo: AppFramework.fileInfo("~/ArcGIS/Data/Sql/cleanuphamilton.sqlite")
        databaseName: fileInfo.filePath

        Component.onCompleted: {
            fileInfo.folder.makeFolder();
            db.open();
            db.exec( "DROP TABLE IF EXISTS SAVEDREPORTS" );
            db.exec( "CREATE TABLE IF NOT EXISTS SAVEDREPORTS ( reporttype TEXT, description TEXT, reportdate DATE, latitude REAL, longitude REAL ); " );
            db.insertSavedReports( "graffiti", "this is a test desc", Date("2020-07-28"), -37.9716929, 144.7729583 );
            db.exec( "SELECT COUNT(*) as saved_reports FROM SAVEDREPORTS" );
            db.exec( "SELECT * FROM SAVEDREPORTS" );
        }

        function exec( sql, ...params ) {
            let q = db.query( sql, ...params );
            console.log( " >>> db.query.SQL: ", sql );

            for ( let ok = q.first() ; ok ; ok = q.next() )
                console.log( " >>> db.query.values: ", JSON.stringify( q.values ) );
            q.finish();
        }

        function insertSavedReports( reporttype, description, reportdate, latitude, longitude ) {
            db.exec( "INSERT INTO SAVEDREPORTS VALUES (:reporttype, :description, :reportdate, :latitude, :longitude) ",
                 { reporttype, description, reportdate, latitude, longitude } );
        }
    }






    //Clear data after submission
    function clearData() {
        console.log(" >>> CLEARING DATA <<< ");
        app.attListModel.clear();
        app.currentLocationPoint = null;
        app.reportType = "";
        app.reportDescription = "";
    }


}






