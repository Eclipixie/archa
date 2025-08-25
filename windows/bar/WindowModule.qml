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
            implicitWidth: list.implicitWidth

            ListView {
                id: list

                orientation: Qt.Horizontal

                implicitWidth: (Styling.spacing + Styling.barHeight) * model.length - Styling.spacing
                implicitHeight: Styling.barHeight

                anchors {
                    verticalCenter: surface.verticalCenter
                    horizontalCenter: surface.horizontalCenter
                }

                model: Hyprland.workspaces.values
                delegate: c_listItem
            }

            UIModule {
                color: Colors.secondary

                anchors {
                    left: parent.left
                    leftMargin: getWorkspaceOffset()
                }

                UIText {
                    color: Colors.primary

                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: Hyprland.focusedWorkspace?.name[0] ?? ""
                }

                Behavior on anchors.leftMargin { animation: Styling.PropertyEasing { } }
            }
        }
    }

    function getWorkspaceOffset(): int {
        return Hyprland.workspaces.indexOf(Hyprland.focusedWorkspace) * 
            (Styling.barHeight + Styling.spacing);
    }

    Component {
        id: c_listItem
        Item {
            implicitWidth: listItem.implicitWidth + Styling.spacing;
            implicitHeight: listItem.implicitHeight

            required property string name

            RoundButton {
                radius: Styling.barModuleRadius

                background: UIModule {
                    id: listItem

                    implicitWidth: implicitHeight

                    UIText {
                        anchors {
                            verticalCenter: listItem.verticalCenter
                            horizontalCenter: listItem.horizontalCenter
                        }

                        text: name[0]
                    }
                }

                onClicked: {
                    Hyprland.dispatch("workspace " + name)
                }
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