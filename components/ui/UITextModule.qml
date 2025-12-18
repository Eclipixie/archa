import Quickshell
import QtQuick

import qs.components.primitives

UIModule {
    readonly property alias text: o_text

    implicitWidth: text.implicitWidth + (implicitHeight - text.implicitHeight) * 2

    UIText {
        id: o_text

        anchors.centerIn: parent
    }
}