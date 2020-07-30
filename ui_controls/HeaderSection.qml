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

    property string logMessage;
    property string backgroundColor: app.primaryColor

    contentHeight: app.btnHdrFtrHeightSize;
    Material.primary: backgroundColor;

    RowLayout {
        anchors.fill: parent;
        spacing: 0;

        Item {
            Layout.preferredWidth: 2;
            Layout.fillHeight: true;
        }

        Label {
            Layout.preferredWidth: 250*app.scaleFactor;
            horizontalAlignment: Qt.AlignLeft;
            verticalAlignment: Qt.AlignVCenter;
            font.pixelSize: app.headerFontSize;
            font.bold: true;
            leftPadding: 10*app.scaleFactor;
            text: titleText > ""? titleText:"";
            color: app.menuPrimaryTextColor;
        }

        ToolButton {
            indicator: Image{
                width: (parent.width*0.5)*(1.25*app.scaleFactor);
                height: (parent.height*0.5)*(1.25*app.scaleFactor);
                anchors {
                    verticalCenter: parent.verticalCenter;
                    right: parent.right;
                    margins: 2*app.scaleFactor;
                }

                source: "../images/help.png";
                fillMode: Image.PreserveAspectFit;
                mipmap: true;
            }

            onClicked: {
                console.log(logMessage);
            }
        }
    }
}
