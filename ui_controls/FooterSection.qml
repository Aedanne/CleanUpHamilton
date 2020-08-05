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

        property string logMessage;
        property string leftButtonText;
        property string rightButtonText;
        property string overrideRightIconSrc;
        property string overrideLeftIconSrc;
        property string leftButtonBackgroundColor;
        property string rightButtonBackgroundColor;
        property int overrideLeftIconSz: 0;
        property int overrideRightIconSz: 0;

        id: footerRectangle;
        height: app.btnHdrFtrHeightSize*1.1;

        width: parent.width;
        radius: 10;

        //Set background color for button
        //color:app.appBackgroundColor

        //Button row for new report
        RowLayout{

            spacing: 0;
            visible: true;
            anchors.fill: parent;

            //Back button
            CustomImageButton {
                labelText: leftButtonText > "" ? leftButtonText : "BACK";
                logMessage: footerRectangle.logMessage + " BACK Button ";
                imageSource: overrideLeftIconSrc > "" ?  overrideLeftIconSrc : "../images/back.png";
                imageLeft: true;
                imageRight: false;
                previousControl: true;
                nextControl: false;
                backgroundColorOverride: leftButtonBackgroundColor
                overrideLeftSize: overrideLeftIconSz > 0 ? overrideLeftIconSz:0
            }

            //Next button
            CustomImageButton {
                labelText: rightButtonText > "" ? rightButtonText : "NEXT";
                logMessage: footerRectangle.logMessage + " NEXT Button ";
                imageSource: overrideRightIconSrc > "" ? overrideRightIconSrc : "../images/next.png";
                imageLeft: false;
                imageRight: true;
                previousControl: false;
                nextControl: true;
                backgroundColorOverride: rightButtonBackgroundColor
                overrideRightSize: overrideRightIconSz > 0 ? overrideRightIconSz:0
            }
        }
    }
