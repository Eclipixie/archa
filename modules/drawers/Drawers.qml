import Quickshell
import QtQuick

import qs.config
import qs.modules.bar

Variants {
    id: root
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        PanelWindow {
            id: excluder
            
            height: Styling.barHeight + Styling.spacing * 2

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"
        }

        PanelWindow {
            id: window

            exclusionMode: ExclusionMode.Ignore

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            mask: Region {
                x: 0
                y: 0
                width: scope.modelData.width
                height: bar.height
            }

            Bar { id: bar }
        }
    }
}