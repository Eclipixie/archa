import QtQuick
import Quickshell.Hyprland

import qs.services.apps
import qs.components.ui

BarModule {
    id: root

    c_surface: Component {
        UISwatch {
            id: swatch

            group.checkedButton: group.buttons[Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)] ?? null

            model: Hypr.workspaceIDs

            onValueChanged: {
                Hyprland.dispatch("workspace " + value);
            }
        }
    }

    Connections {
        target: Hypr

        function onFocusedWorkspaceIDChanged(): void {
            root.setActive(1000);
        }
    }
}