pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.services.system
import qs.components.ui
import qs.components.primitives

BarModule {
    c_surface: UITextModule {
        text.text: "󰣇";
    }

    c_hoverContents: UIModule {
        color: Colors.tertiary;

        implicitHeight: col.height + Styling.spacing * 2;
        implicitWidth: col.width;

        Column {
            id: col;

            spacing: Styling.spacing;

            anchors {
                left: parent.left
                bottom: parent.bottom

                margins: Styling.spacing;
            }

            Row {
                id: settingsButtons;

                spacing: Styling.spacing;

                UIButton {
                    forceSquare: false;

                    a_background.text {
                        text: "󰒓 󰕾";
                    }

                    onClicked: System.pavucontrol();
                }

                UIButton {
                    forceSquare: false;

                    a_background.text {
                        text: "󰒓 󰖯";
                    }

                    onClicked: System.nwglook();
                }
            }

            HardwareReadout {
                id: utilised;

                anchors {
                    left: parent.left
                    right: parent.right
                }

                textObject.text: "" + Math.floor(System.cpuPerc * 100) + "% 󰄀" + Math.floor(System.gpuPerc * 100) + "%";
            }

            UIModule {
                id: tempContainer

                anchors {
                    left: parent.left
                    right: parent.right
                }

                implicitHeight: Temperature.temps.length / 2 * (Styling.barHeight + Styling.spacing) - Styling.spacing

                Flow {
                    anchors.fill: parent

                    leftPadding: Styling.spacing
                    rightPadding: Styling.spacing

                    Repeater {
                        id: temps
                        model: Temperature.temps

                        Item {
                            id: tempsDelegate

                            required property string modelData

                            implicitWidth: tempContainer.width / 2 - Styling.spacing
                            implicitHeight: Styling.barHeight

                            UIText {
                                anchors.centerIn: parent

                                id: textObject
                                text: "󰔏" + Math.round(MathUtil.toDegrees(tempsDelegate.modelData)); 
                            }
                        }
                    }
                }
            }

            UIModule {
                id: powerRow

                anchors {
                    left: parent.left
                    right: parent.right
                }

                Row {
                    spacing: 0;

                    anchors.centerIn: parent;

                    UIButton {
                        a_background.text {
                            text: "󰐥";
                        }

                        onClicked: System.poweroff();
                    }

                    UIButton {
                        a_background.text {
                            text: "󰜉";
                        }

                        onClicked: System.reboot();
                    }

                    UIButton {
                        a_background.text {
                            text: "󰤄";
                        }

                        onClicked: System.suspend();
                    }
                }
            }
        }

        component HardwareReadout: UIModule {
            implicitWidth: 90;

            border.width: 0;

            property alias textObject: text;

            UIText {
                id: text;

                anchors.centerIn: parent;
            }
        }
    }
}
