pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root;
    property string brightness: "20";

    property string monitor: "acpi_video0";

    FileView {
        watchChanges: true
        onFileChanged: this.reload()

        path: "/sys/class/backlight/"+root.monitor+"/brightness"
        onLoaded: {
            root.brightness = text().split("\n")[0];
        }
    }

    Process {
        id: p_setBrightness;
        running: false;

        property string target: "0";

        command: ["brightnessctl", "s", target];
        stdout: StdioCollector {
            onStreamFinished: { root.brightness = p_setBrightness.target; }
        }
    }

    function setBrightness(brightness): void {
        p_setBrightness.target = brightness;
        p_setBrightness.running = true;
    }
}
