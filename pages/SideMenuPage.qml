import QtQuick 2.0

import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

Page{
    id: sideMenuPage
    anchors.fill: parent
    Material.background:app.primaryColor
    topPadding: 75*app.scaleFactor
    leftPadding: 20*app.scaleFactor
    rightPadding: 20*app.scaleFactor
    property ListModel menuModel
    property string newReportText: "New Report (PH?)"

    signal menuSelected(var action)
    signal openSettings()


    ColumnLayout{
        anchors.fill: parent
        spacing: 10*app.scaleFactor

        ListView{
            id: sideMenuListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 1
            clip: true

            model: sideMenuDrawerModel
            delegate:Rectangle{
                height: 56*app.scaleFactor
                width: parent.width

                //Set background color for sidemenu
                color:app.primaryColor

                RowLayout{

                    anchors.fill: parent
                    spacing: 10*app.scaleFactor
                    visible: true

                    Image{
                        Layout.preferredWidth: 25*app.scaleFactor
                        Layout.preferredHeight: 25*app.scaleFactor
                        source: iconSource
                    }
                    Label{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        font.pixelSize: app.baseFontSize*0.5
                        font.bold: true
                        maximumLineCount: 1
                        color: app.menuPrimaryTextColor


                    }
                }

                MouseArea {
                    id: sideMenuMouseArea
                    visible: true
                    enabled: true
                    anchors.centerIn: parent
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        console.log("Menu Item clicked");
                        menuSelected(action);
                    }

                }
            }
        }
    }
}


