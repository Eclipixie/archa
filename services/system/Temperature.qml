pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property var temps: []

    Process {
        id: p_getThermal
        running: true;

        command: ["sh", "-c", "ls -d1 /sys/class/thermal/thermal_zone*/temp | xargs cat"]
        stdout: StdioCollector {
            onStreamFinished: { root.temps = text.trim().split("\n"); }
        }
    }

    Timer {
        id: t_getThermal
        running: true
        repeat: true
        interval: 10000
        onTriggered: p_getThermal.running = true;
    }
}
