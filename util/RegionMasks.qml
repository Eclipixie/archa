import Quickshell
import QtQuick

import qs.modules.bar
import qs.modules.launcher

Scope {
    id: root

    property list<Item> maskSources

    property alias masks: panels.instances

    Variants {
        id: panels

        model: root.maskSources

        delegate: Region {
            required property Item modelData
            item: modelData
        }
    }
}
