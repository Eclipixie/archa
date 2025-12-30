pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.services.system

Singleton {
    id: root
    
    readonly property string absPath: System.home + "/.zen/profiles.ini"
    property list<string> profiles: [];

    function parseProfiles(_profiles: string) {
        let profileList = _profiles.split("\n").filter((profile) => profile.includes("="));

        for (let i = 0; i < profileList.length; i++) {
            profileList[i] = profileList[i].split("=")[1];
        }

        root.profiles = profileList;
    }

    function reloadProfiles() {
        p_getProfiles.running = true;
    }

    Process {
        id: p_getProfiles;
        command: ["sh", "-c", "cat " + root.absPath + " | grep Name"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: root.parseProfiles(this.text);
        }
    }
}
