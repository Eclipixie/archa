import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Controls
import QtQuick.Layouts

import qs.config
import qs.services.apps
import qs.components.ui
import qs.components.primitives

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