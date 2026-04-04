import QtQuick

import qs.config
import qs.services.system
import qs.components.primitives
import qs.components.ui

Readout {
    id: batteryReadout

    color: Colors.primary

    icon {
        children: [UIText {
            anchors.centerIn: parent

            text: Battery.batteryChar()
            color: if (Battery.percentage <= .1) {
                Colors.tertiary
            } else if (Battery.percentage <= .2) {
                Colors.warning
            } else { Colors.secondary }
        },
        Item {
            anchors.fill: parent

            Path {
                startX: batteryReadout.icon.width / 2

                PathArc {
                    radiusX: batteryReadout.icon.width / 2
                    radiusY: batteryReadout.icon.width / 2

                    y: radiusY
                }
            }
        }]

        anchors.left: batteryReadout.left

        color: if (Battery.percentage <= .1) {
            Colors.error
        } else {
            Colors.primary
        }
    }

    horizontalBarItem: percentageWrapper
    
    Item {
        id: percentageWrapper

        anchors.right: parent.right

        implicitHeight: percentage.implicitHeight

        width: percentage.width + batteryReadout.icon.width - percentage.textMargin
        
        opacity: batteryReadout.state == "bar" ? 1 : 0

        Behavior on opacity { Anim.NumberAnim { } }

        UITextModule {
            id: percentage

            anchors.right: parent.right

            text.text: MathUtil.roundPercentage(Battery.percentage) + "%"
        }
    }
}