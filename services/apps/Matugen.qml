pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

import qs.util

Singleton {
    property string wallpaperLoc: "/home/eclipixie/Pictures/wallpapers/"

    property list<string> wallpapers: []

    Process {
        id: p_getWallpapers
        command: ["ls", wallpaperLoc]
        running: true;
        stdout: StdioCollector {
            onStreamFinished: {
                wallpapers = this.text.trim().split("\n");
            }
        }
    }

    function getWallpapers() {
        p_getWallpapers.running = true;
    }

    Process {
        id: p_matugen
        property string wallpaper: ""
        command: ["matugen", "image", wallpaperLoc + wallpaper]
    }

    function wallpaper(name: string): void {
        p_matugen.wallpaper = name;
        p_matugen.running = true;
    }
}
