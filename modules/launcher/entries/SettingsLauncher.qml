pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.config
import qs.services.apps
import qs.modules.launcher.entries
import qs.modules.launcher.entries.primitives

Launchable {
    id: root

    name: "settings"

    branches: [
        Launchable {
            name: "wallpaper"
            
            branches: root.wallpaperVariants.instances
        },
        Launchable {
            name: "colour"

            branches: [
                BoolLauncher {
                    name: "dark"

                    onLaunchBool: function(value) { Colors.dark = value }
                },
                BoolLauncher {
                    name: "contrast"

                    onLaunchBool: function(value) { Colors.contrast = value }
                }
            ]
        },
        Launchable {
            name: "bar"

            branches: [
                BoolLauncher {
                    name: "background"

                    onLaunchBool: function(value) { Styling.barBackground = value }
                },
                BoolLauncher {
                    name: "spacers"

                    onLaunchBool: function(value) { Styling.barSpacers = value }
                }
            ]
        }
    ]

    property Variants wallpaperVariants: Variants {
        model: Matugen.wallpapers

        delegate: Component {
            Launchable {
                required property string modelData
                name: modelData
                onLaunch: Matugen.wallpaper(name)
            }
        }
    }
}
