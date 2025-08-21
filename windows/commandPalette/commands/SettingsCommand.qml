import Quickshell
import QtQuick

import qs.windows.commandPalette.commands.primitives

ListCommand {
    id: root

    sublist: [
        BoolCommand { name: "contrast"
            onExec: { Colors.contrast = value; }
        },
        BoolCommand { name: "darkmode"
            onExec: { Colors.dark = value; }
        },
        WallpaperCommand { name: "wallpaper" }
    ]
}
