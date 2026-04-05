pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.config

Singleton {
    id: root
    property var temps: QtObject { }

    function getTemp(zone) {
        if (!temps.hasOwnProperty(zone)) return 0
        
        else return MathUtil.toDegrees(temps[zone])
    }

    function tempChar(zone) {
        let temp = MathUtil.toDegrees(temps[zone]);

        if      (temp <= 20) { return ""; }
        else if (temp <= 40) { return ""; }
        else if (temp <= 60) { return ""; }
        else if (temp <= 80) { return ""; }
        else                 { return ""; }
    }

    function getStatusColor(zone) {
        let temp = MathUtil.toDegrees(temps[zone]);

        if      (temp >= 95) { return Colors.tertiary }
        else if (temp >= 80) { return Colors.warning }
        return Colors.secondary
    }

    Process {
        id: p_getThermals
        running: true

        command: ["sh", Quickshell.shellDir + "/assets/scripts/temps.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                let zoneData = text.trim().split("\n");

                let newZones = { };

                for (let i = 0; i < zoneData.length; i++) {
                    let zone = zoneData[i].split(":");

                    newZones[zone[0]] = zone[1];
                }

                root.temps = newZones;
            }
        }
    }

    Timer {
        id: t_getThermals
        running: true
        repeat: true
        interval: 60000
        onTriggered: p_getThermals.running = true;
    }
}
