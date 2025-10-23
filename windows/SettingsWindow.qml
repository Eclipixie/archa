import Quickshell
import QtQuick

import qs.services.qs
import qs.util
import qs.windows
import qs.windows.settingsWindow

Scope {
    id: root

    Loader {
        id: windowLoader

        active: Visibilities.settingsWindow
        asynchronous: true

        sourceComponent: surface
    }

    property Component surface: Component {
        FloatingWindow {
            id: window

            title: "Settings"

            onClosed: { Visibilities.settingsWindow = false; }

            color: Colors.primary

            property alias currentZone: zoneList.currentItem

            UIZone {
                id: zoneListContainer

                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom

                    margins: Styling.spacing
                }

                implicitWidth: 200

                UIList {
                    id: zoneList

                    anchors {
                        fill: parent
                        margins: Styling.spacing
                    }

                    property list<SettingsZone> zones: [
                        StylingSettings { }
                    ]

                    model: zones
                }
            }

            Item {
                id: zone

                anchors {
                    top: parent.top
                    right: parent.right
                    left: zoneListContainer.right
                    bottom: parent.bottom

                    margins: Styling.spacing
                }

                Loader {
                    id: zoneLoader

                    anchors.fill: parent

                    sourceComponent: zoneList.zones[zoneList.currentIndex].surface ?? null;
                }
            }
        }
    }
}
