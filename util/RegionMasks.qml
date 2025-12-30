import Quickshell
import QtQuick

import qs.modules.bar
import qs.modules.launcher

Scope {
    id: root

    required property Bar bar
    required property Launcher launcher

    property list<Item> items: (bar.regionMasks).concat(launcher.regionMasks)

    property alias masks: panels.instances

    Variants {
        id: panels

        model: root.items

        delegate: Region {
            required property Item modelData
            item: modelData
        }
    }
}
