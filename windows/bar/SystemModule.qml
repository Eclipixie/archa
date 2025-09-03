import Quickshell
import QtQuick
import QtQuick.Layouts;

import qs.util
import qs.services.system
import qs.widgets.controls
import qs.windows

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

                LabeledButton {
                    forceSquare: false;

                    a_background.text {
                        text: "󰒓 󰕾";
                    }

                    onClicked: System.pavucontrol();

                    Layout.fillWidth: true
                }

                LabeledButton {
                    forceSquare: false;

                    a_background.text {
                        text: "󰒓 󰖯";
                    }

                    onClicked: System.nwglook();

                    Layout.fillWidth: true
                }
            }

            HardwareReadout {
                id: cpuRead;

                Layout.fillWidth: true;

                textObject.text: " " + Math.floor(System.cpuPerc * 100) + "% 󰔏 " + System.cpuTemp;
            }

            HardwareReadout {
                id: gpuRead;

                Layout.fillWidth: true;

                textObject.text: "󰄀 " + Math.floor(System.gpuPerc * 100) + "% 󰔏 " + System.gpuTemp;
            }

            UIModule {
                id: powerRow

                Layout.fillWidth: true;

                RowLayout {
                    spacing: 0;

                    anchors.centerIn: parent;

                    LabeledButton {
                        a_background.text {
                            text: "󰐥";
                        }

                        onClicked: System.poweroff();
                    }

                    LabeledButton {
                        a_background.text {
                            text: "󰜉";
                        }

                        onClicked: System.reboot();
                    }

                    LabeledButton {
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

            property Text textObject: text;

            UIText {
                id: text;

                anchors.centerIn: parent;
            }
        }
    }
}
