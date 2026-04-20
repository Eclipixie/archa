pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.services.system
import qs.components.readouts
import qs.components.primitives
import qs.components.ui
import qs.config

Readout {
    id: root

    required property string primaryZone

    readonly property double temp: Temperature.getTemp(root.primaryZone)

    color: Colors.primary

    icon: Component {
        UIModule {
            id: iconObject

            UIText {
                anchors.centerIn: parent

                text: Temperature.tempChar(root.primaryZone)

                color: if (root.temp >= 95) {
                    Colors.tertiary
                } else if (root.temp >= 80) {
                    Colors.warning
                } else { Colors.secondary }
            }

            RadialBar {
                progressColor: Temperature.getStatusColor(root.primaryZone)

                minValue: 10
                maxValue: 110

                dialWidth: Styling.outlines

                value: Temperature.getTemp(root.primaryZone)

                anchors.fill: parent
            }

            color: if (root.temp >= 95) {
                Colors.error
            } else {
                Colors.primary
            }
        }
    }

    horizontalBarItem: Component {
        Item {
            id: temperatureWrapper

            anchors.right: parent.right

            implicitHeight: temperature.implicitHeight

            width: temperature.width + root.iconLoader.width - temperature.textMargin / 2
            
            opacity: root.state == "bar" ? 1 : 0

            Behavior on opacity { Anim.NumberAnim { } }

            UITextModule {
                id: temperature

                anchors.right: parent.right

                text.text: root.temp + "󰔄"
            }
        }
    }

}
