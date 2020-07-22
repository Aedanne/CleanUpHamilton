import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import ArcGIS.AppFramework 1.0

Page {
    id:aboutPage
    signal openMenu()

    signal nextPage();
    signal previousPage();

    property string titleText:""
    property var descText
    anchors.fill: HomePage

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

            Item{
                Layout.preferredWidth: 250*app.scaleFactor
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
                    previousPage();
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


}
