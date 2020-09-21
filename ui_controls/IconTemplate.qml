import QtQuick 2.7
import QtQuick.Layouts 1.1
import ArcGIS.AppFramework 1.0
import QtGraphicalEffects 1.0

/*
IconTemplate QML Type to simplify creating icons for application
*/

Rectangle {
    id: root

    property int imageSize: 42*app.scaleFactor
    property int containerSize: 40*app.scaleFactor
    property int sidePadding: 0
    property url imageSource: ""
    property color backgroundColor: "transparent"
    property color iconOverlayColor: "white"
    property bool enabled: true
    signal iconClicked()
    property bool maxAttach;
    property int imgRadius: 0

    width: containerSize + sidePadding
    height: containerSize
    Layout.preferredWidth: containerSize*1.3
    Layout.preferredHeight: containerSize*1.2
    color: backgroundColor
    radius: imgRadius === 0 ? 4*app.scaleFactor : imgRadius

    border.width: 0

    Image {
        id: iconImg
        width: imageSize
        height: imageSize
        anchors.centerIn: parent
        source: imageSource
        asynchronous: true
        smooth: true
        mipmap: true
        fillMode: Image.PreserveAspectCrop

    }

    ColorOverlay{
        anchors.fill: iconImg
        source: iconImg
        color: maxAttach ? Qt.lighter(iconOverlayColor, 0.5) : iconOverlayColor
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: {
            iconClicked();
        }
    }

}
