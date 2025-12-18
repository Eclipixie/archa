import Quickshell
import QtQuick

import qs.config

Rectangle {
    id: root;

    color: Colors.primary;

    implicitHeight: Styling.barHeight + border.width * 2;
    implicitWidth: Styling.barHeight;

    radius: Styling.barModuleRadius;

    border {
        color: Colors.tertiary;
        width: Styling.outlines;
    }
}