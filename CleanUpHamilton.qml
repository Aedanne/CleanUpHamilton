/**
Clean-Up Hamilton Student Project
Using ESRI ArcGIS frameworks and libraries
Charisse Hanson
*/

import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.7
import ArcGIS.AppFramework.Sql 1.0
import ArcGIS.AppFramework.Platform 1.0

import "ui_controls"
import "pages"
import "images"

App{
    id: app
    width: 420
    height: 640

    property bool lightTheme: true

    // App-level color properties========================================================
    readonly property color primaryColor: Qt.darker("#CF5300",0.9) //"#DA674A" //"#255D83"
    readonly property color accentColor: Qt.lighter(primaryColor,1.2)
    readonly property color appBackgroundColor: lightTheme? "#FAFAFA":"#303030"
    readonly property color appDialogColor: lightTheme? "#FFFFFF":"424242"
    readonly property color menuBackgroundColor: "#DA674A"
    readonly property color appPrimaryTextColor: lightTheme? '#4C4C4C':"#FFFFFF"
    readonly property color menuPrimaryTextColor: Qt.lighter("#FFFFFF",1.5)
    readonly property color appSecondaryTextColor: lightTheme? '#8A8A8A':"#FFFFFF"
    readonly property color homePageTitleTextColor:"#FCFCFC"
    readonly property color appPrimaryTextColorInverted: lightTheme? "#FFFFFF":'#4C4C4C'
    //readonly property color listViewDividerColor:"#19000000"

    // App-level size properties=========================================================
    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: (app.width < 450*app.scaleFactor) ? (35 * scaleFactor) : (40 * scaleFactor)
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize
    readonly property real captionFontSize: 0.6 * app.baseFontSize
    readonly property real headerFontSize: baseFontSize*0.60
    readonly property real btnHdrFtrHeightSize: 50*app.scaleFactor

    // Stackview properties==============================================================
    property int steps: -1

    //Map properties=====================================================================
    property string webMapRootUrl: "https://waikato.maps.arcgis.com/home/item.html?id="
    property string webMapId: "7152b9397a1b446292d67076bfa4e842"  //Clean-Up Hamilton Map
    readonly property color mapBorderColor: "#303030"

    //Database properties================================================================
    property var attributesArray
    property var attributesArrayCopy
    property var savedReportLocationJson
    property var localDB



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


    //Creating database for application==================================================
    FileFolder {
        id: dbFileFolder;
        path: "~/ArcGIS/QuickReport/Sql";
    }

    SqlDatabase {
        id: db;
        databaseName: dbFileFolder.filePath("cleanuphamilton.sqlite");

        Component.onCompleted: {
            console.log("sqlite: dbFileFolder.makeFolder", dbFileFolder.makeFolder());
            console.log("sqlite: dbFileFolder.makePath", dbFileFolder.makePath(fileFolder.path));
            console.log("sqlite: db open", db.open());
            console.log("sqlite: dbFileFolder.INITIALIZED", dbFileFolder.path);
            initDB();
            readDataFromDevice();

            attributesArray = {};
            updateSavedReportsCount();
        }
    }

//    function randomColor (colortype) {
//        var types = {
//            "primary": ["#4A148C", "#0D47A1", "#004D40", "#006064", "#1B5E20", "#827717", "#3E2723"],
//            "background": ["#F5F5F5", "#EEEEEE"],
//            "foreground": ["#22000000"],
//            "accent": ["#FF9800", "yellow", "red"]
//        },
//        type = types[colortype]
//        return type[Math.floor(Math.random() * type.length)]
//    }

    function getProperty (name, fallback) {
        if (!fallback && typeof fallback !== "boolean") fallback = ""
        return app.info.propertyValue(name, fallback) || fallback
    }

    function initDB(){
        db.query("CREATE TABLE IF NOT EXISTS DRAFTS(id INT, typeIndex INT, size INT, attributes TEXT, date TEXT)");
    }

    //Read saved data from local storage
    function readDataFromDevice() {
        var dbname = app.info.itemId;
        if(dbname) {
            localDB = LocalStorage.openDatabaseSync(dbname, "1.0", "Draft Reports", 1000000);
            try {
                queryDataToInsert();
            } catch(error) {
                console.log("Error reading data from device...")
            }
        }
    }

    function queryDataToInsert() {
        db.query("BEGIN TRANSACTION");
        localDB.transaction(function(tx){
            var rs = tx.executeSql('SELECT * FROM DRAFTS');

            for(var i = 0; i < rs.rows.length; i++) {
                var attributes = rs.rows.item(i).attributes;
                var id = rs.rows[i].id;
                var typeIndex = rs.rows[i].pickListIndex;
                var size = rs.rows[i].size;
                var date = rs.rows[i].date;

                //insert into database
                var insert_query = db.query();
                insert_query.prepare("INSERT INTO DRAFTS(id, typeIndex, size, attributes, date)  VALUES(:id, :typeIndex, :size, :attributes, :date);")
                insert_query.executePrepared({id:id, typeIndex:typeIndex, size:size, attributes:attributes, date:date});
                insert_query.finish();

                //remove from local
                tx.executeSql('DELETE FROM DRAFTS WHERE id = ?', id)
            }
        })
        db.query("END TRANSACTION")
    }

    function db_prepare_sql(db, sql) {
        var dbQuery = db.query();
        dbQuery.prepare(sql);
        return dbQuery;
    }

    function db_error(dbError) {
        return new Error( "Error %1 (Type %2)\n%3\n%4\n"
                         .arg(dbError.nativeErrorCode)
                         .arg(dbError.type)
                         .arg(dbError.driverText)
                         .arg(dbError.databaseText)
                         );
    }

    function db_exec_sql(db, sql, obj) {
        var dbQuery = obj ? db.query(sql) : db.query(sql, obj);
        if (dbQuery.error) throw db_error(dbQuery.error);
        var ok = dbQuery.first();

        while (ok) {
            console.log("while ok", JSON.stringify(dbQuery.values));
            ok = dbQuery.next();
        }
        dbQuery.finish();
    }


    function saveReport(){
        app.focus = true;
        var savedNameofitem;
        if(app.isFromSaved){
            if(app.currentEditedSavedIndex !== undefined)
            {
                var select_query = db.query("SELECT * FROM DRAFTS WHERE id=:id;", {id: app.currentEditedSavedIndex});

                db.query("BEGIN TRANSACTION")

                for(var ok = select_query.first(); ok; ok = select_query.next()) {
                    var rs = select_query.values;
                    var attributes = rs.attributes;
                    savedNameofitem = JSON.parse(attributes)["index"];
                    var delete_query1 = db.query();
                    delete_query1.prepare("DELETE FROM DRAFTS WHERE id = :id;")

                    delete_query1.executePrepared({id: app.currentEditedSavedIndex});
                    delete_query1.finish();
                    db.query("END TRANSACTION");


                }

            }
        }

        var geometryForFeatureToEdit;
        if(captureType === "point")geometryForFeatureToEdit = app.theNewPoint;
        else if(captureType === "line")geometryForFeatureToEdit = app.polylineObj;
        else geometryForFeatureToEdit = app.polygonObj;

        var attributesToEdit = {};

        for ( var field in attributesArray) {
            if ( attributesArray[field] === "" || attributesArray[field] === null) {
                attributesToEdit[field] = null;
            } else {
                attributesToEdit[field] = attributesArray[field];
            }
        }

        if(theFeatureTypesModel.count>0) attributesToEdit[app.typeIdField] =  theFeatureTypesModel.get(pickListIndex).value;
        var finalJSONEdits = [{"attributes": attributesToEdit, "geometry": geometryForFeatureToEdit.json}]
        console.log("JSON for save feature json", JSON.stringify(finalJSONEdits))

        var currentDate = new Date();
        var id = currentDate.getTime();
        var dateString = currentDate.toLocaleString(Qt.locale(),"MMM d, hh:mm AP");

        var filePaths = [];
        var size = 0;

        for(var i=0;i<app.appModel.count;i++){
            temp = app.appModel.get(i).path;
            exifInfo.load(temp.toString().replace(Qt.platform.os == "windows"? "file:///": "file://",""))
            fileInfo.filePath = exifInfo.filePath;
            size+=fileInfo.size;
            app.selectedImageFilePath = AppFramework.resolvedPath(temp);
            filePaths.push(AppFramework.resolvedPath(temp))
        }
        var count = 0;

        var select_query1 = db.query("SELECT MAX(5) as maxdraft FROM DRAFTS")
                if(theFeatureTypesModel.count === 0)
                {
                    for(var name = select_query1.first(); name; name = select_query1.next()) {
                        var rs_name = select_query1.values;
                        var itemname =rs_name["maxdraft"]
                        count = itemname + 1


                    }
                }


        var nameofitem = theFeatureTypesModel.count>0 ? theFeatureTypesModel.get(pickListIndex).label : (app.isFromSaved? "Draft "+(savedNameofitem+1): "Draft "+count);
        var xmax = app.centerExtent? app.centerExtent.xMax : null;
        var xmin = app.centerExtent? app.centerExtent.xMin : null;
        var ymax = app.centerExtent? app.centerExtent.yMax: null;
        var ymin = app.centerExtent? app.centerExtent.yMin: null;

        console.log("app.centerExtent", xmax, xmin, ymax, ymin);

        attributesArray["_xMax"] = xmax;
        attributesArray["_xMin"] = xmin;
        attributesArray["_yMax"] = ymax;
        attributesArray["_yMin"] = ymin;
        attributesArray["_realValue"] = app.measureValue? app.measureValue:0;
        attributesArray["hasAttachment"] = app.hasAttachment;
        attributesArray["isReadyForSubmit"] = app.isReadyForSubmit;
        attributesArray["index"] = app.isFromSaved?savedNameofitem:(theFeatureTypesModel.count>0? -1:count-1);

        var insert_query = db.query();
        insert_query.prepare("INSERT INTO DRAFTS(id, pickListIndex, size, nameofitem, editsjson, attributes, date, attachments, featureLayerURL)  VALUES(:id, :pickListIndex, :size, :nameofitem, :editsjson, :attributes, :date, :attachements, :featureLayerURL);")

        insert_query.executePrepared({id:id, pickListIndex:pickListIndex, size:size, nameofitem:nameofitem, editsjson:JSON.stringify(finalJSONEdits), attributes:JSON.stringify(attributesArray), date:dateString, attachements:JSON.stringify(filePaths), featureLayerURL:featureLayerURL.toString()});

        db.query("END TRANSACTION")

        isShowCustomText = false

        app.theFeatureEditingAllDone = true;
        app.theFeatureEditingSuccess = true;


    }

    Component.onCompleted: {

        //Check permissions to access storage
        if(Permission.checkPermission(Permission.PermissionTypeStorage) && Qt.platform.os === "android"){
            storageAccessDialog.visible = true;
        }

    }

}






