import QtQuick
import Quickshell

import qs.modules.launcher.entries

Launchable {
    id: root

    name: "drun"

    branches: variants.instances

    property Variants variants: Variants {
        model: DesktopEntries.applications.values

        delegate: Component {
            Launchable {
                id: appLaunchable

                property QtObject modelData
                name: modelData.name + " [" + modelData.execString + "]"
                onLaunch: modelData.execute()

                branches: actions.instances

                property Variants actions: Variants {
                    model: appLaunchable.modelData.actions

                    delegate: Component {
                        Launchable {
                            property QtObject modelData
                            name: modelData.name + " [" + modelData.execString + "]"

                            onLaunch: modelData.execute()
                        }
                    }
                }
            }
        }
    }
}