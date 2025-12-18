import Quickshell
import QtQuick

import qs.windows.commandPalette.commands.primitives
import qs.util
import qs.services.qs

ListCommand {
    id: root

    sublist: [
        BoolCommand { name: "contrast"
            onExec: { Colors.contrast = value; }
        },
        BoolCommand { name: "darkmode"
            onExec: { Colors.dark = value; }
        },
        BoolCommand { name: "bar-background"
            onExec: { Styling.barBackground = value; }
        },
        BoolCommand { name: "bar-spacers"
            onExec: { Styling.barSpacers = value; }
        },
        ListCommand { name: "ui-radius"
            sublist: [
                ListCommand { name: "square"
                    onExec: { Styling.barModuleRadius = Styling.barRadiusMode.square }
                },
                ListCommand { name: "rounded"
                    onExec: { Styling.barModuleRadius = Styling.barRadiusMode.rounded }
                },
                ListCommand { name: "capsule"
                    onExec: { Styling.barModuleRadius = Styling.barRadiusMode.capsule }
                }
            ]
        },
        BoolCommand { name: "gradient"
            onExec: { Colors.preferredGradientActive = value; }
        }
    ]
}
