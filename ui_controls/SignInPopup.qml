import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls.Material 2.13


//NOT USED - MOVED LOGIN PAGE TO SIDE MENU, and using PORTAL instead
//Leaving file just in case....

Item {
    id: root
    width: parent.width
    height: parent.height
    anchors.fill: parent

    property var challenge //AuthenticationChallenge roperty for ArcGIS Token, HTTP Basic, HTTP Digest, and IWA.

    Rectangle {
        width: 150*app.scaleFactor
        height: 150*app.scaleFactor

        anchors.fill: parent
        color: app.appBackgroundColor

        Label {
            id: displayLabel
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.baseFontSize*0.4
            color: app.primaryColor
            font.bold: true
            wrapMode: Text.Wrap
            topPadding: 150*app.scaleFactor
            text: "Authentication Required"
        }

        Label {
            id: hostLabel
            Material.theme: Material.Light
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.baseFontSize*0.5
            anchors.top: displayLabel.bottom
            anchors.topMargin: 5*app.scaleFactor
            color: app.primaryColor
            font.bold: true
            wrapMode: Text.Wrap
            text: "waikato.maps.arcgis.com"
        }

        TextField {
            id: usernameTextField
            width: 230 * app.scaleFactor
            placeholderText: qsTr("Username")
            anchors.top: hostLabel.bottom
            anchors.topMargin: 25*app.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextField {
            id: passwordTextField
            width: 230 * app.scaleFactor
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            anchors.top: usernameTextField.bottom
            anchors.topMargin: 5*app.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            id: btnRow
            spacing: 20 * app.scaleFactor
            anchors.top: passwordTextField.bottom
            anchors.topMargin: 15*app.scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: cancelButton
                text: qsTr("CANCEL")
                font.bold: true
                font.pixelSize: app.baseFontSize*0.4

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
                        GradientStop { position: 0;  color: cancelButton.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
                        GradientStop { position: 1;  color: cancelButton.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
                    }
               }

                onClicked: {
                    // cancel the authentication challenge and let the resource fail to load
                    if (challenge) challenge.cancel()
                    root.visible = false
                }
            }

            Button {
                id: signInButton
                text: qsTr("SIGN IN")
                font.bold: true
                font.pixelSize: app.baseFontSize*0.4

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
                        GradientStop { position: 0;  color: signInButton.pressed ? Qt.lighter(app.primaryColor, 1.3) : Qt.lighter(app.primaryColor, 0.7) }
                        GradientStop { position: 1;  color: signInButton.pressed ? Qt.lighter(app.primaryColor, 0.7) : Qt.lighter(app.primaryColor, 1.3) }
                    }
               }

               // isDefault: true
                onClicked: {
                    // continue with the username and password
                    if (challenge)
                       console.log(">>>> TODO: Auth Login....")
                    root.visible = false
                }
            }
        }

        Rectangle {
            color: "#FFCCCC"
            radius: 5
            width: parent.width
            anchors.top: btnRow.bottom
            anchors.topMargin: 15*app.scaleFactor
            height: 20 * app.scaleFactor
            visible: challenge ? challenge.failureCount > 1 : false

            Text {
                anchors.centerIn: parent
                text: qsTr("Invalid username or password.")
                font.pixelSize: app.baseFontSize*0.4
                color: "red"
            }
        }


    }
}
