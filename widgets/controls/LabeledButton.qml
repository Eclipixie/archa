import Quickshell
import QtQuick
import QtQuick.Controls

import qs.util
import qs.windows

Button {
    id: root;

    property string textColor: root.enabled ? Colors.secondary : Colors.inactive;

    property bool forceSquare: true;

    background: UIModule {
        id: backgroundObject;

        border.width: 0;

        implicitWidth: forceSquare ? Styling.barHeight : text.implicitWidth + 20;
    }

    contentItem: Item {
        anchors.fill: backgroundObject;

        UIText {
            id: text;

            text: root.text;
            color: root.textColor;

            anchors.centerIn: parent;
        }
    }
}