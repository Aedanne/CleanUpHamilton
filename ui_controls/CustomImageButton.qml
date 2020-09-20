import QtQuick 2.7
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

/*
CustomImageButtom QML Type to simplify adding images to the pages
To have consistent button styling
*/

Button {

    //Cutom button properties
    property string labelText;
    property string logMessage;
    property string imageSource;
    property string actionString;
    property bool imageLeft;
    property bool imageRight;
    property bool previousControl;
    property bool nextControl;
    property string backgroundColor: app.primaryColor
    property string backgroundColorOverride;
    property var btnWidth;
    property var btnHeight;
    property string btnColor;
    property int overrideRightSize;
    property int overrideLeftSize;
    property int unitVal: 28;

    id: btn;
    width: btnWidth > "" ? btnWidth : parent.width*.5;
    height: btnHeight > "" ? btnHeight : app.btnHdrFtrHeightSize*1.1;

//    anchors.horizontalCenter: parent.horizontalCenter;
//            anchors.verticalCenter: parent.verticalCenter;


    contentItem: Item{

        RowLayout{
//            anchors.horizontalCenter: parent.horizontalCenter;
//            anchors.verticalCenter: parent.verticalCenter;
            anchors.centerIn: parent;

            Image{
                Layout.preferredWidth: (btn.imageLeft === true? (overrideLeftSize>0?overrideLeftSize:unitVal)*app.scaleFactor: 0);
                Layout.preferredHeight: (btn.imageLeft === true? (overrideLeftSize>0?overrideLeftSize:unitVal)*app.scaleFactor: 0);
                source: btn.imageSource;
                visible: btn.imageLeft === true;
                enabled: btn.imageLeft === true;
                fillMode: Image.PreserveAspectCrop

//                verticalAlignment: parent.verticalCenter;
//                anchors.verticalCenter: parent.verticalCenter;
//                verticalAlignment: btn.verticalCenter;
            }


            Text {
                text: btn.labelText;
                font.pixelSize: app.headerFontSize ;
                font.bold: true;
                color: app.menuPrimaryTextColor;
//                horizontalAlignment: Text.AlignHCenter;
//                verticalAlignment: Text.AlignVCenter;
            }
            Image{
                Layout.preferredWidth: (btn.imageRight === true? (overrideRightSize>0?overrideRightSize:unitVal)*app.scaleFactor: 0);
                Layout.preferredHeight: (btn.imageRight === true? (overrideRightSize>0?overrideRightSize:unitVal)*app.scaleFactor: 0);
                source: btn.imageSource;
                visible: btn.imageRight === true;
                enabled: btn.imageRight === true;
                fillMode: Image.PreserveAspectCrop

//                verticalAlignment: parent.verticalCenter;
//                anchors.verticalCenter: parent.verticalCenter;
            }
        }
    }

    background: Rectangle {
//        anchors.centerIn: parent
        implicitWidth: app.width*.49;
        implicitHeight: app.btnHdrFtrHeightSize*0.9;
        opacity: enabled ? 1 : 0.3;
//        border.color: app.appBackgroundColor;
//        border.width: 3;
        color: backgroundColor;
        radius: 2;

        gradient: Gradient {
            GradientStop { position: 0 ; color: btn.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
            GradientStop { position: 1 ; color: btn.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
        }

    }

    onClicked: {
        console.log(btn.logMessage);

       if (btn.previousControl) {

           previousPage();
       }

       if (btn.nextControl) {
           console.log("\n>>>>> btn.nextControl : labelTxt", btn.labelText, "  actionstring", btn.actionString)

           if (btn.labelText === "SUBMIT") {
               if (app.reportTypeIndex !== -1 && app.attListModel.count > 0) {
                   formPage.submitReportData();
               } else {
                   formMissingData.visible = true;
                   disableFormElements(false, false);
                   return;
               }
           } else {
               if (btn.actionString === 'CaseEditSave') {
                   if (reportedCaseformPage.localWorkerNote === '') {
                       caseFormMissingData.visible = true
                   } else {
                       console.log("\n>>>>> ReportedCaseFormPage-Save - actionString === 'CaseEditSave'")
                       reportedCaseformPage.updateFeatureSave()
                   }



               } else {

                   nextPage();
               }
           }



       }
    }
}
