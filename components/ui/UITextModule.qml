import QtQuick

import qs.components.primitives

UIModule {
    property UIText text: o_text

    readonly property double textMargin: implicitHeight - text.implicitHeight

    implicitWidth: text.implicitWidth + textMargin * 2

    clip: true

    UIText {
        id: o_text

        anchors.centerIn: parent
    }
}