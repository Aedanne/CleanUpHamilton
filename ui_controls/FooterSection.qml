import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4
import ArcGIS.AppFramework 1.0

/*
FooterSection QML Type to simplify adding footer to the pages
*/

Rectangle{

        property string logMessage
        property string leftButtonText
        property string rightButtonText
        property string overrideRightIconSrc
        property string overrideLeftIconSrc
        property string leftButtonBackgroundColor
        property string rightButtonBackgroundColor
        property int overrideLeftIconSz: 0
        property int overrideRightIconSz: 0
        property string footerActionString

        id: footerRectangle
        height: app.btnHdrFtrHeightSize*1.1

        width: parent.width
        radius: 10

        anchors.horizontalCenter: parent.horizontalCenter

        //Button row for new report
        RowLayout{

            spacing: 2
            visible: true
            anchors.fill: parent
            anchors.centerIn: parent
            anchors.margins: 2*app.scaleFactor

            //Back button
            CustomImageButton {
                labelText: leftButtonText > "" ? leftButtonText : "BACK"
                logMessage: footerRectangle.logMessage + " BACK Button "
                imageSource: overrideLeftIconSrc > "" ?  overrideLeftIconSrc : "../images/back.png"
                imageLeft: true
                imageRight: false
                previousControl: true
                nextControl: false
                backgroundColorOverride: leftButtonBackgroundColor
                overrideLeftSize: overrideLeftIconSz > 0 ? overrideLeftIconSz:0
            }

            //Next button
            CustomImageButton {
                labelText: rightButtonText > "" ? rightButtonText : "NEXT"
                logMessage: footerRectangle.logMessage + " NEXT Button "
                imageSource: overrideRightIconSrc > "" ? overrideRightIconSrc : "../images/next.png"
                imageLeft: false
                imageRight: true
                previousControl: false
                nextControl: true
                backgroundColorOverride: rightButtonBackgroundColor
                overrideRightSize: overrideRightIconSz > 0 ? overrideRightIconSz:0
                actionString: footerActionString
            }
        }
    }
