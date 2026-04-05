import QtQuick

import qs.config
import qs.services.system
import qs.components.primitives
import qs.components.ui

Readout {
    id: root

    color: Colors.primary

    icon {
        children: [UIText {
            anchors.centerIn: parent

            text: Battery.batteryChar()
            color: Battery.getStatusColor()
        },
        RadialBar {
            dialColor: "transparent"
            progressColor: Battery.getStatusColor()

            maxValue: 1

            dialWidth: 2

            value: Battery.percentage

            anchors.fill: parent

            penStyle: Qt.FlatCap
        }]

        anchors.left: root.left

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

        width: percentage.width + root.icon.width - percentage.textMargin / 2
        
        opacity: root.state == "bar" ? 1 : 0

        Behavior on opacity { Anim.NumberAnim { } }

        UITextModule {
            id: percentage

            anchors.right: parent.right

            text.text: MathUtil.roundPercentage(Battery.percentage) + "%"
        }
    }
}