import Quickshell
import QtQuick
import Quickshell.Io

import qs.services.apps
import qs.components.ui

ListCommand {
    id: root

    property Connections c_matugen: Connections {
        target: Matugen

        function onWallpapersChanged(): void {
            root.sublist = []
            
            let wallpapers = Matugen.wallpapers;

            for (let i = 0; i < wallpapers.length; i++) {
                sublist.push(setWallpaper.createObject(null, { name: wallpapers[i] }));
            }
        }
    }

    property Component setWallpaper: Component { ListCommand {
        onExec: { Matugen.wallpaper(name); }
    } }
}
