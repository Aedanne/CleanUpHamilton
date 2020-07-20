import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import ArcGIS.AppFramework 1.0

Page {
    id:page
    signal openMenu()
    property var descText1
    property var descText2
    header: ToolBar {
        contentHeight: 50*app.scaleFactor
        Material.primary: app.primaryColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            //Area for menu button
            Item {
                Layout.preferredWidth: 2*app.scaleFactor
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

            //Area for middle portion of header
            Item{
                Layout.preferredWidth: 100*app.scaleFactor
                Layout.fillHeight: true
            }
        }
    }

    //Main body of home page
    Rectangle{
        anchors.fill: parent
        color: app.appBackgroundColor

        Image {
            opacity: 0.85
            width: parent.width
            height: parent.height
            source: "../images/Hamilton-Lake.jpg"
            fillMode: Image.Stretch
            mipmap: true
        }
        //Homepage title
        Label {
            Material.theme: app.lightTheme? Material.Light : Material.Dark
            anchors.centerIn: parent
            font.pixelSize: app.titleFontSize
            font.bold: true
            style: Text.Raised
            styleColor: app.homePageTitleTextColor
            color: app.primaryColor
            wrapMode: Text.Wrap
            bottomPadding: 220*app.scaleFactor
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
            bottomPadding: 120*app.scaleFactor
            text: descText2
        }
    }

//    OptionsMenuPanel{
//        id:optionsPanel
//        x: page.width-optionsPanel.width-8*app.scaleFactor
//        y: page.y-36*app.scaleFactor
//    }
}
