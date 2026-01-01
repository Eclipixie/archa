pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Hyprland

Singleton {
    id: root

    property string focusedWorkspaceID: Hyprland.focusedWorkspace?.id ?? ""
    property list<string> workspaceIDs: getWorkspaces()

    function getWorkspaces(): var {
        let workspaces = Hyprland.workspaces.values;

        let workspaceNames = [];

        for (var i = 0; i < workspaces.length; i++) {
            // filtering out special workspaces
            if (isNaN(workspaces[i].name))
                continue;
            workspaceNames.push(workspaces[i].name);
        }

        return workspaceNames;
    }
}