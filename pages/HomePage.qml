import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.13
import ArcGIS.AppFramework 1.0

import "../ui_controls"
/*
Home page for Clean-Up Hamilton app
*/

Page {

    id:homePage;
    signal openMenu();
    signal nextPage();
    signal previousPage();
    anchors.fill: parent;

    property var descText1;
    property var descText2;
    property var reportButtonText: "File a Report";


    //Header ============================================================================
    header: ToolBar {
        contentHeight: 50*app.scaleFactor;
        Material.primary: app.primaryColor;

        RowLayout {
            anchors.fill: parent;
            spacing: 0;

            //Area for menu button
            Item {
                Layout.preferredWidth: 5;
                Layout.fillHeight: true;
            }
            ToolButton {
                indicator: Image {
                    width: parent.width*0.9;
                    height: parent.height*1.2;
                    anchors.centerIn: parent;
                    source: "../images/menu.png";
                    fillMode: Image.PreserveAspectFit;
                    mipmap: true;
                }
                onClicked: {
                    openMenu();
                }
            }

            //Area for middle portion of header, placeholders
            Item{
                Layout.preferredWidth: 250*app.scaleFactor;
                Layout.fillHeight: true;
            }

            Label {
                id: signInLabel
                Layout.preferredWidth: 250*app.scaleFactor;
                anchors.right: parent.right
                horizontalAlignment: Qt.AlignRight;
                verticalAlignment: Qt.AlignVCenter;
                font.pixelSize: app.headerFontSize;
                font.bold: true;
                wrapMode: Text.Wrap;
                rightPadding: 10*app.scaleFactor;
                text: "Sign In";
                color: app.menuPrimaryTextColor;

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        signInPopup.visible = true;
                    }
                }
            }

            Item{
                Layout.fillHeight: true;
            }
            Item {
                Layout.preferredWidth: 1;
                Layout.fillHeight: true;
            }
        }
    }

    //Main body of home page=============================================================
    Rectangle{
        anchors.fill: parent;
        color: app.appBackgroundColor;

        //Background image for homepage
        Image {
            opacity: 0.85;
            width: parent.width;
            height: parent.height;
            source: "../images/Hamilton-Lake.jpg";
            fillMode: Image.Stretch;
            mipmap: true;
        }

        //Layout for the home page - title, then file report button
        ColumnLayout{
            anchors.fill: parent;
            spacing: 10*app.scaleFactor;

            //Homepage title
            Rectangle {
                Layout.alignment: Qt.AlignCenter;
                height: 20*app.scaleFactor;
                width: parent.width*0.5;

                Label {
                    Material.theme: app.lightTheme? Material.Light : Material.Dark;
                    anchors.centerIn: parent;
                    font.pixelSize: app.titleFontSize;
                    font.bold: true;
                    style: Text.Raised;
                    styleColor: app.homePageTitleTextColor;
                    color: app.primaryColor;
                    wrapMode: Text.Wrap;
                    topPadding: 90*app.scaleFactor;
                    text: descText1;

                }
                Label {
                    Material.theme: app.lightTheme? Material.Light : Material.Dark;
                    anchors.centerIn: parent;
                    font.pixelSize: app.titleFontSize*1.25;
                    font.bold: true;
                    style: Text.Sunken;
                    styleColor: app.homePageTitleTextColor;
                    color: app.primaryColor;
                    wrapMode: Text.Wrap;
                    topPadding: 180*app.scaleFactor;
                    text: descText2;
                }

            }


            //"File a report" button=======================================

            Button {
                id: fileReportButton
                text: ""
                font.bold: true
                font.pixelSize: app.baseFontSize*0.65;
                Layout.alignment: Qt.AlignHCenter

                contentItem: Text {
                    text: fileReportButton.text
                    color: app.menuPrimaryTextColor
                    font.bold: fileReportButton.font.bold
                    font.pixelSize: fileReportButton.font.pixelSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {

                    implicitWidth: 220 * app.scaleFactor
                    implicitHeight: 50 * app.scaleFactor
//                    border.width: 1
//                    border.color: app.mapBorderColor

                    radius: 2
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: fileReportButton.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
                        GradientStop { position: 1 ; color: fileReportButton.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
                    }

                    RowLayout {
                        spacing: 5*app.scaleFactor;
                        visible: true;
                        anchors.centerIn: parent;

                        //padding
                        Item{
                            width: 5;
                        }

                        Image{
                            Layout.preferredWidth: 28*app.scaleFactor;
                            Layout.preferredHeight: 28*app.scaleFactor;
                            source: "../images/add_note.png";

                        }

                        Label{
                            horizontalAlignment: Text.AlignHCenter;
                            text: reportButtonText;
                            font.pixelSize: app.baseFontSize*0.65;
                            font.bold: true;
                            maximumLineCount: 1;
                            color: app.menuPrimaryTextColor;
                        }

                        //padding
                        Item{
                            width: 5;
                        }


                    }
                }

                onClicked: {
                    console.log(">>>> File a Report button clicked from HomePage");
                    nextPage();
                }
            }
        }

        //Default - do not display sign in page
        SignInPopup {
            id: signInPopup
            visible: false
        }

    }




}
