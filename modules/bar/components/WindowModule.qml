import QtQuick
import Quickshell.Hyprland

import qs.services.apps
import qs.components.ui
import qs.services.qs
import qs.config

BarModule {
    id: root

    Behavior on implicitWidth { animation: Anim.NumberAnim { duration: 0 } }

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