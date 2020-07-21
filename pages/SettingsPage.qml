import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import ArcGIS.AppFramework 1.0


import QtQuick 2.0

import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13



Page {
    id:settingsPage
    signal openMenu()
    property string titleText:""
    property var descText
    width: parent.width * 0.70

    header: ToolBar{

        contentHeight: 50*app.scaleFactor
        Material.primary: app.primaryColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.preferredWidth: 6
                Layout.fillHeight: true
            }

            ToolButton {
                indicator: Image{
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
            Item{
                Layout.minimumWidth: 250*app.scaleFactor
                Layout.fillHeight: true
            }

            ToolButton {

                indicator: Image{
                    width: parent.width*0.9
                    height: parent.height*1.2
                    anchors.centerIn: parent
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    source: "../images/clear.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
                onClicked: {
                    loader.sourceComponent = homePageComponent;
                }
            }
            Item {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        color: app.appBackgroundColor

        Label{
            Material.theme: app.lightTheme? Material.Light : Material.Dark
            anchors.centerIn: parent
            font.pixelSize: app.titleFontSize
            font.bold: true
            wrapMode: Text.Wrap
            padding: 16*app.scaleFactor
            text: descText > ""? descText:""
        }
    }

//    OptionsMenuPanel{
//        id:optionsPanel
//        x: page.width-optionsPanel.width-8*app.scaleFactor
//        y: page.y-36*app.scaleFactor
//    }
}
