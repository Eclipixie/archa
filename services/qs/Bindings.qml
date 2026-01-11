import QtQuick
import Quickshell

import qs.services.qs
import qs.widgets
import qs.config

Scope {
    id: root;

    property QtObject keyboardLayers: QtObject {
        property string base: "󱊷󰃞󰃠" + Visibilities.controlPanel ? "󰖮" : "󰖱" + "󱂬󰥻󰌌󰒮󰐎󰒭󰕿󰖀󰕾󰐥" +
            "`1234567890-=" +
            "󰌒qwertyuiop   " +
            "󰌎asdfghjkl;'󰌑" +
            "󰘶zxcvbnm,./󰘶" +
            "󰊕󰘴󰘵󰘳 󰘳󰘵󰁍󰁝󰁅󰁔"
        property var sup: {
            "q": "",
            "e": "󰉋",
            // "s": Visibilities.controlPanel ? "󰖮" : "󰖱",
            "l": "󰌾",
            "b": "󰖟"
        }
        property var supShift: {
            "p": "󰌧"
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
            Visibilities.launcher = !Visibilities.launcher;
        }
    }

    CustomShortcut {
        name: "controlPanel"
        description: "Toggle control panel"
        onPressed: {
            Visibilities.controlPanel = !Visibilities.controlPanel
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