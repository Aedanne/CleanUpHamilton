import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ArcGIS.AppFramework 1.0


/*
About page for Clean-Up Hamilton app
*/

Page {

    id:submitPage

    signal nextPage() //go straight to home

    property string titleText:""
    property string descText1: "Thank you "
    property string descText2: "for keeping"
    property string descText3: "Hamilton clean!"
    property string homeButtonText: "Home  "
    anchors.fill: HomePage

    header: ToolBar{
        contentHeight: app.btnHdrFtrHeightSize
        Material.primary: app.primaryColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Label{
                Layout.preferredWidth: 250*app.scaleFactor
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: app.headerFontSize
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

    Rectangle{
        anchors.fill: parent
        color: app.appBackgroundColor

        //Background image for homepage
        Image {
            opacity: 0.55
            width: parent.width
            height: parent.height
            source: "../images/Hamilton-Lake.jpg"
            fillMode: Image.Stretch
            mipmap: true
        }

        ColumnLayout{
            anchors.fill: parent
            spacing: 10*app.scaleFactor

            //Homepage title
            Rectangle {
                Layout.alignment: Qt.AlignCenter
                height: 20*app.scaleFactor
                width: parent.width*0.5

                Label {
                    Material.theme: Material.Light
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
                    Material.theme: Material.Light
                    anchors.centerIn: parent
                    font.pixelSize: app.titleFontSize
                    font.bold: true
                    style: Text.Sunken
                    styleColor: app.homePageTitleTextColor
                    color: app.primaryColor
                    wrapMode: Text.Wrap
                    topPadding: 180*app.scaleFactor
                    text: descText2
                }
                Label {
                    Material.theme: Material.Light
                    anchors.centerIn: parent
                    font.pixelSize: app.titleFontSize
                    font.bold: true
                    style: Text.Sunken
                    styleColor: app.homePageTitleTextColor
                    color: app.primaryColor
                    wrapMode: Text.Wrap
                    topPadding: 270*app.scaleFactor
                    text: descText3
                }

            }


            //"Back to home" button=======================================
            Button {
                id: homeButton
                text: ""
                font.bold: true
                font.pixelSize: app.baseFontSize*0.65
                Layout.alignment: Qt.AlignHCenter

                contentItem: Text {
                    text: homeButton.text
                    color: app.menuPrimaryTextColor
                    font.bold: homeButton.font.bold
                    font.pixelSize: homeButton.font.pixelSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {

                    implicitWidth: 180 * app.scaleFactor
                    implicitHeight: 50 * app.scaleFactor

                    radius: 2
                    gradient: Gradient {
                        GradientStop { position: 0;  color: homeButton.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
                        GradientStop { position: 1;  color: homeButton.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
                    }

                    RowLayout {
                        spacing: 5*app.scaleFactor
                        visible: true
                        anchors.centerIn: parent

                        //padding
                        Item{
                            width: 5
                        }

                        Image{
                            Layout.preferredWidth: 45*app.scaleFactor
                            Layout.preferredHeight: 45*app.scaleFactor
                            source: "../images/home.png"

                        }

                        Label{
                            horizontalAlignment: Text.AlignHCenter
                            text: homeButtonText
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
                }

                onClicked: {
                    console.log(">>>> File a Report button clicked from HomePage")
                    nextPage()
                }
            }
        }
    }
}
