pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.services.apps
import qs.components.ui

Readout {
    id: root

    color: Colors.primary

    icon: Component {
        Item {
            width: Styling.barHeight
            height: Styling.barHeight
        }
    }

    horizontalBarItem: Component {
        UISwatch {
            id: swatch

            Behavior on width {
                Anim.NumberAnim { duration: 0 }
            }

            index: Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)

            collapsed: root.state != "bar"

            Connections {
                target: Hypr

                function onFocusedWorkspaceIDChanged() {
                    swatch.index = Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)
                }
            }

            model: Hypr.workspaceIDs

            onClicked: function(newValue: string) {
                Hyprland.dispatch("workspace " + newValue);
            }
        }
    }
}
