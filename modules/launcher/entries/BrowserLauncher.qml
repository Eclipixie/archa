pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.services.apps
import qs.modules.launcher.entries

Launchable {
    id: root

    name: "browser"

    branches: variants.instances

    property Variants variants: Variants {
        model: ZenProfiles.profiles

        delegate: Component {
            Launchable {
                required property string modelData
                name: modelData
                onLaunch: { root.launchBrowser(name); }
            }
        }
    }

    function launchBrowser(profile: string): void {
        Quickshell.execDetached(["zen-browser", "-p", profile])
    }
}
