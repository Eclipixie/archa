import Quickshell
import QtQuick
import Quickshell.Io

import qs.services.apps

ListCommand {
    id: root

    onExec: { browserStart.startDetached(); }

    property Process browserStart: Process {
        id: browserStart
        command: ["zen-browser"]
    }

    property Connections profileConnection: Connections {
        target: ZenProfiles;

        function onProfilesChanged(): void {
            let profiles = ZenProfiles.profiles;

            for (let i = 0; i < profiles.length; i++) {
                sublist.push(profileCommand.createObject(null, { name: profiles[i] }));
            }
        }
    }

    component BrowserProfileListCommand : ListCommand {
        property string name

        onExec: { browserStart.startDetached(); }

        property Process browserStart: Process {
            id: browserStart
            command: ["zen-browser", "-P", name]
        }
    }

    property Component profileCommand: Component {
        BrowserProfileListCommand { }
    }
}
