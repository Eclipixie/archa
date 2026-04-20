pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.ui
import qs.components.primitives
import qs.services.apps

Readout {
    id: root

    icon: Component {
        UIModule {
            id: iconObject

            UIText {
                anchors.centerIn: parent

                text: MPC.statusInfo
            }

            RadialBar {
                maxValue: MPC.maxTime

                dialWidth: Styling.outlines

                value: MPC.currentTime

                anchors.fill: parent
            }
        }
    }

    horizontalBarItem: Component {
        Item {
            implicitHeight: Styling.barHeight
            implicitWidth: Styling.barHeight    
        }
    }
}