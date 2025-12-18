import Quickshell
import QtQuick
import QtQuick.Controls.Fusion
import Quickshell.Wayland

import qs.config
import qs.services.qs
import qs.components.primitives
import qs.modules.commandPalette

Scope {
    Variants {
        model: Quickshell.screens;

        PanelWindow {
            id: paletteWindow;

            exclusionMode: ExclusionMode.Ignore;
            WlrLayershell.keyboardFocus: Visibilities.commandPalette;

            surfaceFormat.opaque: false;

            color: "transparent";

            visible: Visibilities.commandPalette;

            property var modelData;
            screen: modelData;

            anchors.bottom: true;
            anchors.top: true;

            implicitHeight: surface.implicitHeight;
            implicitWidth: surface.implicitWidth;

            UIModule {
                id: surface;

                implicitHeight: textBar.implicitHeight + Math.max(list.implicitHeight + Styling.spacing * 3, 0);

                implicitWidth: 400 + Styling.spacing * 2;

                color: Colors.tertiary;

                anchors {
                    right: parent.right;
                    left: parent.left;
                    bottom: parent.bottom;

                    bottomMargin: Styling.spacing;
                    topMargin: Styling.spacing;
                }

                PaletteList {
                    id: list;

                    search: textBar;

                    anchors {
                        right: parent.right;
                        left: parent.left
                        bottom: textBar.top;
                        margins: Styling.spacing;
                    }
                }

                TextField {
                    id: textBar;

                    enabled: Visibilities.commandPalette;
                    focusReason: Qt.ShortcutFocusReason;

                    font: Styling.bodyFont
                    
                    placeholderText: "Command";
                    placeholderTextColor: Colors.secondary;
                    
                    padding: Styling.spacing * 2;
                    
                    color: Colors.secondary;

                    anchors {
                        bottom: parent.bottom;
                        left: parent.left;
                        right: parent.right;
                        margins: Styling.spacing;
                    }

                    background: UIModule { }

                    Keys.onEscapePressed: Visibilities.commandPalette = false;

                    Keys.onTabPressed: {
                        let words = text.split(" ");
                        let q = words.pop();

                        words.push(list.current.queryList(q)[0].name);
                        textBar.text = words.join(" ") + " ";
                    }

                    onAccepted: {
                        text = text.trim();
                        list.current.exec();
                        Visibilities.commandPalette = false;
                    }

                    Connections {
                        target: Visibilities;

                        function onCommandPaletteChanged(): void {
                            textBar.focus = Visibilities.commandPalette;
                            textBar.text = "";
                        }
                    }
                }
            }
        }
    }
}
