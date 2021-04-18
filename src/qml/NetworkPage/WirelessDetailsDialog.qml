import QtQuick 2.4
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import FishUI 1.0 as FishUI
import Cutefish.NetworkManagement 1.0 as NM

Dialog {
    id: control
    title: model.itemUniqueName

    // width: Math.max(detailsLayout.implicitWidth, footer.implicitWidth)

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    modal: true

    signal forgetBtnClicked()

    NM.WirelessItemSettings {
        id: settings
    }

    Component.onCompleted: {
        if (model.connectionPath) {
            settings.path = model.connectionPath
            autoJoinSwitch.checked = settings.autoConnect
            autoJoinSwitch.visible = true
            autoJoinLabel.visible = true
        }
    }

    contentItem: ColumnLayout {
        id: detailsLayout
        spacing: FishUI.Units.largeSpacing

        GridLayout {
            id: gridLayout
            columns: 2
            columnSpacing: FishUI.Units.largeSpacing
            rowSpacing: FishUI.Units.smallSpacing

            Label {
                id: autoJoinLabel
                text: qsTr("Auto-Join")
                visible: false
                Layout.alignment: Qt.AlignRight
                color: FishUI.Theme.disabledTextColor
            }

            Switch {
                id: autoJoinSwitch
                rightPadding: 0
                Layout.fillHeight: true
                visible: false
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: settings.autoConnect = checked
            }

            Label {
                text: qsTr("Security")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: securityLabel
                text: model.securityTypeString
                Layout.alignment: Qt.AlignRight
            }

            Label {
                text: qsTr("Signal")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: signalLabel
                text: model.signal
                Layout.alignment: Qt.AlignRight
            }

            Label {
                text: qsTr("IPv4 Address")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: ipv4AddressLabel
                // text: model.ipV4Address
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true
            }

            Label {
                font.bold: true
                text: qsTr("IPv6 Address")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: ipV6AddressLabel
                // text: model.ipV6Address
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("MAC Address")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: macAddressLabel
                // text: model.macAddress
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("Gateway")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: routerLabel
                // text: model.gateway
                Layout.alignment: Qt.AlignRight
            }

            Label {
                font.bold: true
                text: qsTr("DNS")
                color: FishUI.Theme.disabledTextColor
                Layout.alignment: Qt.AlignRight
            }

            Label {
                id: dnsLabel
                // text: model.nameServer
                Layout.alignment: Qt.AlignRight
            }
        }

        RowLayout {
            id: footerLayout
            spacing: FishUI.Theme.hugeRadius / 2

            Button {
                text: qsTr("Close")
                Layout.fillWidth: true
                onClicked: control.reject()
            }

            Button {
                text: qsTr("Forget this network")
                Layout.fillWidth: true
                flat: true
                onClicked: {
                    handler.removeConnection(model.connectionPath)
                    control.reject()
                }
            }
        }
    }
}