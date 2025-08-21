import Quickshell
import QtQuick
import Quickshell.Hyprland

BarModule {
    text: getWorkspaces();

    function getWorkspaces(): string {
        var workspaces = Hyprland.workspaces.values;

        var out = "";

        for (var i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id < 0) continue;
            var spacer = workspaces[i].active ? "|" : " ";
            out += spacer + workspaces[i].name + spacer;
        }

        return out;
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