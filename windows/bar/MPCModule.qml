import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.util
import qs.services.apps
import qs.widgets.controls

BarModule {
    id: root;

    text: MPC.info;

    property bool songActive: !(MPC.statusInfo == "" || MPC.statusInfo == "!");

    hoverContents: ModuleHoverContents {
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

            LabeledButton {
                id: backButton;

                text: "";

                onClicked: MPC.flowControls.mainControl("prev");

                enabled: root.songActive;
            }

            LabeledButton {
                id: playPauseButton;

                text: MPC.statusInfo;

                onClicked: MPC.flowControls.mainControl("toggle");
            }

            LabeledButton {
                id: nextButton;

                text: "";

                onClicked: MPC.flowControls.mainControl("next");

                enabled: root.songActive;
            }

            LabeledButton {
                id: repeatButton;

                a_background.text.text: "";
                a_background.text.color: MPC.flowControls.repeat ? Colors.active : Colors.secondary;

                onClicked: MPC.flowControls.control("repeat");
            }

            LabeledButton {
                id: randomButton;

                a_background.text.text: "";
                a_background.text.color: MPC.flowControls.random ? Colors.active : Colors.secondary;

                onClicked: MPC.flowControls.control("random");
            }

            LabeledButton {
                id: consumeButton;

                a_background.text.text: "";
                a_background.text.color: MPC.flowControls.consume ? Colors.active : Colors.secondary;

                onClicked: MPC.flowControls.control("consume");
            }

            LabeledButton {
                id: singleButton;

                a_background.text.text: "";
                a_background.text.color: MPC.flowControls.single ? Colors.active : Colors.secondary;

                onClicked: MPC.flowControls.control("single");
            }
        }

        LabeledSlider {
            id: seekSlider;

            anchors {
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;

                margins: Styling.spacing;
            }

            button {
                text: ""

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
