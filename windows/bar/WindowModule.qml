import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Controls

import qs.windows
import qs.util
import qs.services.apps

BarModule {
    id: root

    c_surface: Component {
        UIModule {
            id: surface

            implicitWidth: list.implicitWidth

            Row {
                Repeater {
                    id: list

                    implicitWidth: (Styling.spacing + Styling.barHeight) * model.length - Styling.spacing
                    implicitHeight: Styling.barHeight

                    model: Hypr.workspaceIDs
                    delegate: c_listItem
                }
            }

            // UISwatch {
            //     id: selector

            //     options: variants.instances

            //     state: Hypr.focusedWorkspaceID
            // }

            // Variants {
            //     id: variants

            //     delegate: UISwatch.OptionData {
            //         required property var modelData
            //         name: modelData
            //         item: list.itemAt(Hypr.workspaceIDs.indexOf(modelData))
            //     }

            //     model: list.model
            // }
        }
    }

    Component {
        id: c_listItem

        RoundButton {
            implicitWidth: listItem.implicitWidth + Styling.spacing;
            implicitHeight: listItem.implicitHeight

            required property var modelData
            readonly property string name: modelData

            radius: Styling.barModuleRadius

            background: UITextModule {
                id: listItem

                implicitWidth: implicitHeight

                text.text: name[0]
            }

            onClicked: {
                Hyprland.dispatch("workspace " + name)
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