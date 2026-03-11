pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services.apps
import qs.components.ui
import qs.components.primitives

BarModule {
    id: root;

    property bool songActive: !(MPC.statusInfo == "" || MPC.statusInfo == "!");

    c_surface: UITextModule {
        text.text: MPC.info
    }

    c_hoverContents: UIModule {
        color: Colors.tertiary;

        implicitHeight: row.implicitHeight + seekSlider.implicitHeight + Styling.spacing
        implicitWidth: row.implicitWidth

        bottomLeftRadius: Styling.barModuleRadius + Styling.spacing;
        bottomRightRadius: Styling.barModuleRadius + Styling.spacing;

        RowLayout {
            id: row

            spacing: Styling.spacing;

            anchors {
                left: parent.left;
                // right: parent.right;
                top: parent.top;
            }

            UIButton {
                id: backButton;

                surface {
                    text {
                        text: "";
                    }
                    
                    topRightRadius: 0
                    bottomRightRadius: 0
                }

                onClicked: MPC.flowControls.mainControl("prev");

                enabled: root.songActive;
            }

            UIButton {
                id: playPauseButton;

                surface {
                    text {
                        text: MPC.statusInfo;
                    }

                    radius: 0
                }

                onClicked: MPC.flowControls.mainControl("toggle");
            }

            UIButton {
                id: nextButton;

                surface {
                        text {
                        text: "";
                    }

                    topLeftRadius: 0
                    bottomLeftRadius: 0
                }

                onClicked: MPC.flowControls.mainControl("next");

                enabled: root.songActive;
            }

            UIButton {
                id: repeatButton;

                surface {
                    text {
                        text: "";
                        color: MPC.flowControls.repeat ? Colors.active : Colors.secondary;
                    }

                    topRightRadius: 0
                    bottomRightRadius: 0
                }

                onClicked: MPC.flowControls.control("repeat");
            }

            UIButton {
                id: randomButton;

                surface { 
                    text {
                        text: "";
                        color: MPC.flowControls.random ? Colors.active : Colors.secondary;
                    }

                    radius: 0
                }

                onClicked: MPC.flowControls.control("random");
            }

            UIButton {
                id: consumeButton;

                onClicked: MPC.flowControls.control("consume");

                surface {
                    radius: 0

                    text {
                        text: "";
                        color: MPC.flowControls.consume ? Colors.active : Colors.secondary;
                    }
                }
            }

            UIButton {
                id: singleButton;

                surface {
                    text {
                        text: "";
                        color: MPC.flowControls.single ? Colors.active : Colors.secondary;
                    }

                    topLeftRadius: 0
                    bottomLeftRadius: 0
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
            }

            button {
                surface {
                    text {
                        text: ""
                    }
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
