pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts;

import qs.config
import qs.services.system
import qs.components.ui
import qs.components.primitives

BarModule {
    text: "󰣇";

    implicitWidth: height;

    hoverContents: ModuleHoverContents {
        color: Colors.tertiary;

        implicitHeight: col.height + Styling.spacing * 2;
        implicitWidth: powerRow.width + Styling.spacing * 2;

        ColumnLayout {
            id: col;

            spacing: Styling.spacing;

            anchors {
                left: parent.left;
                top: parent.top;

                margins: Styling.spacing;
            }

            RowLayout {
                id: settingsButtons;

                spacing: Styling.spacing;

                UIButton {
                    forceSquare: false;

                    a_background.text {
                        text: "󰒓 󰕾";
                    }

                    onClicked: System.pavucontrol();

                    Layout.fillWidth: true
                }

                UIButton {
                    forceSquare: false;

                    a_background.text {
                        text: "󰒓 󰖯";
                    }

                    onClicked: System.nwglook();

                    Layout.fillWidth: true
                }
            }

            HardwareReadout {
                id: utilised;

                Layout.fillWidth: true;

                textObject.text: "" + Math.floor(System.cpuPerc * 100) + "% 󰄀" + Math.floor(System.gpuPerc * 100) + "%";
            }

            UIModule {
                id: tempContainer

                Layout.fillWidth: true

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

                Layout.fillWidth: true;

                RowLayout {
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
