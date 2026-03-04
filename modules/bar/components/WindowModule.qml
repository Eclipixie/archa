import QtQuick
import Quickshell.Hyprland

import qs.services.apps
import qs.components.ui

BarModule {
    id: root

    c_surface: Component {
        UISwatch {
            id: swatch

            index: Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)

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