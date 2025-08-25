import Quickshell
import QtQuick

UIModule {
    readonly property UIText text: o_text

    implicitWidth: text.implicitWidth + (implicitHeight - text.implicitHeight) * 2

    UIText {
        id: o_text

        anchors.centerIn: parent
    }
}