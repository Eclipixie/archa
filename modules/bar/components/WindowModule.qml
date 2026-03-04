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

            collapsed: true

            Timer {
                id: timer

                interval: 2000
                repeat: false

                onTriggered: {
                    swatch.collapsed = true
                }
            }

            Connections {
                target: Hypr

                function onFocusedWorkspaceIDChanged() {
                    swatch.index = Hypr.workspaceIDs.indexOf(Hypr.focusedWorkspaceID)
                }
            }

            model: Hypr.workspaceIDs

            onIndexChanged: { 
                swatch.collapsed = false

                timer.running = true
            }

            onClicked: function(newValue: string) {
                Hyprland.dispatch("workspace " + newValue);
            }

            Keys.enabled: true

            Keys.onPressed: (event) => {
                print("event")
                if (event.key == Qt.Key_Left) {
                    print("super")
                }
            }
        }
    }
}