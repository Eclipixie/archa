import QtQuick

import qs.config

Text {
    font: Styling.bodyFont

    color: Colors.secondary;

    Behavior on color { Anim.ColorAnim { } }

    Behavior on x { Anim.NumberAnim { } }
    Behavior on y { Anim.NumberAnim { } }
}