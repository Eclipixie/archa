pragma Singleton

import Quickshell
import QtQuick

import qs.config

Singleton {
    id: root

    property int duration: 200
    property var easing: Easing.InOutCubic

    component NumberAnim: NumberAnimation {
        duration: Anim.duration
        easing.type: Anim.easing
    }

    component ColorAnim: ColorAnimation {
        duration: Anim.duration
        easing.type: Anim.easing
    }
}
