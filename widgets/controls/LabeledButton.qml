import Quickshell
import QtQuick
import QtQuick.Controls

import qs.util
import qs.windows

Button {
    id: root;

    property alias a_background: backgroundObject

    property bool forceSquare: true;

    background: UITextModule {
        id: backgroundObject;

        border.width: 0;

        implicitWidth: forceSquare ? Styling.barHeight : text.implicitWidth + 20;
    }
}