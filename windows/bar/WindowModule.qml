import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Controls
import QtQuick.Layouts

import qs.windows
import qs.util
import qs.services.apps
import qs.widgets.controls

BarModule {
    id: root

    c_surface: Component {
        UIModule {
            id: surface

            implicitWidth: list.implicitWidth

            Repeater {
                id: list

                implicitWidth: (Styling.spacing + Styling.barHeight) * model.length - Styling.spacing
                implicitHeight: Styling.barHeight

                model: Hypr.workspaceIDs
                delegate: c_listItem
            }

            UISwatch {
                id: selector

                options: variants.instances

                state: Hypr.focusedWorkspaceID
            }

            Variants {
                id: variants

                delegate: UISwatch.OptionData {
                    required property var modelData
                    name: modelData
                    item: list.itemAt(Hypr.workspaceIDs.indexOf(modelData))
                }

                model: list.model
            }
        }
    }

    Component {
        id: c_listItem

        LabeledButton {
            required property var modelData
            required property int index
            readonly property string name: modelData

            a_background {
                text {
                    text: name[0]
                }
            }

            // cursed workaround to make the uiswatch work properly
            anchors {
                left: parent.left
                leftMargin: index * Styling.barHeight + (index - 1) * Styling.spacing
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