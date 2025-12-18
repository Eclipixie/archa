pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

import qs.services.system

Singleton {
    property string wallpaperLoc: "/Pictures/wallpapers/"

    property string absWallpaperLoc: System.home + wallpaperLoc

    property list<string> wallpapers: []

    Process {
        id: p_getWallpapers
        command: ["ls", absWallpaperLoc]
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
        command: ["matugen", "image", absWallpaperLoc + wallpaper]
    }

    function wallpaper(name: string): void {
        p_matugen.wallpaper = name;
        p_matugen.running = true;
    }
}
