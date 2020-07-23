import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Styles 1.4

/*
CustomImageButtom QML Type to simplify adding images to the pages
To have consistent button styling
*/

Button {

    //Cutom button properties
    property string labelText
    property string logMessage
    property string imageSource
    property bool imageLeft
    property bool imageRight
    property bool previousControl
    property bool nextControl

    id: btn
    width: parent.width*.5
    height: app.btnHdrFtrHeightSize*1.2


    contentItem: Item{

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Image{
                Layout.preferredWidth: (btn.imageLeft === true? 35*app.scaleFactor: 0)
                Layout.preferredHeight: (btn.imageLeft === true? 35*app.scaleFactor: 0)
                source: btn.imageSource
                visible: btn.imageLeft === true
                enabled: btn.imageLeft === true
            }
            Text {
                text: btn.labelText
                font.pixelSize: app.headerFontSize
                font.bold: true
                color: app.menuPrimaryTextColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Image{
                Layout.preferredWidth: (btn.imageRight === true? 35*app.scaleFactor: 0)
                Layout.preferredHeight: (btn.imageRight === true? 35*app.scaleFactor: 0)
                source: btn.imageSource
                visible: btn.imageRight === true
                enabled: btn.imageRight === true
            }
        }
    }

    background: Rectangle {
        implicitWidth: app.width*.5
        implicitHeight: app.btnHdrFtrHeightSize
        opacity: enabled ? 1 : 0.3
        border.color: app.appBackgroundColor
        border.width: 3
        color: app.primaryColor
        radius: 5
    }

    onClicked: {
        console.log(btn.logMessage)

       if (btn.previousControl) previousPage();

       if (btn.nextControl) nextPage();
    }
}
