import QtQuick 2.7
import QtQuick.Layouts 1.1
import ArcGIS.AppFramework 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: root

    property bool isDebug: false
    property int imageSize: 42*AppFramework.displayScaleFactor
    property int containerSize: 40*AppFramework.displayScaleFactor
    property int sidePadding: 0
    property url imageSource: ""
    property color backgroundColor: "transparent"
    property color iconOverlayColor: "white"
    property bool enabled: true
    signal iconClicked()

    width: containerSize + sidePadding
    height: containerSize
    Layout.preferredWidth: containerSize*1.3
    Layout.preferredHeight: containerSize*1.2
    color: backgroundColor
    radius: 4*AppFramework.displayScaleFactor

    border.width: isDebug

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
        color: iconOverlayColor
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: {
            iconClicked();
        }
    }

}
