import QtQuick
import QtQuick.Controls

import qs.config

Button {
    id: root;

    property alias a_background: backgroundObject

    property bool forceSquare: true;

    contentItem: null
    indicator: null

    background: UITextModule {
        id: backgroundObject;

        border.width: 0;

        implicitWidth: root.forceSquare ? Styling.barHeight : text.implicitWidth + 20;

        color: root.checked ? Colors.secondary : Colors.primary
        text.color: root.checked ? Colors.primary : Colors.secondary
    }
}