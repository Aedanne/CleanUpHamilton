import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.13

/*
Side Menu page for Clean-Up Hamilton app
*/

Page{

    id: sideMenuPage;
    anchors.fill: parent;
    Material.background:app.primaryColor;
    topPadding: 125*app.scaleFactor;
    leftPadding: 20*app.scaleFactor;
    rightPadding: 20*app.scaleFactor;
    property ListModel menuModel;

    signal menuSelected(var action);
//    signal openSettings()


    ColumnLayout{
        anchors.fill: parent;
        spacing: 10*app.scaleFactor;

        ListView{
            id: sideMenuListView;
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            spacing: 1;
            clip: true;

            model: sideMenuDrawerModel;
            delegate:Rectangle{
                height: 56*app.scaleFactor;
                width: parent.width;

                //Set background color for sidemenu
                color:app.primaryColor;


                RowLayout{

                    anchors.fill: parent;
                    spacing: 7*app.scaleFactor;
                    visible: (name === "divider"? false:true);
                    enabled: (name === "divider"? false:true);


                    Image{
                        Layout.preferredWidth: (name === "divider"? 1: 25*app.scaleFactor);
                        Layout.preferredHeight: (name === "divider"? 1: 25*app.scaleFactor);
                        source: iconSource;
                        visible: (name === "divider"? false:true);
                    }
                    Label{
                        Layout.fillWidth: (name === "divider"? false:true);
                        Layout.fillHeight: (name === "divider"? false:true);
                        verticalAlignment: Text.AlignVCenter;
                        text: (name === "divider"? "": name);
                        font.pixelSize: app.baseFontSize*0.5;
                        font.bold: true;
                        maximumLineCount: 1;
                        color: app.menuPrimaryTextColor;
                        visible: (name === "divider"? false:true);

                    }
                }

                //Divider areas
//                Item{
//                    anchors.fill: parent
//                    visible: name === "divider"
//                    Rectangle{
//                        width: parent.width
//                        height: 10*app.scaleFactor
//                        color: app.menuPrimaryTextColor
//                    }
//                }
                Item{
                    anchors.fill: parent;
                    visible: name === "divider";
                    Rectangle{
                        width: parent.width;
                        height: 2*app.scaleFactor;
                        color: app.menuPrimaryTextColor;
                    }
                }

                MouseArea {
                    id: sideMenuMouseArea;
                    visible: (name === "divider"? false:true);
                    enabled: (name === "divider"? false:true);
                    anchors.centerIn: parent;
                    hoverEnabled: true;
                    anchors.fill: parent;
                    onClicked: {
                        console.log(">>>> Menu Item clicked");
                        menuSelected(action);
                    }
                }
            }
        }
    }
}


