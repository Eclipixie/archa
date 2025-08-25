import Quickshell
import QtQuick
import Quickshell.Hyprland

import qs.windows
import qs.util

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

                model: getWorkspaces()
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

    function getWorkspaces(): var {
        let l_workspaces = Hyprland.workspaces.values;

        let newList = [];

        for (var i = 0; i < l_workspaces.length; i++) {
            newList.push(c_workspace.createObject(null, { name: l_workspaces[i].name[0] }));
        }

        return newList;
    }

    component Workspace: QtObject {
        required property string name
    }

    Component {
        id: c_listItem
        Item {
            implicitWidth: listItem.implicitWidth + Styling.spacing;
            implicitHeight: listItem.implicitHeight

            required property string name

            UIModule {
                id: listItem

                implicitWidth: implicitHeight

                UIText {
                    anchors {
                        verticalCenter: listItem.verticalCenter
                        horizontalCenter: listItem.horizontalCenter
                    }

                    text: name
                }
            }
        }
    }

    Component {
        id: c_workspace
        Workspace { }
    }

    onTextChanged: {
        moduleActive = true;
        visibleTimer.restart();
    }

    Timer {
        id: visibleTimer;
        interval: 1000;
        running: false;
        onTriggered: moduleActive = false;
    }
}