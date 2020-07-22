import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Styles 1.4
import ArcGIS.AppFramework 1.0

Page {
    id:formPage
    anchors.fill: parent

    signal nextPage();
    signal previousPage();

    property string titleText:""
    property var descText

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

//            ToolButton {
//                indicator: Image{
//                    width: parent.width*0.9
//                    height: parent.height*1.2
//                    anchors.centerIn: parent
//                    source: "../images/back.png"
//                    fillMode: Image.PreserveAspectFit
//                    mipmap: true
//                }
//                //Go back to home page when hit back here
//                onClicked: {
//                    previousPage();
//                }
//            }

            Label{
                Layout.preferredWidth: 250*app.scaleFactor
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: app.baseFontSize*0.70
                font.bold: true
                wrapMode: Text.Wrap
                leftPadding: 10*app.scaleFactor
                text: titleText > ""? titleText:""
                color: app.menuPrimaryTextColor
            }

            Item {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
            }
        }
    }

//    //Main body of the page
//    Rectangle{
//        anchors.fill: parent
//        color: app.appBackgroundColor
//        width: parent.width*0.75
//        Layout.alignment: Qt.AlignCenter

//        Label{
//            Material.theme: app.lightTheme? Material.Light : Material.Dark
//            anchors.centerIn: parent
//            font.pixelSize: app.titleFontSize
//            font.bold: true
//            wrapMode: Text.Wrap
//            padding: 16*app.scaleFactor
//            text: descText > ""? descText:""
//            leftPadding: 100
//        }
//    }


    footer: Rectangle{
        id: reportRectangle
        height: 50*app.scaleFactor

        width: parent.width
        radius: 10

        //Set background color for button
        color:app.appBackgroundColor

        //Button row for new report
        RowLayout{

            spacing: 0
            visible: true
            anchors.fill: parent

            Button {
                id: backButton
                text: qsTr("Back")
                width: parent.width*.5


                contentItem: Item{

                    RowLayout{
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image{
                            Layout.preferredWidth: 35*app.scaleFactor
                            Layout.preferredHeight: 35*app.scaleFactor
                            source: "../images/back.png"
                        }
                        Text {
                            text: backButton.text
                            font.pointSize: app.baseFontSize*.5
                            font.bold: true
                            color: app.menuPrimaryTextColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                background: Rectangle {
                    implicitWidth: app.width*.5
                    implicitHeight: reportRectangle.height
                    opacity: enabled ? 1 : 0.3
                    border.color: app.appBackgroundColor
                    border.width: 1
                    color: app.primaryColor
                    radius: 5
                }

                onClicked: {
                    console.log("In setlocationpage > back button clicked")
                    previousPage();
                }
            }

            Button {
                id: nextButton
                text: qsTr("Next")
                width: parent.width*.5


                contentItem: Item{

                    RowLayout{
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            text: nextButton.text
                            font.pointSize: app.baseFontSize*.5
                            font.bold: true
                            color: app.menuPrimaryTextColor
                        }
                        Image{
                            Layout.preferredWidth: 35*app.scaleFactor
                            Layout.preferredHeight: 35*app.scaleFactor
                            source: "../images/next.png"
                        }
                    }
                }

                background: Rectangle {
                    implicitWidth: app.width*.5
                    implicitHeight: reportRectangle.height
                    opacity: enabled ? 1 : 0.3
                    border.color: app.appBackgroundColor
                    border.width: 1
                    color: app.primaryColor
                    radius: 5
                }

                onClicked: {
                    console.log("In setLocation page > next button clicked")
                    nextPage();
                }
            }
        }

    }




}
