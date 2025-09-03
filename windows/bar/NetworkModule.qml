import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services.system
import qs.util
import qs.widgets.controls
import qs.windows

BarModule {
    id: root;

    text: genText();

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
        return "󰤮!"
    }

    function strengthChar(strength: int): string {
        if (strength < 20) return "󰤯";
        if (strength < 40) return "󰤟";
        if (strength < 60) return "󰤢";
        if (strength < 80) return "󰤥";
        return "󰤨";
    }

    Connections {
        target: Network

        function onActiveDeviceChanged(): void {
            root.text = genText();
        }

        function onActiveAPChanged(): void {
            root.text = genText();
        }

        function networksUpdated(newNetworks): void {
            print("updated");
        }
    }

    hoverContents: ModuleHoverContents {
        id: hoverRoot;

        color: Colors.tertiary;

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

                LabeledButton {
                    a_background.text.text: "󰤮";

                    enabled: networkActive();
                }

                LabeledButton {
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
                function onNetworksUpdated(newNetworks: list<AccessPoint>) { 
                    list.model = newNetworks; 
                }
            }

            model: Network.networks;

            delegate: visualInfoRoot
        }

        Component {
            id: visualInfoRoot;

            Item {
                height: Styling.barHeight + Styling.spacing;
                width: hoverContents.width - Styling.spacing * 2;

                required property string strength
                required property string ssid
                required property bool active

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
                                color: active ? Colors.active : Colors.inactive;

                                anchors.centerIn: parent;

                                text: root.strengthChar(strength);
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
                                text: ssid;

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
