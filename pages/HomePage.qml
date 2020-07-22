import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import ArcGIS.AppFramework 1.0

Page {
    id:homePage
    signal openMenu();
    signal nextPage();
    signal previousPage();
    anchors.fill: parent

    property var descText1
    property var descText2
    property var reportButtonText: "File a Report"

    header: ToolBar {
        contentHeight: 50*app.scaleFactor
        Material.primary: app.primaryColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            //Area for menu button
            Item {
                Layout.preferredWidth: 5
                Layout.fillHeight: true
            }
            ToolButton {
                indicator: Image {
                    width: parent.width*0.9
                    height: parent.height*1.2
                    anchors.centerIn: parent
                    source: "../images/menu.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
                onClicked: {
                    openMenu();
                }
            }

            //Area for middle portion of header, placeholders
            Item{
                Layout.preferredWidth: 250*app.scaleFactor
                Layout.fillHeight: true
            }
            Item{
                Layout.fillHeight: true
            }
            Item {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
            }
        }
    }

    //Main body of home page
    Rectangle{
        anchors.fill: parent
        color: app.appBackgroundColor

        //Background image for homepage
        Image {
            opacity: 0.85
            width: parent.width
            height: parent.height
            source: "../images/Hamilton-Lake.jpg"
            fillMode: Image.Stretch
            mipmap: true
        }

        //Layout for the home page - title, then file report button
        ColumnLayout{
            anchors.fill: parent
            spacing: 10*app.scaleFactor

            //Homepage title
            Rectangle {
                Layout.alignment: Qt.AlignCenter
                height: 20*app.scaleFactor
                width: parent.width*0.5

                Label {
                    Material.theme: app.lightTheme? Material.Light : Material.Dark
                    anchors.centerIn: parent
                    font.pixelSize: app.titleFontSize
                    font.bold: true
                    style: Text.Raised
                    styleColor: app.homePageTitleTextColor
                    color: app.primaryColor
                    wrapMode: Text.Wrap
                    topPadding: 90*app.scaleFactor
                    text: descText1

                }
                Label {
                    Material.theme: app.lightTheme? Material.Light : Material.Dark
                    anchors.centerIn: parent
                    font.pixelSize: app.titleFontSize*1.25
                    font.bold: true
                    style: Text.Sunken
                    styleColor: app.homePageTitleTextColor
                    color: app.primaryColor
                    wrapMode: Text.Wrap
                    topPadding: 180*app.scaleFactor
                    text: descText2
                }

            }



            //"Make a report" button
            Rectangle{
                id: reportRectangle
                height: 50*app.scaleFactor


                Layout.alignment: Qt.AlignHCenter
                width: app.width*0.60
                radius: 5

                //Set background color for button
                color:app.primaryColor

                //Button row for new report
                RowLayout{

                    spacing: 5*app.scaleFactor
                    visible: true
                    anchors.centerIn: parent

                    //padding
                    Item{
                        width: 5
                    }

                    Image{
                        Layout.preferredWidth: 28*app.scaleFactor
                        Layout.preferredHeight: 28*app.scaleFactor
                        source: "../images/add_note.png"

                    }
                    Label{
                        horizontalAlignment: Text.AlignHCenter
                        text: reportButtonText
                        font.pixelSize: app.baseFontSize*0.65
                        font.bold: true
                        maximumLineCount: 1
                        color: app.menuPrimaryTextColor
                    }
                    //padding
                    Item{
                        width: 5
                    }
                }

                MouseArea {
                    id: reportFormButtonMouseArea
                    visible: true
                    enabled: true
                    anchors.centerIn: parent
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        console.log("File a Report button clicked");
                        nextPage();
                    }

                }
            }
        }
    }





}
