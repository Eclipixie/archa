#pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property list<QtObject> apps: []

    Process {
        id: p_getDrun
        running: true

        command: ["sh", "-c", "ls -d1 /usr/share/applications/*.desktop | xargs cat"]
        stdout: StdioCollector {
            onStreamFinished: {
                let apps = []
                let curApp = {}

                let lines = text.split("\n");

                let actionKey, actionVal = "";

                for (let i = 0; i < lines.length; i++) {
                    if (lines[i] == "") continue;

                    if (lines[i].includes("Desktop Action") && actionKey != "") 
                        curApp[actionKey] = actionVal;

                    if (lines[i] == "[Desktop Entry]") {
                        if (actionKey != "")
                            curApp[actionKey] = actionVal;
                        apps.push(curApp);
                        curApp = {};
                        continue;
                    }

                    let [key, val] = lines[i].split("=");

                    if (key == "Name") actionKey = val;
                    if (key == "Exec") actionVal = val;
                }

                root.apps = apps;
                print(apps);
            }
        }
    }

    component DrunApp: QtObject {
        required property string name
        required property list<DrunAppOption> options
    }

    component DrunAppOption: QtObject {
        required property string name
        required property string cmd
    }
}