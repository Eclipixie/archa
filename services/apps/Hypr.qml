pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Hyprland

Singleton {
    id: root

    property string focusedWorkspaceID: Hyprland.focusedWorkspace?.id ?? ""
    property list<string> workspaceIDs: getWorkspaces()

    function getWorkspaces(): var {
        let l_workspaces = Hyprland.workspaces.values;

        let newList = [];

        for (var i = 0; i < l_workspaces.length; i++) {
            newList.push(l_workspaces[i].name);
        }

        return newList;
    }
}