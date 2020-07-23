import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Styles 1.4
import ArcGIS.AppFramework 1.0

/*
FooterSection QML Type to simplify adding footer to the pages
*/

Rectangle{

        property string logMessage;

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
                labelText: "Back";
                logMessage: footerRectangle.logMessage + " BACK Button ";
                imageSource: "../images/back.png";
                imageLeft: true;
                imageRight: false;
                previousControl: true;
                nextControl: false;
            }

            //Next button
            CustomImageButton {
                labelText: "Next";
                logMessage: footerRectangle.logMessage + " NEXT Button ";
                imageSource: "../images/next.png";
                imageLeft: false;
                imageRight: true;
                previousControl: false;
                nextControl: true;
            }
        }
    }
