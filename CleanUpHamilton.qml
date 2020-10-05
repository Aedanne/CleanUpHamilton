import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.2

import ArcGIS.AppFramework.Networking 1.0
import ArcGIS.AppFramework.Multimedia 1.0
import ArcGIS.AppFramework.Notifications 1.0
import ArcGIS.AppFramework.WebView 1.0
import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.5
import ArcGIS.AppFramework.Sql 1.0
import ArcGIS.AppFramework.Platform 1.0

import 'ui_controls'
import 'pages'
import 'images'


/*
Clean-Up Hamilton Application MAIN QML
Using ESRI ArcGIS frameworks and libraries
Author: Charisse Hanson
*/

App{
    id: app
    width: 460
    height: 780

    property string version: app.info.version

    // App-level color properties========================================================
    readonly property color defaultPrimaryColor: '#30475e'
    readonly property string defaultPrimaryColorText: '#30475e'
    readonly property color primaryColor: overridePrimaryColor !== '' ? overridePrimaryColor : defaultPrimaryColor
    readonly property color accentColor: Qt.lighter(primaryColor,1.2)
    readonly property color appBackgroundColor: '#FFFFFF'
    readonly property color appBackgroundColorCaseList: '#F0F0F0'
    readonly property color appBorderColorCaseList: '#DDDDDD'
    readonly property color appBackgroundColorLightGray: '#F6F6F6'
    readonly property color appBackgroundColorDarkGray: '#B8B8B8'
    readonly property color appDialogColor: '#FFFFFF'
    readonly property color menuBackgroundColor: '#DA674A'
    readonly property color appPrimaryTextColor: primaryColor
    readonly property color menuPrimaryTextColor: Qt.lighter('#FFFFFF',1.5)
    readonly property color appSecondaryTextColor: '#676767'
    readonly property color homePageTitleTextColor:'#FCFCFC'
    readonly property color appPrimaryTextColorInverted: '#FFFFFF'
    readonly property color backgroundAccent: '#AEAEAE'
    //readonly property color listViewDividerColor:'#19000000'
    readonly property color cameraViewBackgroundColor: '#1C1C1C'
    readonly property color mapBorderColor: '#303030'
    readonly property color disabledIconColor: '#B0B0B0'
    readonly property color disabledIconShadowColor: 'red'

    property string overridePrimaryColor: ''
    property string localOverrideColor: ''

    // App-level size properties=========================================================
    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: (app.width < 450*app.scaleFactor) ? (35 * scaleFactor) : (40 * scaleFactor)
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize
    readonly property real captionFontSize: 0.6 * app.baseFontSize
    readonly property real headerFontSize: baseFontSize*0.60
    readonly property real btnHdrFtrHeightSize: 50*app.scaleFactor

    //Map properties=====================================================================
    readonly property string webMapRootUrl: 'https://waikato.maps.arcgis.com/home/item.html?id='
    readonly property string webMapId: 'bedb6a09b8b54d9f866f49de216b87c7'  //Clean-Up Hamilton Default Map
    readonly property string staffWebMapId: '54892985091c4a5598010e0757bea00b'
    property Point currentLocationPoint
    property string currentLonLat
    //Anon feature layer view and staff feature layer view
    // https://services1.arcgis.com/gjbU5qa8FJmAPFZX/arcgis/rest/services/Cases_View/FeatureServer/0
    // https://services1.arcgis.com/gjbU5qa8FJmAPFZX/arcgis/rest/services/Cases/FeatureServer/0
    readonly property string featureServerURL: 'https://services1.arcgis.com/gjbU5qa8FJmAPFZX/arcgis/rest/services/Cases/FeatureServer/0'
    property var agolPortal
    property var reportedCasesMapView
    property ServiceFeatureTable reportedCasesFeatureService
    property Geometry reportedCasesMapExtent
    property ArcGISFeature reportedCaseFeature
    property string lastStatusCaseList: ''
    property string lastStatusCaseListFull: ''

    //Database properties================================================================
    property var attributesArray
    property var attributesArrayCopy
    property var savedReportLocationJson
    property var localDB

    //Report data properties=============================================================
    property string reportType
    property int reportTypeIndex: -1
    property string reportDescription: ''
    property date reportDate

    //Attachment properties==============================================================
    property int countAttachments: 0
    property int maxAttachments: 3
    property string tempImageFilePath: ''
    property string tempPath: ''
    property alias attListModel:attachmentListModel

    //Misc properties====================================================================
    readonly property string cleanUpHamiltonClientId: 'y5uFdm2AiF58sqBj'
    property bool authenticated: false
    property string portalUser
    property int saveSettings: 0



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
            menuModel: app.authenticated ? sideMenuDrawerModel1 : sideMenuDrawerModel0
            onMenuSelected: {
                sideMenuDrawer.close()
                switch(action){
                case 'fileareport':
                    console.log('>>>> In menu drawer > fileareport')
                        formStackView.loadSetLocationPage()
                    break
                case 'reportedcases':
                    console.log('>>>> In menu drawer > reportedcasesmap')
                        formStackView.loadReportedCasesMapPage()
                    break
                case 'settings':
                    console.log('>>>> In menu drawer > settings')
                        formStackView.loadSettingsPage()
                    break
                case 'about':
                    console.log('>>>> In menu drawer > about')
                        formStackView.loadAboutPage()
                    break
                case 'login':
                    console.log('>>>> In menu drawer > login')
                    console.log('>>>> AUTHENTICATED: ' + app.authenticated)

                        formStackView.loadLoginPage()
                    break
                default:
                    break
                }
            }
        }
    }

    //Side menu options to send to drawer model=========================================
    ListModel{
        id: sideMenuDrawerModel0  //Login option

        ListElement {
            action:'fileareport'
            type: 'delegate'
            name: qsTr('File a Report')
            iconSource: '../images/add_note.png'
        }
        ListElement {
            action:'divider'
            type: ''
            name: 'divider'
            iconSource: ''
        }
        ListElement {
            action:'about'
            type: 'delegate'
            name: qsTr('About')
            iconSource: '../images/info.png'
        }
        ListElement {
            action:'settings'
            type: 'delegate'
            name: qsTr('Settings')
            iconSource: '../images/gear.png'
        }
        ListElement {
            action:'login'
            type: 'delegate'
            name: qsTr('Staff Login')
            iconSource: '../images/login.png'
        }
    }

    /* //Bypass login - used for debugging
    ListModel{
        id: sideMenuDrawerModel1

        ListElement {
            action:'fileareport'
            type: 'delegate'
            name: qsTr('File a Report')
            iconSource: '../images/add_note.png'
        }
        ListElement {
            action:'reportedcases'
            type: 'delegate'
            name: qsTr('Reported Cases')
            iconSource: '../images/edit.png'
        }
        ListElement {
            action:'divider'
            type: ''
            name: 'divider'
            iconSource: ''
        }
        ListElement {
            action:'about'
            type: 'delegate'
            name: qsTr('About')
            iconSource: '../images/info.png'
        }
        ListElement {
            action:'settings'
            type: 'delegate'
            name: qsTr('Settings')
            iconSource: '../images/gear.png'
        }
    }
    */

    //Page Components =====================================================

    //Home page component
    Component{
        id: homePageComponent

        HomePage {
            width: parent.width
            opacity: 1
            descText1: qsTr('Clean-Up')
            descText2: qsTr('Hamilton')

            onOpenMenu: {
                console.log('>>>> In home page component > open menu')
                sideMenuDrawer.open()
            }

            //Navigating to the form page from home page
            onNextPage: {
                //Changing the order - file a report will open with the location
                formStackView.loadSetLocationPage()
            }
        }
    }

    //About component when menu option selected
    Component{
        id: aboutPageComponent

        AboutPage{
            titleText:qsTr('About')
            descText: qsTr('ABOUT')
            descText1: qsTr('Version: ' +app.version)

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
            titleText:qsTr('Settings')
            descText: qsTr('Settings')

            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                settingsdb.insertSettings()
                formStackView.loadHomePage()
                app.localOverrideColor = ''
                settingsdb.querySettings()
            }
        }
    }

    //Report Details component from Set Report Location
    Component {
        id: formPageComponent

        FormPage {
            titleText:qsTr('Add Report Details')
            descText: qsTr('File a Report')

            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadSubmitPage()
            }
        }
    }

    //Set Location Component from File a Report action
    Component {
        id: setLocationPageComponent

        SetLocationPage {
            titleText:qsTr('Set Report Location')
            descText: qsTr('Set Location')
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadFormPage()
            }
        }
    }

    //Report Submitted component when submit action is invoked from form page
    Component {
        id: setSubmitPageComponent

        SubmitPage {
            titleText:qsTr('Report Submitted!')

            onNextPage: {
                formStackView.loadHomePage()
            }
        }
    }

    //Login component when menu option selected
    Component{
        id: loginPageComponent

        LoginPage {
            titleText:qsTr('Staff Login')
            descText: qsTr('')

            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
            }
        }
    }

    //Reported Cases component when menu option selected
    Component{
        id: reportedCasesMapPageComponent

        ReportedCasesMapPage{
            titleText:qsTr('Reported Cases Map')
            descText: qsTr('Reported Cases Map')
            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadCasesListPage()
            }

            onReload: {
                formStackView.reloadReportedCasesMapPage()
            }
        }
    }

    //Cases List component from Reported Cases Map page
    Component{
        id: casesListPageComponent

        CasesListPage {
            titleText:qsTr('Reported Cases')
            descText: qsTr('Reported Cases')

            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadHomePage()
            }

            onNextPageEdit: {
                formStackView.loadReportedCaseFormPage()
            }
        }
    }

    //Reported Cases Edit Form component from Cases List Page
    Component {
        id: reportedCaseFormPageComponent

       ReportedCaseFormPage {
            titleText:qsTr('Reported Case Edit')
            descText: qsTr('Reported Case Edit')

            onActiveFocusChanged: init()

            onPreviousPage: {
                formStackView.pop()
            }

            onNextPage: {
                formStackView.loadReportedCaseFormPageFromFormEdit()
            }
        }
    }


    //Creating stackview for application pages/navigation control ===================================
    StackView {
        id: formStackView
        anchors.fill: parent
        initialItem: homePageComponent

        function loadHomePage() {
            console.log('>>>> Inside StackView.loadHomePage()')
            while (formStackView.count > 0)
                formStackView.pop()

            push(formStackView.initialItem)
        }

        //Load form page
        function loadFormPage() {
            console.log('>>>> Inside StackView.loadFormPage()')
            push(formPageComponent)
        }

        //Load About Page
        function loadAboutPage() {
            console.log('>>>> Inside StackView.loadAboutPage()')
            push(aboutPageComponent)
        }

        //Load Settings Page
        function loadSettingsPage() {
            console.log('>>>> Inside StackView.loadSettingsPage()')
            push(settingsPageComponent)
        }

        //Load SetLocation Page
        function loadSetLocationPage() {
            console.log('>>>> Inside StackView.loadSetLocationPage()')
            push(setLocationPageComponent)
        }

        //Load Submit Page
        function loadSubmitPage() {
            console.log('>>>> Inside StackView.loadSubmitPage()')
            push(setSubmitPageComponent)
        }

        //Load Login Page
        function loadLoginPage() {
            console.log('>>>> Inside StackView.loadLoginPage()')
            push(loginPageComponent)
        }

        //Load Reported Cases Page
        function loadReportedCasesMapPage() {
            console.log('>>>> Inside StackView.loadReportedCasesMapPage()')
            push(reportedCasesMapPageComponent)
        }

        //Reload Reported Cases Page
        function reloadReportedCasesMapPage() {
            console.log('>>>> Inside StackView.reloadReportedCasesMapPage()')
            replace(reportedCasesMapPageComponent)
        }

        //Load Cases List Page
        function loadCasesListPage() {
            console.log('>>>> Inside StackView.loadCasesListPage()')
            push(casesListPageComponent)
        }

        //Load Reported Case Form Page
        function loadReportedCaseFormPage() {
            console.log('>>>> Inside StackView.loadReportedCaseFormPage()')
            push(reportedCaseFormPageComponent)
        }

        //Load Reported Case Form Page from Form Edit
        function loadReportedCaseFormPageFromFormEdit() {
            console.log('>>>> Inside StackView.loadReportedCaseFormPageFromFormEdit()')
            pop()
            replace(casesListPageComponent)
        }
    }


    //Attachment listmodel for application
    ListModel {
        id: attachmentListModel
    }


    //SqlDatabase ==================================================

    //Declare sqldatabase object for use with saving the settings data
    SqlDatabase {
        id: settingsdb

        property FileInfo fileInfo: AppFramework.fileInfo('~/ArcGIS/Data/Sql/cleanuphamilton.sqlite')
        databaseName: fileInfo.filePath

        Component.onCompleted: {
            fileInfo.folder.makeFolder()
            settingsdb.open()
            settingsdb.querySettings()
        }

        function exec( sql, ...params ) {
            let q = settingsdb.query( sql, ...params )
            console.log( ' >>> settingsdb.query.SQL: ', sql )

            for ( let ok = q.first();  ok;  ok = q.next() )
                console.log( ' >>> settingsdb.query.values: ', JSON.stringify( q.values ) )
            q.finish()
        }

        function insertSettings() {
            var themeColor = app.localOverrideColor
            console.log('>>>> THEMECOLOR = ', themeColor)

            settingsdb.beginTransaction()
            settingsdb.exec( 'DROP TABLE IF EXISTS SETTINGS' )
            settingsdb.exec( 'CREATE TABLE IF NOT EXISTS SETTINGS ( themecolor TEXT ) ' )

            console.log('>>>> INSERTING ----- ')
            var insert =  settingsdb.query()
            insert.prepare('INSERT INTO SETTINGS (themecolor) VALUES (:themecolor) ')
            insert.executePrepared( { 'themecolor': themeColor } )
            insert.finish()
            settingsdb.commitTransaction()
            querySettings()

        }

        function querySettings() {
            var query = settingsdb.query( 'SELECT * FROM SETTINGS' )
            if (query.first()) {
                var settings = JSON.parse(JSON.stringify(query.values))
                console.log('>>>> themecolor:', settings.themecolor )
                //set the override color
                app.overridePrimaryColor = settings.themecolor
                query.finish()
            }
        }
    }


    //Clear data after submission
    function clearData() {
        console.log('>>>> CLEARING DATA <<<< ')
        app.attListModel.clear()
        app.currentLocationPoint = null
        app.reportType = ''
        app.reportDescription = ''
        app.reportTypeIndex = -1
        app.currentLonLat = ''
    }
}






