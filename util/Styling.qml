pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root;

    property double spacing: 4;
    property double outlines: 0;
    property double barHeight: 30;
    property double barModuleRadius: barRadiusMode.capsule;
    property double barFontPointSize: barHeight / 3;

    property double lockScreenFontPointSize: 80;

    property string fontFamily: "FiraCode Nerd Font Propo";

    property bool barSpacers: true;
    property bool barBackground: true;

    property AnchorAnimation anchorEasing: AnchorAnimation {
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
}
