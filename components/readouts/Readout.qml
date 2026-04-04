import QtQuick
import Quickshell

import qs.components.primitives
import qs.config

UIModule {
    id: root

    color: Colors.tertiary

    states: [iconState, barState, menuState]

    readonly property UIModule icon: o_icon

    property Item horizontalBarItem
    property Item verticalBarItem
    property Item menu

    // clip: true

    state: "bar"

    State {
        id: iconState
        name: "icon"

        PropertyChanges {
            root {
                width: root.height
            }
        }
    }

    Behavior on width { Anim.NumberAnim { } }

    State {
        id: barState
        name: "bar"

        PropertyChanges {
            root {
                width: root.horizontalBarItem.width
            }
        }
    }

    State {
        id: menuState
        name: "menu"
    }

    UIModule {
        id: o_icon

        z: 1

        implicitWidth: implicitHeight
    }
}
