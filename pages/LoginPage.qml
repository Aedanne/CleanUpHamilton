import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.13

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.7
import Esri.ArcGISRuntime.Toolkit.Controls 100.7
import Esri.ArcGISRuntime.Toolkit.Dialogs 100.1

import "../ui_controls"

/*
Login page for Clean-Up Hamilton app
*/

Page {

    id:loginPage;

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;

//    anchors.fill: HomePage;

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
                    if (portal.loadStatus === Enums.LoadStatusLoading) {
                        console.log(">>>> Cancelling login from x button")
                        portal.cancelLoad();

                    } else {
                        portal = null;
                    }

                    previousPage();
                }
            }

            Item {
                Layout.preferredWidth: 1;
                Layout.fillHeight: true;
            }
        }
    }

    Credential {
        id: credPort
        oAuthClientInfo: OAuthClientInfo {
            oAuthMode: Enums.OAuthModeUser
            clientId: app.cleanUpHamiltonClientId
        }
    }

    contentItem: Item {
        id: root
        width: parent.width
        height: parent.height
//        anchors.fill: parent


        BusyIndicator {
            id: busy
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.centerIn: parent
            anchors.topMargin: 200*app.scaleFactor
            Material.accent: app.primaryColor
            running: portal.loadStatus !== Enums.LoadStatusLoaded
        }

        Label {
            Material.theme: app.lightTheme? Material.Light : Material.Dark;
            anchors.bottom: busy.top
            font.pixelSize: app.baseFontSize*0.5;
            anchors.horizontalCenter: parent.horizontalCenter
            color: app.primaryColor;
            font.bold: true
            wrapMode: Text.Wrap;
            bottomPadding: 25*app.scaleFactor;
            text: "Connecting to ArcGIS Portal..."
         }

        Portal {
            id: portal
            credential: credPort

            Component.onCompleted: {
                load();
                console.log(">>>> fetchLicenseInfo(): ", fetchLicenseInfo());
                if (!app.authenticated) {
                    console.log(">>>> PortalUser: ", app.portalUser);
                    console.log(">>>> Portal: Cancel and retry load -- force to login every time ");
//                    if (loadStatus === Enums.LoadStatusLoading) {
//                        cancelLoad();

//                    } else if (loadStatus === Enums.LoadStatusLoaded) {
//                        destroyed();
//                    }
                    cancelLoad();
                    retryLoad();
                }

            }

            onLoadStatusChanged: {
                if (loadStatus === Enums.LoadStatusFailedToLoad) {
                    retryLoad();
                } else if (loadStatus === Enums.LoadStatusLoaded) {
                    app.authenticated = true;
                    app.portalUser = portalUser.username;
                    app.agolPortal = portal

                    console.log(">>>> PORTAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                    console.log(">>>> PORTAL AUTHENTICATED: " + app.authenticated)
                    console.log(">>>> PORTALUSER.FULLNAME: " + portalUser.fullName)
                    console.log(">>>> PORTALUSER.ROLE: " + portalUser.role)
                    console.log(">>>> PORTALUSER.USERNAME: " + app.portalUser)


                    previousPage();
                }
            }

            onLoadErrorChanged: {
                if (error != null && error.message != null)
                    console.log(">>>> onLoadErrorChanged @ Portal Load: ", error.message);
                retryLoad();
            }

            onErrorChanged: {
                if (loadStatus === Enums.LoadStatusFailedToLoad) {
                    console.log(">>>> Error @ Portal Load: ", error.message);
                }
            }

        }

        AuthenticationView {
            id: authView
            authenticationManager: AuthenticationManager
        }

    }


}

