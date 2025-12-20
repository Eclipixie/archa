pragma ComponentBehavior: Bound

import QtQuick

import qs.services.system
import qs.config
import qs.components.ui
import qs.components.primitives

BarModule {
    id: root;

    // text: sinkChar() + " " + MathUtil.roundPercentage(Audio.sinkVolume) + "% | " +
    //     sourceChar() + " " + MathUtil.roundPercentage(Audio.sourceVolume) + "% | " +
    //     brightnessChar() + " " + Brightness.brightness + "%";

    function sinkChar(): string {
        return (Audio.sinkMuted ? "󰖁" : "󰕾");
    }

    function sourceChar(): string {
        return (Audio.sourceMuted ? "󰍭" : "󰍬");
    }

    function brightnessChar(): string {
        let out = "󰃠";
        if (Brightness.brightness < 85.7) out = "󰃟";
        if (Brightness.brightness < 71.4) out = "󰃞";
        if (Brightness.brightness < 57.1) out = "󰃝";
        if (Brightness.brightness < 42.9) out = "󰃜";
        if (Brightness.brightness < 28.6) out = "󰃛";
        if (Brightness.brightness < 14.3) out = "󰃚";
        return out;
    }

    c_surface: Component {
        Item {
            implicitHeight: Styling.barHeight
            implicitWidth: sinkReadout.implicitWidth + sourceReadout.implicitWidth + brightnessReadout.implicitWidth + Styling.spacing * 2;

            UITextModule {
                id: sinkReadout

                bottomRightRadius: 0
                topRightRadius: 0

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                text.text: root.sinkChar() + " " + MathUtil.roundPercentage(Audio.sinkVolume) + "%"
            }

            UITextModule {
                id: sourceReadout

                radius: 0

                anchors {
                    left: sinkReadout.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: Styling.spacing
                }

                text.text: root.sourceChar() + " " + MathUtil.roundPercentage(Audio.sourceVolume) + "%"
            }

            UITextModule {
                id: brightnessReadout

                bottomLeftRadius: 0
                topLeftRadius: 0

                anchors {
                    left: sourceReadout.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: Styling.spacing
                }

                text.text: root.brightnessChar() + " " + Brightness.brightness + "%"
            }
        }
    }

    c_hoverContents: Item {
        implicitHeight: Styling.barHeight * 3 + Styling.spacing * 2
        implicitWidth: root.width;

        Column {
            anchors {
                fill: parent
            }

            spacing: Styling.spacing

            UISlider {
                id: sinkContainer;

                anchors {
                    left: parent.left
                    right: parent.right
                }

                button.a_background.text.text: root.sinkChar();

                button.onClicked: Audio.toggleSinkMute();

                slider.onValueChanged: {
                    Audio.setSinkVolume(slider.value);
                }

                slider.value: Audio.sinkVolume;
            }

            UISlider {
                id: sourceContainer;

                anchors {
                    left: parent.left
                    right: parent.right
                }

                button.a_background.text.text: root.sourceChar();

                button.onClicked: Audio.toggleSourceMute();

                slider.onValueChanged: {
                    Audio.setSourceVolume(slider.value);
                }

                slider.value: Audio.sourceVolume;
            }

            UISlider {
                id: brightnessContainer;

                anchors {
                    left: parent.left
                    right: parent.right
                }

                button.a_background.text.text: root.brightnessChar();

                slider.to: 100;
                slider.stepSize: 1;

                slider.onValueChanged: {
                    Brightness.setBrightness(slider.value);
                }

                slider.value: Brightness.brightness;
            }
        }
    }
}
