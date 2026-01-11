pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root;

    property bool contrast: false;
    property bool dark: true;
    property bool gradientActive: preferredGradientActive;

    property bool preferredGradientActive: true;

    property var colors: [];

    property string primary: colors[map?.primary] ?? "#181818";
    property string secondary: colors[map?.secondary] ?? "#f1f1f1";
    property string tertiary: colors[map?.tertiary] ?? "#f0f0f0";

    property string active: colors[map?.active] ?? "#66cc99";
    property string inactive: colors[map?.inactive] ?? "#5c5c5c";

    property string error: colors[map?.error] ?? "#ffb4ab";
    property string warning: colors[map?.warning] ?? "#f1c40f";

    property string wallpaper: "file:///home/eclipixie/" + (colors["image"] ?? "Pictures/wallpapers/sunray-wallpaper.png")

    property ColorMap map: ColorMap {
        primary:   root.dark ? "surface_variant" : "on_surface";
        secondary: root.dark ? "on_surface"      : "surface_variant";
        tertiary: (root.contrast == root.dark) ? "primary" : "surface_bright";

        gradient: (root.contrast == root.dark) ? 
            [ "primary", "secondary" ] :
            [ "surface_bright", "surface_container_highest" ];

        active:   "active";
        inactive: "inactive";
        error:    "error";
        warning:  "warning";
    }

    property Gradient gradient: Gradient {
        GradientStop { position: 0; color: root.colors[root.map?.gradient[0]] ?? "black"; }
        GradientStop { position: 1; color: root.colors[root.map?.gradient[1]] ?? "red"; }

        orientation: Gradient.Vertical
    }

    Process {
        id: p_getColors;
        command: ["cat", "/home/eclipixie/.config/matugen/colors-gen"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n");

                let newColors = [];

                for (let i = 0; i < lines.length; i++) {
                    let split = lines[i].split(":");

                    newColors[split[0].trim()] = split[1].trim();
                }

                print(newColors["image"]);

                root.colors = newColors;
            }
        }
    }

    function updateColors(): void {
        p_getColors.running = true;
    }

    component ColorMap: QtObject {
        required property string primary;
        required property string secondary;
        required property string tertiary;

        required property list<string> gradient;

        required property string active;
        required property string inactive;

        required property string error;
        required property string warning;
    }
}