import QtQuick

import qs.config

Rectangle {
    id: root;

    color: Colors.primary;

    implicitHeight: Styling.barHeight;
    implicitWidth: Styling.barHeight;

    radius: Styling.barModuleRadius;

    border {
        color: Colors.tertiary;
        width: Styling.outlines;
    }

    Behavior on color { Anim.ColorAnim { } }

    Behavior on implicitWidth { Anim.NumberAnim { } }
    Behavior on implicitHeight { Anim.NumberAnim { } }
    Behavior on x { Anim.NumberAnim { } }
    Behavior on y { Anim.NumberAnim { } }
}