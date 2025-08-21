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
        implicitWidth: settingsButtons.width + Styling.spacing * 2;

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

                    text: "󰒓 󰕾";

                    onClicked: System.pavucontrol();
                }

                LabeledButton {
                    forceSquare: false;

                    text: "󰒓 󰖯";

                    onClicked: System.nwglook();
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
                border.width: 0;

                Layout.fillWidth: true;

                RowLayout {
                    spacing: 0;

                    anchors.centerIn: parent;

                    LabeledButton {
                        text: "󰐥";

                        onClicked: System.poweroff();
                    }

                    LabeledButton {
                        text: "󰜉";

                        onClicked: System.reboot();
                    }

                    LabeledButton {
                        text: "󰤄";

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
