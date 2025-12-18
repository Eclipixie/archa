import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components.ui
import qs.modules.bar.components
import qs.config
import qs.util.helpers
import qs.services.qs

Scope {
    id: root;

    property bool unsecure: true;

    Variants {
        model: Quickshell.screens;

        PanelWindow {
            id: popoutWindow;

            property var modelData;
            screen: modelData;

            color: "transparent";

            property BarModule target: BarPopoutHelper.targetModule;

            onTargetChanged: {
                if (target != null) {
                    container.children = [target.hoverContents];

                    container.children[0].anchors.left = container.left;
                    container.children[0].anchors.right = container.right;
                }
            }

            exclusionMode: ExclusionMode.Ignore;

            implicitWidth: BarPopoutHelper.popoutWidth + 2;
            implicitHeight: BarPopoutHelper.popoutHeight + 2;

            margins {
                top: Styling.barHeight + (Styling.spacing * 2) - 1 - Styling.spacing - 
                    (BarPopoutHelper.popoutActive ? 0 : height + Styling.barHeight + Styling.spacing * 2);
                left: Math.max(BarPopoutHelper.targetCenterX - (BarPopoutHelper.popoutWidth * .5), 0);
            }

            anchors {
                top: true;
                left: true;
            }

            Item {
                id: container;

                anchors.fill: parent;
                anchors.margins: 1;
            }

            HoverHandler {
                id: mouseHover;
                acceptedDevices: PointerDevice.AllDevices;

                onHoveredChanged: {
                    if (!hovered)
                        BarPopoutHelper.hoveredModule = null;
                    else
                        BarPopoutHelper.hoveredModule = BarPopoutHelper.targetModule;
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow;

            exclusiveZone: Visibilities.dashboard ? height + Styling.spacing : 0;

            surfaceFormat.opaque: false;

            color: "transparent";

            property var modelData;
            screen: modelData;

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: row.implicitHeight / 2;

            Item {
                id: row;

                implicitHeight: (Styling.barHeight + Styling.spacing * 2) * 2;

                anchors {
                    right: parent.right;
                    left: parent.left;
                    verticalCenter: parent.top;
                    
                    rightMargin: Styling.spacing
                    leftMargin: Styling.spacing
                }

                BarModule {
                    color: Colors.tertiary;

                    visible: Styling.barBackground;

                    radius: 0;

                    anchors {
                        margins: 0;
                        right: parent.right;
                        left: parent.left;
                    }

                    height: barWindow.height;

                    c_surface: Component { Item { } }
                }

                SystemModule {
                    id: systemModule;

                    visible: root.unsecure;

                    anchors.left: parent.left;
                }

                MPCModule {
                    id: mpcModule;

                    anchors.left: systemModule.right;
                }

                FSettingsModule {
                    id: fSettingsModule;

                    anchors.left: mpcModule.right;
                }

                BarModule {
                    anchors.left: fSettingsModule.right;
                    anchors.right: windowModule.left;

                    visible: Styling.barSpacers;
                }

                WindowModule {
                    id: windowModule;

                    visible: root.unsecure;

                    anchors.horizontalCenter: parent.horizontalCenter;
                }

                BarModule {
                    anchors.left: windowModule.right;
                    anchors.right: networkModule.left;

                    visible: Styling.barSpacers;
                }

                NetworkModule {
                    id: networkModule;

                    anchors.right: powerModule.left;
                }

                PowerModule {
                    id: powerModule

                    anchors.right: timeModule.left;
                }

                TimeModule {
                    id: timeModule

                    anchors.right: parent.right;
                }

                Item {
                    anchors {
                        fill: BarPopoutHelper.targetModule;
                        margins: -Styling.spacing * 2;
                    }

                    HoverHandler {
                        id: mouseHover;
                        acceptedDevices: PointerDevice.AllDevices;

                        onHoveredChanged: {
                            if (!hovered)
                                BarPopoutHelper.hoveredModule = null;
                            else
                                BarPopoutHelper.hoveredModule = BarPopoutHelper.targetModule;
                        }
                    }
                }
            }
        }
    }
}