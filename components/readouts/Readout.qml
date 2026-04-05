import QtQuick
import Quickshell

import qs.components.primitives
import qs.config

UIModule {
    id: root

    color: Colors.tertiary

    states: [iconState, barState, menuState]

    property Component icon
    readonly property Loader iconLoader: l_icon

    property Component horizontalBarItem
    property Component verticalBarItem
    property Component menu

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
                width: l_horizontalBar.width ?? undefined
            }
        }
    }

    State {
        id: menuState
        name: "menu"
    }

    Item {
        id: l_iconWrapper
        z: 1

        height: Styling.barHeight
        width: Styling.barHeight

        anchors.left: root.left

        Loader {
            id: l_icon

            sourceComponent: root.icon

            anchors.fill: parent
        }
    }

    Loader {
        id: l_horizontalBar

        sourceComponent: root.horizontalBarItem
        
        anchors {
            top: root.top
            right: root.right
        }
    }

    Loader {
        id: l_verticalBar

        sourceComponent: root.verticalBarItem
    }

    Loader {
        id: l_menu

        sourceComponent: root.menu

        anchors.fill: parent
    }
}
