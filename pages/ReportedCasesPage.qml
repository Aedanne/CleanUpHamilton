import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ArcGIS.AppFramework 1.0


/*
Placeholder page for staff workflow
*/


Page {

    id:reportedCasesPage;

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;
//    width: parent.width * 0.70;
    anchors.fill: parent;

    header: ToolBar{

        contentHeight: app.btnHdrFtrHeightSize;
        Material.primary: app.primaryColor;

        RowLayout {
            anchors.fill: parent;
            spacing: 0;

            Label{
                Layout.preferredWidth: 250*app.scaleFactor;
                horizontalAlignment: Qt.AlignLeft;
                verticalAlignment: Qt.AlignVCenter;
                font.pixelSize: app.headerFontSize;
                font.bold: true;
                wrapMode: Text.Wrap;
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
                    horizontalAlignment: Qt.AlignRight;
                    verticalAlignment: Qt.AlignVCenter;
                    source: "../images/clear.png";
                    fillMode: Image.PreserveAspectFit;
                    mipmap: true;
                }
                onClicked: {
                    previousPage();
                }
            }
            Item {
                Layout.preferredWidth: 1;
                Layout.fillHeight: true;
            }
        }
    }

    Rectangle{
        anchors.fill: parent;
        color: app.appBackgroundColor;

        Label{
            Material.theme: app.lightTheme? Material.Light : Material.Dark;
            anchors.centerIn: parent;
            font.pixelSize: app.titleFontSize*0.5;
            font.bold: true;
            wrapMode: Text.Wrap;
            padding: 16*app.scaleFactor;
            text: descText > ""? descText:"";
        }
    }
}
