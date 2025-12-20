import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services.apps
import qs.components.ui
import qs.components.primitives

BarModule {
    id: root;

    // text: MPC.info;

    property bool songActive: !(MPC.statusInfo == "" || MPC.statusInfo == "!");

    c_surface: UITextModule {
        text.text: MPC.info
    }

    c_hoverContents: UIModule {
        color: Colors.tertiary;

        implicitHeight: (Styling.barHeight + Styling.spacing) * 2 + Styling.spacing;
        implicitWidth: (Styling.barHeight + Styling.spacing) * 7 + Styling.spacing;

        bottomLeftRadius: Styling.barModuleRadius + Styling.spacing;
        bottomRightRadius: Styling.barModuleRadius + Styling.spacing;

        RowLayout {
            spacing: Styling.spacing;

            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;

                margins: Styling.spacing;
            }

            UIButton {
                id: backButton;

                a_background.text {
                    text: "";
                }

                onClicked: MPC.flowControls.mainControl("prev");

                enabled: root.songActive;
            }

            UIButton {
                id: playPauseButton;

                a_background.text {
                    text: MPC.statusInfo;
                }

                onClicked: MPC.flowControls.mainControl("toggle");
            }

            UIButton {
                id: nextButton;

                a_background.text {
                    text: "";
                }

                onClicked: MPC.flowControls.mainControl("next");

                enabled: root.songActive;
            }

            UIButton {
                id: repeatButton;

                a_background.text {
                    text: "";
                    color: MPC.flowControls.repeat ? Colors.active : Colors.secondary;
                }

                onClicked: MPC.flowControls.control("repeat");
            }

            UIButton {
                id: randomButton;

                a_background.text {
                    text: "";
                    color: MPC.flowControls.random ? Colors.active : Colors.secondary;
                }

                onClicked: MPC.flowControls.control("random");
            }

            UIButton {
                id: consumeButton;

                a_background.text {
                    text: "";
                    color: MPC.flowControls.consume ? Colors.active : Colors.secondary;
                }

                onClicked: MPC.flowControls.control("consume");
            }

            UIButton {
                id: singleButton;

                a_background.text {
                    text: "";
                    color: MPC.flowControls.single ? Colors.active : Colors.secondary;
                }

                onClicked: MPC.flowControls.control("single");
            }
        }

        UISlider {
            id: seekSlider;

            anchors {
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;

                margins: Styling.spacing;
            }

            button {
                a_background.text {
                    text: ""
                }

                onClicked: MPC.flowControls.mainControl("stop");
            }

            slider {
                to: 100;

                live: false;

                onValueChanged: {
                    MPC.flowControls.seek(slider.value);
                }

                enabled: root.songActive;
            }
        }
    }
}
