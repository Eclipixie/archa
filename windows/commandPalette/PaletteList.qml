import Quickshell
import QtQuick
import QtQuick.Controls.Fusion

import qs.windows
import qs.windows.commandPalette.commands
import qs.windows.commandPalette.commands.primitives
import qs.util
import qs.widgets

Item {
    id: root;

    required property TextField search
    
    property ListCommand current: entries.query(search.text);

    ListCommand {
        id: entries;

        name: "listroot"

        sublist: [
            BrowserCommand { name: "browser" },
            SettingsCommand { name: "settings" },
            PowerCommand { name: "power" }
        ]
    }

    implicitHeight: Math.max(list.implicitHeight, 0);

    Loader {
        id: list;

        anchors.fill: root;

        sourceComponent: current.display;
    }

    Connections {
        target: search

        function onTextChanged(): void {
            current.search = search.text.trim().split(" ").pop();
        }
    }
}
