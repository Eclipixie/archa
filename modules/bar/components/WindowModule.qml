import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.services.apps
import qs.components.ui
import qs.services.qs

BarModule {
    id: root

    c_surface: Component {
        UISwatch {
            id: swatch

            index: Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)

            collapsed: !(hover.hovered || Visibilities.superDown)

            HoverHandler {
                id: hover
                acceptedDevices: PointerDevice.AllDevices

                margin: Styling.spacing
            }

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