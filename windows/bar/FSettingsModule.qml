import Quickshell
import QtQuick
import QtQuick.Layouts

import Quickshell.Services.Pipewire

import qs.services.system
import qs.util
import qs.widgets
import qs.widgets.controls
import qs.windows

BarModule {
    id: root;

    text: sinkChar() + " " + MathUtil.roundPercentage(Audio.sinkVolume) + "% | " +
        sourceChar() + " " + MathUtil.roundPercentage(Audio.sourceVolume) + "% | " +
        brightnessChar() + " " + Brightness.brightness + "%";

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

    onTextChanged: { setActive(1000); }

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

                text.text: sinkChar() + " " + MathUtil.roundPercentage(Audio.sinkVolume) + "%"
            }

            UITextModule {
                id: sourceReadout

                radius: 0

                anchors {
                    left: sinkReadout.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: Styling.spacing
                }

                text.text: sourceChar() + " " + MathUtil.roundPercentage(Audio.sourceVolume) + "%"
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

                text.text: brightnessChar() + " " + Brightness.brightness + "%"
            }
        }
    }

    hoverContents: ModuleHoverContents {
        color: Colors.tertiary;

        implicitHeight: Styling.barHeight * 3 + (2 * Styling.spacing) * 2;
        implicitWidth: root.width;

        LabeledSlider {
            id: sinkContainer;

            button.text: sinkChar();

            button.onClicked: Audio.toggleSinkMute();

            anchors {
                top: parent.top;
                right: parent.right;
                left: parent.left;

                margins: Styling.spacing;
            }

            slider.onValueChanged: {
                Audio.setSinkVolume(slider.value);
            }

            slider.value: Audio.sinkVolume;
        }

        LabeledSlider {
            id: sourceContainer;

            button.text: sourceChar();

            button.onClicked: Audio.toggleSourceMute();

            anchors {
                top: sinkContainer.bottom;
                right: parent.right;
                left: parent.left;

                margins: Styling.spacing;
            }

            slider.onValueChanged: {
                Audio.setSourceVolume(slider.value);
            }

            slider.value: Audio.sourceVolume;
        }

        LabeledSlider {
            id: brightnessContainer;

            button.text: brightnessChar();

            anchors {
                top: sourceContainer.bottom;
                right: parent.right;
                left: parent.left;

                margins: Styling.spacing;
            }

            slider.to: 100;
            slider.stepSize: 1;

            slider.onValueChanged: {
                Brightness.setBrightness(slider.value);
            }

            slider.value: Brightness.brightness;
        }
    }
}
