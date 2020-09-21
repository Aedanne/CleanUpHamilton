import QtQuick 2.7
import QtQuick.Layouts 1.1
import ArcGIS.AppFramework 1.0
import QtGraphicalEffects 1.0

/*
ImageIconTemplate QML Type to simplify adding icons using images
*/

Rectangle {
    id: root
    property string imgSource: ""
    signal imageIconClicked();

    anchors.centerIn: parent
    width: 60*app.scaleFactor
    height: 60*app.scaleFactor
    color: "transparent"
    radius: 2
    border.color: "#80cccccc"
    border.width: 1*app.scaleFactor

    Image {
        id: imageIcon
        source: imgSource
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        autoTransform: true
        visible: true
        cache: false
        sourceSize.width: width*0.9
        sourceSize.height: height

    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: {
            imageIconClicked();
        }
    }

}
