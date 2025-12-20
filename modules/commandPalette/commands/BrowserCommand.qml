import QtQuick
import Quickshell.Io

import qs.components.ui
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
                root.sublist.push(root.profileCommand.createObject(null, { name: profiles[i] }));
            }
        }
    }

    component BrowserProfileListCommand : ListCommand {
        id: bplcRoot
        property string name

        onExec: { browserStart.startDetached(); }

        property Process browserStart: Process {
            id: browserStart
            command: ["zen-browser", "-P", bplcRoot.name]
        }
    }

    property Component profileCommand: Component {
        BrowserProfileListCommand { }
    }
}
