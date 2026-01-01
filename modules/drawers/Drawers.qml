import Quickshell
import QtQuick
import Quickshell.Wayland

import qs.config
import qs.modules.bar
import qs.modules.launcher
import qs.util
import qs.services.qs
import qs.components.primitives

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
            WlrLayershell.keyboardFocus: Visibilities.launcher

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            mask: Region {
                regions: regionMasks.masks

                intersection: Intersection.Combine
            }

            RegionMasks {
                id: regionMasks

                bar: bar
                launcher: launcher
            }

            Bar { id: bar }

            Launcher {
                id: launcher

                anchors {
                    centerIn: parent
                }
            }

            UIModule {
                implicitHeight: 200
                implicitWidth: 200

                visible: Visibilities.controlPanel
            }
        }
    }
}