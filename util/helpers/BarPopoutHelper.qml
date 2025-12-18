pragma Singleton

import Quickshell
import QtQuick

import qs.components.ui

Singleton {
    property int popoutWidth: targetModule?.hoverContents?.implicitWidth ?? 0;
    property int popoutHeight: targetModule?.hoverContents?.height ?? 0;

    property int targetCenterX: targetModule?.x + (targetModule?.width * .5) ?? 0;

    readonly property bool popoutActive: (hoveredModule != null) && (Visibilities.dashboard || targetModule.moduleActive);

    property BarModule targetModule: null;
    property BarModule hoveredModule: null;

    onHoveredModuleChanged: {
        if (hoveredModule != null)
            targetModule = hoveredModule;
    }
}
