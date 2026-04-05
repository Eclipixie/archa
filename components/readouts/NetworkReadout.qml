import QtQuick
import Quickshell

import qs.services.system
import qs.components.primitives
import qs.config

Readout {
    id: root

    icon {
        children: [
            UIText {
                anchors.centerIn: parent

                text: Network.statusChar()
            }
        ]
    }

    horizontalBarItem: bar

    Item {
        id: bar

        implicitHeight: Styling.barHeight
        implicitWidth: Styling.barHeight
    }
}
