import Quickshell
import QtQuick
import QtQuick.Controls

import qs.util
import qs.windows

Item {
    id: root;

    property LabeledButton button: textObject;
    property Slider slider: sliderObject;

    implicitHeight: Styling.barHeight;

    LabeledButton {
        id: textObject;

        anchors {
            top: parent.top;
            left: parent.left;

            topMargin: (root.height - height) * .5;

            leftMargin: (root.height - width) * .5;
            rightMargin: (root.height - width) * .5;
        }
    }

    Slider {
        id: sliderObject;

        from: 0;
        to: 1;

        leftPadding: (background.height - 2 - handle.width) / 2;
        rightPadding: (background.height - 2 - handle.width) / 2;

        anchors {
            fill: parent;
            leftMargin: root.button.width + Styling.spacing;
        }

        background: UIModule {
            anchors.fill: parent;

            border.width: 0;

            Rectangle {
                color: Colors.secondary;

                y: sliderObject.topPadding + (slider.availableHeight - height) / 2;

                implicitHeight: 2;

                anchors {
                    left: parent.left;
                    right: parent.right;

                    margins: sliderObject.leftPadding + sliderObject.handle.width / 2;
                }
            }
        }

        handle: Rectangle {
            radius: width / 2;
            implicitWidth: 15;
            implicitHeight: 15;

            x: sliderObject.leftPadding + sliderObject.visualPosition * (sliderObject.availableWidth - width)

            anchors.verticalCenter: parent.verticalCenter;

            border {
                width: 2;
                color: Colors.secondary;
            }

            color: Colors.primary;
        }
    }
}