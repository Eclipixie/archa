import Quickshell
import Quickshell.Io

import qs.widgets
import qs.services.qs
import qs.services.system

Scope {
    id: root;

    property bool launcherInterrupted;

    CustomShortcut {
        name: "dashboard";
        description: "Toggle the dashboard"
        onPressed: {
            Visibilities.dashboard = !Visibilities.dashboard;
        }
    }

    CustomShortcut {
        name: "lock"
        description: "Lock screen"
        onPressed: {
            LockScreen.sessionLock.locked = true;
        }
    }

    CustomShortcut {
        name: "commandPalette"
        description: "Activate command palette"
        onPressed: {
            Visibilities.commandPalette = !Visibilities.commandPalette;
        }
    }

    CustomShortcut {
        name: "colors"
        description: "System colors update hook"
        onPressed: {
            Colors.updateColors();
        }
    }
}