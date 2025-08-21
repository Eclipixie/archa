pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root;

    property string info: " " + statusInfo + (statusInfo == "" || statusInfo == "!" ? "" : 
        " " + title + " | " + timeInfo);
    property string title: "";
    property string timeInfo: "";
    property string statusInfo: "";

    property Item flowControls: flowControlsObject;

    Process {
        id: songInfo;
        command: ["mpc", "current", "-f", "%title%"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: title = this.text.split("\n")[0];
        }
    }

    Process {
        id: songInfoAwait;
        command: ["mpc", "current", "--wait", "-f", "%title%"];
        running: true;

        onRunningChanged: if (!running) running = true;

        stdout: StdioCollector {
            onStreamFinished: title = this.text.split("\n")[0];
        }
    }

    Process {
        id: statusRepeat;
        command: ["mpc", "status", "%state%,%currenttime%-%totaltime%"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: {
                let info = text.split("\n")[0].split(",");
                root.statusInfo = statusChar(info[0]);
                root.timeInfo = info[1];
            }
        }
    }
    
    function statusChar(info: string): string {
        if (info == "playing")
            return "";
        if (info == "paused")
            return "";
        if (info == "stopped")
            return "";

        return "!";
    }

    function timers() {
        statusRepeat.running = true;
    }

    Timer {
        interval: 1000;
        running: true;
        repeat: true;
        onTriggered: timers();
    }

    Item {
        id: flowControlsObject;

        property bool repeat: false;
        property bool random: false;
        property bool consume: false;
        property bool single: false;

        Process {
            id: btfProc;
            running: false;

            property string target: "toggle";

            command: ["mpc", target];
        }

        function mainControl(control: string): void {
            btfProc.target = control;
            btfProc.running = true;
        }

        Process {
            id: seekProc;
            running: false;

            property real target: 0;

            command: ["mpc", "seek", target + "%"]
        }

        function seek(percentage) {
            seekProc.target = percentage;
            seekProc.running = true;
        }

        Process {
            id: controlProc;
            running: false;

            property string target: "repeat";

            command: ["mpc", target, flowControlsObject.checkState(target) ? "on" : "off"];

            stdout: StdioCollector {
                onStreamFinished: {
                    print(this.text);
                }
            }
        }

        function control(control: string): void {
            controlProc.target = control;

            if (control == "repeat")  { repeat  = !repeat;  }
            if (control == "random")  { random  = !random;  }
            if (control == "consume") { consume = !consume; }
            if (control == "single")  { single  = !single;  }

            controlProc.running = true;
        }

        function checkState(control: string): bool {
            if (control == "repeat")  return repeat;
            if (control == "random")  return random;
            if (control == "consume") return consume;
            if (control == "single")  return single;
        }
    }
}
