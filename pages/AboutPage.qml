import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ArcGIS.AppFramework 1.0


/*
About page for Clean-Up Hamilton app
*/

Page {
    id:aboutPage

    signal nextPage()
    signal previousPage()

    property string titleText:''
    property var descText
    property var descText1

    //Custom header for About page  - no footer here
    header: ToolBar{
        contentHeight: app.btnHdrFtrHeightSize
        Material.primary: app.primaryColor

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Label {
                Layout.preferredWidth: 250*app.scaleFactor
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: app.headerFontSize
                font.bold: true
                wrapMode: Text.Wrap
                leftPadding: 10*app.scaleFactor
                text: titleText > ''? titleText:''
                color: app.menuPrimaryTextColor
            }

            ToolButton {

                indicator: Image{
                    width: (parent.width*0.5)*(1.25*app.scaleFactor)
                    height: (parent.height*0.5)*(1.25*app.scaleFactor)

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        margins: 2*app.scaleFactor
                    }

                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    source: '../images/clear.png'
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }

                onClicked: {
                    previousPage()
                }
            }

            Item {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: app.appBackgroundColor
        radius: 3

        Rectangle {
            anchors.centerIn: parent
            color: app.appBackgroundColor
            width: parent.width*0.80
            height: parent.height*0.90
            id: topSection

            ColumnLayout {
                spacing: 0
                Layout.alignment: Qt.AlignRight | Qt.AlignTop

                Label {
                    font.pixelSize: app.baseFontSize*.4
                    text: 'Clean-Up Hamilton  '
                    color: app.appPrimaryTextColor
                    wrapMode: Text.Wrap
                    bottomPadding: 5 * app.scaleFactor
                    font.bold: true
                }

                Label {
                    font.pixelSize: app.baseFontSize*.3
                    text: 'Author: Charisse Hanson'
                    color: app.appPrimaryTextColor
                    wrapMode: Text.Wrap
                    bottomPadding: 5 * app.scaleFactor
                    font.bold: true
                }

                Label {
                    font.pixelSize: app.baseFontSize*.3
                    text: descText1
                    color: app.appPrimaryTextColor
                    wrapMode: Text.Wrap
                    bottomPadding: 15 * app.scaleFactor
                    font.bold: true
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: 'This is a mobile application project that will leverage crowd-sourced data and GIS technology for the purpose of keeping Hamilton, NZ clean and beautiful. This project will make use of ESRI ArcGIS solutions.'
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                    bottomPadding: 10 * app.scaleFactor
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: 'This project will have 2 main components:'
                    enabled: false
                    background: null
                    font.underline: true
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: '(1) Public reporting feature of graffiti, broken items, illegal rubbish dumping and other cases cases'
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                    leftPadding: 15*app.scaleFactor
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: '(2) City council staff workflow for assigning and working the cases'
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                    bottomPadding: 10 * app.scaleFactor
                    leftPadding: 15*app.scaleFactor
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: 'Technologies used:'
                    enabled: false
                    background: null
                    font.underline: true
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: 'Qt/QML, JavaScript, ArcGIS Framework Library, ArcGIS Runtime Library, ArcGIS Online Platform, Android Device (Camera), ArcGIS REST, ArcGIS AppStudio'
                    enabled: false
                    background: null
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                    bottomPadding: 25 * app.scaleFactor
                    leftPadding: 15*app.scaleFactor
                }

                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: app.appBorderColorCaseList
                }
                //Separator
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 5*app.scaleFactor
                    color: 'transparent'
                }

                TextArea {
                    Material.accent: app.appBackgroundColor
                    selectByMouse: true
                    wrapMode: TextEdit.WordWrap
                    color: app.appSecondaryTextColor
                    text: 'This project was developed in partial fulfillment of the Master of Information Technology qualification, in the University of Waikato. \n\nThis project is in direct fulfillment of COMPX576 Programming for Research II academic requirements.  '
                    enabled: false
                    background: null
                    font.italic: true
                    font.pixelSize: app.baseFontSize*.3
                    Layout.preferredWidth: topSection.width
                }
            }
        }
    }
}
