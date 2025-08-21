pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

import qs.util

Singleton {
    property string wallpaperLoc: "/home/eclipixie/Pictures/wallpapers/"

    property list<string> wallpapers: []

    function wallpaper(name: string): void {
        matugen.wallpaper = name;
        matugen.running = true;
    }

    Process {
        id: getWallpapers
        command: ["ls", wallpaperLoc]
        running: true;
        stdout: StdioCollector {
            onStreamFinished: {
                wallpapers = this.text.trim().split("\n");
            }
        }
    }

    Process {
        id: matugen
        property string wallpaper: ""
        command: ["matugen", "image", wallpaperLoc + wallpaper]
    }
}
