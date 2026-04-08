pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.services.system
import qs.components.primitives
import qs.components.ui

Readout {
    id: root

    color: Colors.primary

    icon: Component {
        UIModule {
            id: iconObject

            UIText {
                anchors.centerIn: parent

                text: Battery.batteryChar()
                color: Battery.getStatusColor()
            }

            RadialBar {
                progressColor: Battery.getStatusColor()

                maxValue: 1

                dialWidth: 2

                value: Battery.percentage

                anchors.fill: parent

                penStyle: Qt.FlatCap
            }

            color: if (Battery.percentage <= .1) {
                Colors.error
            } else {
                Colors.primary
            }
        }
    }

    horizontalBarItem: Component {
        Item {
            id: percentageWrapper

            implicitHeight: percentage.implicitHeight

            width: percentage.width + root.iconLoader.width - percentage.textMargin / 2
            
            opacity: root.state == "bar" ? 1 : 0

            Behavior on opacity { Anim.NumberAnim { } }

            UITextModule {
                id: percentage

                anchors.right: parent.right

                text.text: MathUtil.roundPercentage(Battery.percentage) + "%"
            }
        }
    }
}