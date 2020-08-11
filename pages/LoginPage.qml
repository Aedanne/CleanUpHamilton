import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.13


/*
Login page for Clean-Up Hamilton app
*/

Page {

    id:loginPage;
    signal openMenu();

    signal nextPage();
    signal previousPage();

    property string titleText:"";
    property var descText;

    property var authChallenge;

    anchors.fill: HomePage;

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

//            ToolButton {
//                indicator: Image{
//                    width: (parent.width*0.5)*(1.25*app.scaleFactor);
//                    height: (parent.height*0.5)*(1.25*app.scaleFactor);
//                    anchors {
//                        verticalCenter: parent.verticalCenter;
//                        right: parent.right;
//                        margins: 2*app.scaleFactor;
//                    }
//                    horizontalAlignment: Qt.AlignRight;
//                    verticalAlignment: Qt.AlignVCenter;
//                    source: "../images/clear.png";
//                    fillMode: Image.PreserveAspectFit;
//                    mipmap: true;
//                }
//                onClicked: {
//                    previousPage();
//                }
//            }
            Item {
                Layout.preferredWidth: 1;
                Layout.fillHeight: true;
            }
        }
    }

    contentItem: Item {
        id: root
        width: parent.width
        height: parent.height
        anchors.fill: parent

        property var authChallenge; //Authentication Challenge

        Rectangle {
            width: 150*app.scaleFactor
            height: 150*app.scaleFactor

            anchors.fill: parent
            color: app.appBackgroundColor

            Label {
                id: displayLabel
                Material.theme: app.lightTheme? Material.Light : Material.Dark;
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: app.baseFontSize*0.4;
                color: app.primaryColor;
                font.bold: true
                wrapMode: Text.Wrap;
                topPadding: 150*app.scaleFactor;
                text: "Authentication Required";
            }

            Label {
                id: hostLabel
                Material.theme: app.lightTheme? Material.Light : Material.Dark;
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: app.baseFontSize*0.5;
                anchors.top: displayLabel.bottom
                anchors.topMargin: 5*app.scaleFactor;
                color: app.primaryColor;
                font.bold: true
                wrapMode: Text.Wrap;
                text: "waikato.maps.arcgis.com";
            }

            TextField {
                id: usernameTextField
                width: 230 * app.scaleFactor
                placeholderText: qsTr("Username")
                anchors.top: hostLabel.bottom
                anchors.topMargin: 25*app.scaleFactor;
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: passwordTextField
                width: 230 * app.scaleFactor
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                anchors.top: usernameTextField.bottom
                anchors.topMargin: 5*app.scaleFactor;
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RowLayout {
                spacing: 20 * app.scaleFactor
                anchors.top: passwordTextField.bottom
                anchors.topMargin: 15*app.scaleFactor;
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: cancelButton
                    text: qsTr("CANCEL")
                    font.bold: true
                    font.pixelSize: app.baseFontSize*0.4;

                    contentItem: Text {
                        text: cancelButton.text
                        color: app.menuPrimaryTextColor
                        font.bold: cancelButton.font.bold
                        font.pixelSize: cancelButton.font.pixelSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        implicitWidth: 105 * app.scaleFactor
                        implicitHeight: 25 * app.scaleFactor
    //                    border.width: 1
    //                    border.color: app.mapBorderColor

                        radius: 2
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: cancelButton.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
                            GradientStop { position: 1 ; color: cancelButton.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
                        }
                   }

                    onClicked: {
                        // cancel the authentication challenge and let the resource fail to load
                        if (authChallenge) authChallenge.cancel();
//                        root.visible = false;

                        previousPage();
                    }
                }

                Button {
                    id: signInButton
                    text: qsTr("SIGN IN")
                    font.bold: true
                    font.pixelSize: app.baseFontSize*0.4;

                    contentItem: Text {
                        text: signInButton.text
                        color: app.menuPrimaryTextColor
                        font.bold: signInButton.font.bold
                        font.pixelSize: signInButton.font.pixelSize
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        implicitWidth: 105 * app.scaleFactor
                        implicitHeight: 25 * app.scaleFactor
                        border.width: 1
    //                    border.color: app.mapBorderColor

                        radius: 2
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: signInButton.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
                            GradientStop { position: 1 ; color: signInButton.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
                        }
                   }

                   // isDefault: true
                    onClicked: {
                        // continue with the username and password
                        if (authChallenge)
                           console.log(">>>> TODO: Auth Login....");
//                        root.visible = false;

                        previousPage();
                    }
                }
            }

        }
    }


}

