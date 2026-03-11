import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.services.apps
import qs.components.ui
import qs.services.qs

BarModule {
    id: root

    surface {
        implicitWidth: swatch.implicitWidth

        children: [
            UISwatch {
                id: swatch

                index: Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)

                collapsed: !(root.open || Visibilities.superDown)

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
        ]
    }
}