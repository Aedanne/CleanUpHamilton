import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Styles 1.4
import ArcGIS.AppFramework 1.0

/*
HeaderSection QML Type to simplify adding footer to the pages
*/

ToolBar{

    property string logMessage

    contentHeight: app.btnHdrFtrHeightSize
    Material.primary: app.primaryColor

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.preferredWidth: 2
            Layout.fillHeight: true
        }

        Label{
            Layout.preferredWidth: 250*app.scaleFactor
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: app.headerFontSize
            font.bold: true
            leftPadding: 10*app.scaleFactor
            text: titleText > ""? titleText:""
            color: app.menuPrimaryTextColor
        }

        ToolButton {
            indicator: Image{
                width: parent.width*0.7
                height: parent.height*0.7
                anchors.centerIn: parent
                source: "../images/help.png"
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }

            onClicked: {
                console.log(logMessage);
            }
        }
    }
}
