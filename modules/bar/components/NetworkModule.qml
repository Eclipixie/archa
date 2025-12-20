pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services.system
import qs.config
import qs.components.ui
import qs.components.primitives

BarModule {
    id: root;

    moduleActive: !networkActive();

    function networkActive(): bool {
        return Network.active;
    }

    function genText(): string {
        let str = statusChar();
        if (str != "" && str != "?") 
            str += " " + (Network.activeAP?.strength ?? "0") + "%";
        return str;
    }

    function statusChar(): string {
        if (!networkActive()) return "󰤮";

        if (Network.activeAP != null) {
            var strength = Network.activeAP.strength;

            return strengthChar(strength);
        }
        else if (Network.activeDevice.type == "ethernet")
            return ""
        return "󰤫"
    }

    function strengthChar(strength: int): string {
        if (strength < 20) return "󰤯";
        if (strength < 40) return "󰤟";
        if (strength < 60) return "󰤢";
        if (strength < 80) return "󰤥";
        return "󰤨";
    }

    c_surface: UITextModule {
        id: surfaceRoot

        text.text: root.genText()

        Connections {
            target: Network

            function onActiveDeviceChanged(): void {
                surfaceRoot.text.text = root.genText();
            }

            function onActiveAPChanged(): void {
                surfaceRoot.text.text = root.genText();
            }

            function networksUpdated(newNetworks): void {
                print("updated");
            }
        }
    }

    c_hoverContents: UIModule {
        id: hoverRoot;

        color: Colors.tertiary

        implicitHeight: list.implicitHeight + controls.implicitHeight + Styling.spacing + Styling.spacing * 2;
        implicitWidth: 200;

        Item {
            id: controls;

            anchors {
                top: parent.top;
                left: parent.left;
                right: parent.right;

                margins: Styling.spacing;
            }

            implicitHeight: Styling.barHeight;

            RowLayout {
                anchors {
                    right: parent.right
                    left: parent.left
                }

                spacing: Styling.spacing;

                UIModule {
                    border.width: 0;
                    Layout.fillWidth: true;
                }

                UIButton {
                    a_background.text.text: "󰤮";

                    enabled: root.networkActive();
                }

                UIButton {
                    a_background.text.text: "󰑓";

                    onClicked: Network.reloadNetworks();
                }
            }
        }

        ListView {
            id: list;
            
            implicitHeight: Math.min(800, 
                Network.networks.length * (Styling.barHeight + Styling.spacing) - Styling.spacing);

            anchors {
                top: controls.bottom;
                left: parent.left;
                right: parent.right;

                margins: Styling.spacing;
            }

            Connections {
                target: Network;
                function onNetworksUpdated(newNetworks: var) { 
                    list.model = newNetworks; 
                }
            }

            model: Network.networks;

            delegate: visualInfoRoot
        }

        Component {
            id: visualInfoRoot;

            Item {
                id: visualInfo

                height: Styling.barHeight + Styling.spacing;
                width: hoverRoot.width - Styling.spacing * 2;

                required property var modelData

                readonly property string strength: modelData.strength
                readonly property string ssid: modelData.ssid
                readonly property bool active: modelData.active

                Button {
                    height: Styling.barHeight;
                    
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }

                    onClicked: {
                        print("hi");
                    }

                    background: UIModule {
                        border.width: 0;

                        Item {
                            id: strengthText;

                            anchors {
                                top: parent.top;
                                bottom: parent.bottom;
                                left: parent.left
                            }

                            implicitWidth: parent.height;

                            UIText {
                                color: visualInfo.active ? Colors.active : Colors.inactive;

                                anchors.centerIn: parent;

                                text: root.strengthChar(visualInfo.strength);
                            }
                        }

                        Item {
                            anchors {
                                top: parent.top;
                                bottom: parent.bottom;
                                right: parent.right;
                                left: strengthText.right;

                                leftMargin: Styling.spacing;
                            }

                            UIText {
                                text: visualInfo.ssid;

                                anchors {
                                    verticalCenter: parent.verticalCenter;
                                    left: parent.left;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
