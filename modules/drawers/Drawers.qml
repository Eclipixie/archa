import Quickshell
import QtQuick

import qs.config
import qs.modules.bar
import qs.util

Variants {
    id: root
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        PanelWindow {
            id: excluder
            
            implicitHeight: Styling.barHeight + Styling.spacing * 2

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }
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

            Bar { id: bar }

            mask: Region {
                regions: regionMasks.masks

                intersection: Intersection.Combine
            }

            RegionMasks {
                id: regionMasks

                bar: bar
            }
        }
    }
}