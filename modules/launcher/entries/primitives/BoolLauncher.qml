pragma ComponentBehavior: Bound

import QtQuick

import qs.modules.launcher.entries

Launchable {
    id: root

    signal launchBool(value: bool)

    branches: [
        Launchable {
            name: "true"
            onLaunch: root.launchBool(true)
        },
        Launchable {
            name: "false"
            onLaunch: root.launchBool(false)
        }
    ]
}