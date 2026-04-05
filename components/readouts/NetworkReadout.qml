import QtQuick
import Quickshell

import qs.services.system
import qs.components.primitives
import qs.config

Readout {
    id: root

    icon: Component {
        UIModule {
            id: iconObject

            UIText {
                anchors.centerIn: parent

                text: Network.statusChar()
            }
        }
    }

    horizontalBarItem: Component {
        Item {
            id: bar

            implicitHeight: Styling.barHeight
            implicitWidth: Styling.barHeight
        }
    }

}
