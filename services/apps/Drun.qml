#pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<QtObject> appdata: []
    property list<QtObject> apps: v_apps.instances

    Process {
        id: p_getDrun
        running: true

        command: ["sh", "-c", "ls -d1 /usr/share/applications/*.desktop | xargs cat"]
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(text);
                let apps = []
                let curApp = []

                let lines = text.split("\n");

                let actionKey, actionVal = "";

                for (let i = 0; i < lines.length; i++) {
                    if (lines[i] == "") continue;

                    if (lines[i].includes("Desktop Action") && actionKey != "") 
                        curApp.push(actionKey+":"+actionVal);

                    if (lines[i] == "[Desktop Entry]") {
                        if (actionKey != "")
                            curApp.push(actionKey+":"+actionVal);
                        apps.push(curApp.join(","));
                        curApp = {};
                        continue;
                    }

                    let [key, val] = lines[i].split("=");

                    if (key == "Name") actionKey = val;
                    if (key == "Exec") actionVal = val;
                }

                root.appdata = apps;
                console.log(apps);
            }
        }
    }

    Variants {
        id: v_apps

        model: root.appdata

        delegate: DrunApp {
            required property var modelData

            name: modelData.split(",")[0].split(":")[0]
            options: []
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