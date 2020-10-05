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


import '../ui_controls'
import '../images'
import '../assets'


/*
Form page for Clean-Up Hamilton app
*/

Page {

    id:formPage

    signal nextPage()
    signal previousPage()

    property var descText
    property int maxLimit: 200
    property int currChars
    property string titleText: ''

    property ArcGISFeature reportFeature
    property int attIndex
    property string qryString
    property int objectID

    property bool isDebug: true
    property string debugText: 'Debug on'

    //Camera picture properties
    property string fileLocation: '../images/temp.png'
    property int defaultImgRes: 1024


    //Header custom QML =================================================================
    header: HeaderSection {
        id: formPageHeader
        logMessage: '>>>> Header: FORM PAGE'

    }

    //Main body of the page =============================================================

    //Position of the device - will be used for tracking GPS information in the photos
    PositionSource {
        id: positionSource
        updateInterval: 5000
        active: false
    }

    contentItem: Rectangle {
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: 50 * app.scaleFactor
        color: app.appBackgroundColor

        ColumnLayout {
            Layout.preferredWidth: parent.width*0.75
            spacing: 0

            anchors {
                fill: parent
                margins: 20 * app.scaleFactor
            }

            RowLayout {
                spacing: 0
                visible: true

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: 'Report Type '
                    color: app.appPrimaryTextColor
                    bottomPadding: 5 * app.scaleFactor
                }
                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: '*'
                    color: 'red'
                    bottomPadding: 5 * app.scaleFactor
                }
            }

            ComboBox {
                id: typeComboBox
                Layout.fillWidth: true
                currentIndex: app.reportTypeIndex
                font.bold: true
                font.pixelSize: app.baseFontSize*.4
                displayText: currentIndex === -1 ? 'Please Choose...' : currentText

                delegate: ItemDelegate {
                    width: parent.width

                    contentItem: Text {
                        text: modelData
                        color: app.appSecondaryTextColor
                        font: typeComboBox.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    highlighted: typeComboBox.highlightedIndex === index
                }

                model: ListModel {
                    id: typeIndex
                    ListElement { text: 'Graffiti' }
                    ListElement { text: 'Broken items'  }
                    ListElement { text: 'Illegal rubbish dumping'  }
                    ListElement { text: 'Other'  }
                }

                width: 200

                onCurrentIndexChanged: {
                    try {
                        debugText = '>>>> Combo Box selected: ' + typeIndex.get(currentIndex).text
                        console.log(debugText)
                    } catch (err) {
                        console.log('>>> err: ',err.message)
                    }

                    app.reportTypeIndex = currentIndex
                    app.reportType = typeComboBox.displayText

                    initFeatureService()
                }

                contentItem: Text {
                    leftPadding: 5 * app.scaleFactor
                    rightPadding: typeComboBox.indicator.width + typeComboBox.spacing

                    text: typeComboBox.displayText
                    font: typeComboBox.font
                    color: (typeComboBox.currentIndex === -1) ? 'red': app.appSecondaryTextColor
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }

            RowLayout {
                spacing: 0
                visible: true

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: 'Description '
                    color: app.appPrimaryTextColor
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: '(' + currChars + '/' + maxLimit + ')'
                    color: (currChars == maxLimit) ? 'red' : app.appSecondaryTextColor
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75 * scaleFactor
                border.color: app.appPrimaryTextColor
                border.width: 1 * scaleFactor
                radius: 2

                ScrollView {
                    anchors.fill: parent
                    contentItem: parent

                    TextArea {
                        id: descriptionField
                        Material.accent: app.backgroundAccent
                        background: null
                        padding: 3 * scaleFactor
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        placeholderText: 'Enter additional information...'
                        color: app.appSecondaryTextColor
                        text: app.reportDescription

                        onTextChanged: {
                           currChars = descriptionField.text.length
                           if (currChars >= maxLimit) {
                              descriptionField.text = descriptionField.text.substring(0, maxLimit)
                           }
                           debugText = '>>>> char count: ' + (maxLimit - descriptionField.text.length)
                           console.log(debugText)
                           debugText = '>>>> line count'+ (descriptionField.contentHeight / descriptionField.lineCount)
                           console.log(debugText)
                           app.reportDescription = descriptionField.text
                        }
                    }
                }
            }

            RowLayout {
                spacing: 0
                visible: true

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: 'Supporting Photos '
                    color: app.appPrimaryTextColor
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 2 * app.scaleFactor
                }

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: '*'
                    color: 'red'
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 2 * app.scaleFactor
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: '(' + app.attListModel.count + '/' + maxAttachments + ')'
                    color: (app.attListModel.count == maxAttachments) ? 'red' : app.appSecondaryTextColor
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 2 * app.scaleFactor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75 * scaleFactor

                RowLayout {
                    anchors.fill: parent
                    Layout.alignment: Qt.AlignLeft
                    spacing: 10*app.scaleFactor

                    IconTemplate {
                        id: cameraIconTemplate
                        imgRadius: 2
                        containerSize: 50*app.scaleFactor
                        imageSource: '../images/camera.png'
                        color: (app.attListModel.count === app.maxAttachments) ? Qt.lighter('#6e6e6e', 0.5) : '#6e6e6e'
                        Layout.alignment: Qt.AlignLeft

                        enabled: (app.attListModel.count === app.maxAttachments) ? false: true
                        maxAttach: (app.attListModel.count === app.maxAttachments) ? true: false

                        onIconClicked: {
                            //Device location
                            positionSource.start()

                            //Start camera
                            cameraDialog.open()
                        }
                    }

                    //Datamodel for displaying the preview photos
                    ListModel {
                        id: displayPreviewListModel

                        Component.onCompleted: {
                            displayPreviewListModel.initDisplayPreviewListModel()
                        }

                        function initDisplayPreviewListModel() {
                            var temp

                            //clear the previews before reloading from attListModel
                            displayPreviewListModel.clear()

                            var attachCount = 0
                            for (var i = 0; i < app.maxAttachments; i++) {
                                debugText = '>>>>>>app.attListModel.count' + app.attListModel.count
                                console.log(debugText)

                                if(i < app.attListModel.count) {
                                    debugText = '>>>>>> i < app.attListModel.count, i=' + i + ' ... ' + app.attListModel.count
                                    console.log(debugText)

                                    temp = app.attListModel.get(i)
                                    var tempPath = temp.path

                                    //Fix file path url if windows vs android
                                    exifInfo.load(tempPath.toString().replace(Qt.platform.os == 'windows'? 'file:///': 'file://',''))

                                    displayPreviewListModel.append({path: tempPath})

                                    debugText = '>>>>>displayPreviewListModel.size' + displayPreviewListModel.count
                                    console.log(debugText)

                                    attachCount++
                                } else {
                                    displayPreviewListModel.append({path: ''})
                                }
                            }
                            app.countAttachments = attachCount
                        }
                    }

                    //Display thumbnail of images using gridview
                    Rectangle {
                        id: thumbnailRectangle
                        color: 'transparent'
                        Layout.preferredWidth: parent.width*0.80
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignCenter
                        clip:true

                        GridView {
                            id: thumbGridView
                            width: parent.width
                            height: parent.height
                            visible: true
                            model: displayPreviewListModel
                            cellWidth: parent.width/3
                            cellHeight: parent.height

                            delegate: Item {
                                width: thumbGridView.cellWidth*1.1
                                height: thumbGridView.cellHeight

                                ImageIconTemplate {
                                    id: previewPhotoIcons
                                    enabled: cameraDialog.enabled
                                    imgSource: path

                                    onImageIconClicked: {
                                        if (app.attListModel.count > 0) {
                                            debugText = '>>> image clicked - thumbgridview >>> ' + 'path:' + path
                                            console.log(debugText)

                                            thumbGridView.currentIndex = index
                                            if (thumbGridView.currentIndex < app.attListModel.count) {

                                                debugText = '>>> thumbGridView.currentIndex >>> ' + thumbGridView.currentIndex
                                                console.log(debugText)
                                                previewSection.source = path
                                                previewSection.visible = true
                                                previewSection.init()

                                                //hide header and footer
                                                formPageFooter.visible = false
                                                formPageHeader.visible = false
                                            } else {
                                                //Start camera
                                                cameraDialog.open()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } //End rectangle for thumbnail previewBtn

            RowLayout {
                spacing: 0
                visible: true

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    font.bold: true
                    text: 'Report Location '
                    color: app.appPrimaryTextColor
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: '*'
                    color: 'red'
                    topPadding: 35 * app.scaleFactor
                    bottomPadding: 5 * app.scaleFactor
                }
            }

            Label {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.4
                text: app.currentLonLat
                color: app.appSecondaryTextColor
                font.bold: true
                bottomPadding: 5 * app.scaleFactor
                verticalAlignment: Text.AlignBottom
            }

            RowLayout {
                spacing: 0
                visible: false//isDebug

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: app.baseFontSize*.3
                    text: debugText
                    color: 'red'
                    topPadding: 25 * app.scaleFactor
                }
            }

            Text {
                Layout.fillWidth: true
                font.pixelSize: app.baseFontSize*.2
                font.bold: true
                text: ''
                color: app.appPrimaryTextColor
                verticalAlignment: Text.AlignTop
                topPadding: 200 * app.scaleFactor
            }
        }

        //Arcgis CameraDialog QML Type ========================================
        //This will open up the camera view
        CameraDialog {
            id: cameraDialog

            onAccepted: {
                if (captureMode === CameraDialog.CameraCaptureModeStillImage) {
                    //If position source is enabled and lattitude exists, then add GPS data to image
                    if (positionSource.position.coordinate.latitude) addGPSParameters(fileUrl)

                    //Check if image is too big and resize
                    debugText = '>>>>>>>fileUrl='+fileUrl
                    console.log(debugText)
                    resizeImage(fileUrl)

                    app.tempImageFilePath = fileUrl
                    debugText = '>>>>>>>app.tempImageFilePath='+fileUrl
                    console.log(debugText)

                    //Append multiple attachments to list model
                    app.attListModel.append({path: app.tempImageFilePath.toString(), type: 'attachment'})

                    displayPreviewListModel.initDisplayPreviewListModel()

                    positionSource.stop()
                }
            }
        }

        //Photo to include is cast as ImageObject type for loading and transforming
        ImageObject {
            id: imageObject
        }

        PreviewAttachmentSection {
            id: previewSection

            onDiscarded: {
                debugText = '>>>> thumbGridView.currentIndex'+ thumbGridView.currentIndex
                console.log(debugText)
                app.attListModel.remove(thumbGridView.currentIndex)
                displayPreviewListModel.initDisplayPreviewListModel()
            }

            onRefresh: {
                displayPreviewListModel.initDisplayPreviewListModel()
            }
        }
    }

    //Handles connection to ArcGIS Waikato feature server for Clean-up Hamilton project
    FeatureLayer {
        ServiceFeatureTable {
            id: casesFeatureTable
            url: app.featureServerURL

            onLoadStatusChanged: {
                debugText = '>>>> onLoadStatusChanged --- ' + loadStatus
                console.log(debugText)
            }

            onAddFeatureStatusChanged: {
                debugText = '>>>> onAddFeaturesStatusChanged --- ' + addFeatureStatus
                console.log(debugText)
                if (addFeatureStatus === Enums.TaskStatusCompleted) {
                   debugText = '>>>> successfully added feature'
                   console.log(debugText)
                }
            }

            onApplyEditsStatusChanged: {
                debugText = '>>>> onApplyEditsStatusChanged --- ' + applyEditsStatus
                console.log(debugText)
                if (applyEditsStatus === Enums.TaskStatusCompleted) {
                    debugText = '>>>> successfully updated feature'
                    console.log(debugText)
                    if (attIndex != -1) {
                        //Query for feature just added to add more attachments
                        queryAddedFeatureForAttachments()
                    } else {
                        enableFormElements(true)
                        app.clearData()
                        nextPage()
                    }
                }
            }

            onUpdateFeatureStatusChanged: {
                debugText = '>>>> onUpdateFeatureStatusChanged --- ' + updateFeatureStatus
                console.log(debugText)
                if (updateFeatureStatus === Enums.TaskStatusCompleted) {
                    debugText = '>>>> successfully updated feature'
                    console.log(debugText)
                }
            }

            onHasAttachmentsChanged: {
                debugText = '>>>> onHasAttachmentsChanged --- '
                console.log(debugText)
            }

            onQueryFeaturesStatusChanged: {
                if (queryFeaturesStatus === Enums.TaskStatusCompleted) {
                     //set this to the report feature just entered
                     reportFeature = queryFeaturesResult.iterator.next()

                     objectID = reportFeature.attributes.attributeValue('OBJECTID')
                     debugText = '>>>> QUERY: reportFeature --- Obj ID: ' + objectID
                     console.log(debugText)

                     if (objectID != -1) {
                         addAdditionalAttachments()
                     }
                }
            }
        }
    }

    //Validation at submit - checks for required data
    AlertPopup {
        id: formMissingData
        alertText: (app.reportType === '' ? 'Select report type.' : '')
                    + ((app.attListModel.count == 0) ? ((app.reportType === '' ? '\n':'') + 'Include at least 1 photo.') : '')
    }

    LoadingAnimation {
        id: loadingAnimationFormPage
        visible: false
    }

    //Query parameter object for accessing AGOL webmap layer
    QueryParameters {
        id: params
        maxFeatures: 1
    }

    FormHelp {
        id: help
    }

    //Used for editing exchangeable image (exif) file medatadata
    ExifInfo{
        id: exifInfo
    }

    //Footer custom QML =================================================================
    footer: FooterSection {
        id: formPageFooter
        logMessage: 'In Form Page - Footer...'
        rightButtonText: 'SUBMIT'
        overrideRightIconSrc: '../images/send.png'
    }


    //Functions for Report Details page / data submission ==============================

    //Initialize feature service in preparation for data submission
    function initFeatureService() {
        //load the feature server when page is loaded, if not already running
        if (casesFeatureTable.loadStatus != Enums.LoadStatusLoaded) {
            debugText = '>>>> Form page initFeatureService() -- loading feature layer...'
            console.log(debugText)
            casesFeatureTable.load()
        }
    }

    //Function to resize image if exceeds 1024
    function resizeImage(path) {
        debugText =  '>>>> resizeImage() from camera: '+ path
        console.log(debugText)

        var imageInfo = AppFramework.fileInfo(path)
        if (!imageInfo.exists) {
            debugText = '>>>>> Image invalid:' + path
            console.error(debugText)
            return
        }

        if (!imageObject.load(path)) {
            debugText = '>>>>> Can not load:' + path
            console.error(debugText)
            return
        }

        if (imageObject.width > defaultImgRes) {
            debugText = '>>>>> Resizing image: '+ imageObject.width+ ' x'+ imageObject.height+ ' size:'+ imageInfo.size
            console.log(debugText)
            imageObject.scaleToWidth(defaultImgRes)
        } else {
            debugText = '>>>>> Does not need image resizing:' + imageObject.width + '<=' + defaultImgRes
            console.log(debugText)
            return
        }

        if (!imageObject.save(path)) {
            debugText = '>>>>> Can not save to path:' + path
            console.error(debugText)
            return
        }

        //Refresh updated image in device
        imageInfo.refresh()
    }

    //Arcgis appframework code snippet for adding GPS data to image using current location
    function addGPSParameters(filePath) {
        exifInfo.load(filePath)
        exifInfo.setImageValue(ExifInfo.ImageDateTime, new Date())
        exifInfo.setImageValue(ExifInfo.ImageSoftware, app.info.title)
        exifInfo.setExtendedValue(ExifInfo.ExtendedDateTimeOriginal, new Date())

        if (positionSource.position.latitudeValid) exifInfo.gpsLatitude = positionSource.position.coordinate.latitude
        if (positionSource.position.longitudeValid) exifInfo.gpsLongitude = positionSource.position.coordinate.longitude
        if (positionSource.position.altitudeValid) exifInfo.gpsAltitude = positionSource.position.coordinate.altitude
        if (positionSource.position.horizontalAccuracyValid) {
            exifInfo.setGpsValue(ExifInfo.GpsHorizontalPositionError, positionSource.position.horizontalAccuracy)
        }

        if (positionSource.position.directionValid) {
            exifInfo.setGpsValue(ExifInfo.GpsTrack, positionSource.position.direction)
            exifInfo.setGpsValue(ExifInfo.GpsTrackRef, 'T')
        }

        exifInfo.save(filePath)
    }

    //Submit data to feature server - load feature layer
    function submitReportData() {
        //init
        attIndex = 0
        objectID = -1

        disableFormElements(true, true)
        loadingAnimationFormPage.loadingText = 'Submitting data...'

        if (casesFeatureTable.loadStatus === Enums.LoadStatusLoaded) {
            //Create JSON for data to submit
            var reportAttributes = buildAttributesJSON()

            // create a new feature using the mouse's map point
            reportFeature = casesFeatureTable.createFeatureWithAttributes(reportAttributes, app.currentLocationPoint)

            if (app.countAttachments > 0) {
                debugText = '>>>> submitReportData(): Add attachment index: ' + attIndex
                console.log(debugText)

                var img = app.attListModel.get(attIndex)
                debugText = '>>>> Attaching image: ' + img + ' >>> ' + img['path']
                console.log(debugText)
                reportFeature.attachments.addAttachment(img['path'], 'image/jpeg', 'Attachment'+(attIndex+1))

                if (app.attListModel.count > attIndex+1) {
                    attIndex++
                } else {
                    attIndex = -1 //No more
                }
            }

            debugText = '>>>> reportFeature = ' + reportFeature
            console.log(debugText)

            // add the new feature to the feature table
            casesFeatureTable.addFeature(reportFeature)
        }
    }

    //Build attributes JSON for feature (report data)
    function buildAttributesJSON() {
        //Set global properties
        app.reportType = typeComboBox.displayText
        app.reportDescription = descriptionField.text
        app.reportDate = new Date()

        qryString = 'QRY:'+app.reportType+''+app.reportDate.toISOString()+''+app.currentLonLat

        debugText = '>>>> qryString: ' + qryString
        console.log(debugText)

        console.log('>>>> Pre-submit data check:')
        console.log('>>>> reportType: ' + app.reportType)
        console.log('>>>> reportDescription: ' + app.reportDescription)
        console.log('>>>> reportDate: ' + app.reportDate)
        console.log('>>>> status: Pending ' )
        console.log('>>>> currentLocation: ' + app.currentLonLat )

        var reportAttributes = {
            'Type' : app.reportType,
            'Description' : app.reportDescription,
            'ReportedDate' : app.reportDate,
            'QryString' : qryString,
            'Location' : app.currentLonLat,
            'CurrentStatus': 'Pending'
        }

        console.log('>>>> JSON Report Attributes: ' + reportAttributes)
        return reportAttributes
    }

    //Function to form and execute the query
    function queryAddedFeatureForAttachments() {
        // set the where clause
        params.whereClause = "QryString = '" + qryString + "' "

        // start the query
        casesFeatureTable.queryFeatures(params)
    }

    //Function to add additional attachments, since createFeature only supports one attachment
    function addAdditionalAttachments() {
        loadingAnimationFormPage.loadingText = 'Submitting attachments...'
        debugText = '>>>> addAdditionalAttachments() index: ' + attIndex
        console.log(debugText)

        var img = app.attListModel.get(attIndex)
        debugText = '>>>> Attaching image: ' + img + ' >>> ' + img['path']
        console.log(debugText)
        reportFeature.attachments.addAttachment(img['path'], 'image/jpeg', 'Attachment'+(attIndex+1))

        if (app.attListModel.count > attIndex+1) {
            attIndex++
        } else {
            attIndex = -1 //No more
        }
        casesFeatureTable.updateFeature(reportFeature)
    }

    //Enable specific form page objects after validation message is acknowledged
    function enableFormElements(withBusy) {
        debugText = '>>>> In enableFormElements --- '
        console.log(debugText)
        if (withBusy) loadingAnimationFormPage.visible = false
        formPageFooter.enabled = true
        formPageFooter.visible = true
        formPageHeader.enabled = true
        thumbGridView.enabled = true
        typeComboBox.enabled = true
        descriptionField.enabled = true
        cameraIconTemplate.enabled = true
    }

    //Disable form objects when validation is not passed, after submission is attempted
    function disableFormElements(withBusy, hideFooter) {
        debugText = '>>>> In disableFormElements --- '
        console.log(debugText)
        if (withBusy) loadingAnimationFormPage.visible = true
        formPageFooter.enabled = false
        if (hideFooter) formPageFooter.visible = false
        formPageHeader.enabled = false
        thumbGridView.enabled = false
        typeComboBox.enabled = false
        descriptionField.enabled = false
        cameraIconTemplate.enabled = false
    }
}

