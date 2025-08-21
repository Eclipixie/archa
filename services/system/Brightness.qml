pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root;
    property string brightness: "20";
    property Timer proc: timer;

    Process {
        id: checkBrightness;
        command: ["brightnessctl", "g"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: {
                root.brightness = this.text.split("\n")[0];
            }
        }
    }

    Process {
        id: setBrightnessProc;
        running: false;

        property string target: "0";

        command: ["brightnessctl", "s", target];
    }

    function setBrightness(brightness): void {
        setBrightnessProc.target = brightness;
        setBrightnessProc.running = true;
        root.brightness = brightness;
    }

    Timer {
        id: timer;
        interval: 10;
        running: false;
        onTriggered: checkBrightness.running = true;
    }
}
