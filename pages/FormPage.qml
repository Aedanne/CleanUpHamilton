import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Styles 1.4
import ArcGIS.AppFramework 1.0

import "../ui_controls"

Page {
    id:formPage
    anchors.fill: parent

    signal nextPage();
    signal previousPage();

    property string titleText:""
    property var descText


    //Header custom QML =================================================================
    header: HeaderSection {
        logMessage: "TODO: FORM PAGE INFO PAGE"
    }


    //Main body of the page =============================================================
    Rectangle{
        anchors.fill: parent
        color: app.appBackgroundColor
        width: parent.width*0.75
        Layout.alignment: Qt.AlignCenter

        Label{
            Material.theme: app.lightTheme? Material.Light : Material.Dark
            anchors.centerIn: parent
            font.pixelSize: app.titleFontSize
            font.bold: true
            wrapMode: Text.Wrap
            padding: 16*app.scaleFactor
            text: descText > ""? descText:""
            leftPadding: 100
        }
    }


    //Footer custom QML =================================================================
    footer: FooterSection {}

}

