pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root;

    property double spacing: 4;
    property double outlines: 0;
    property double barHeight: 40;
    property double barModuleRadius: barRadiusMode.capsule;
    property double barFontPointSize: barHeight / 3;

    property double lockScreenFontPointSize: 80;

    property string fontFamily: "FiraCode Nerd Font Propo";
    property list<string> availableFonts: []

    property bool barSpacers: true;
    property bool barBackground: true;

    component AnchorEasing: AnchorAnimation {
        duration: 300;
        easing.type: Easing.OutQuint;
    }

    component PropertyEasing: PropertyAnimation {
        duration: 300;
        easing.type: Easing.OutQuint
    }

    property var barRadiusMode: QtObject {
        property double square: 0;
        property double rounded: 7;
        property double capsule: root.barHeight / 2;
    }

    Process {
        id: p_getFonts
        running: true
        command: ["sh", "-c", "fc-list | grep Nerd | grep style=Regular"]

        stdout: StdioCollector {
            onStreamFinished: {
                let list = this.text.trim().split("\n");

                for (let i = 0; i < list.length; i++)
                    list[i] = list[i].split(":")[1].trim();

                root.availableFonts = list;
            }
        }
    }
}
