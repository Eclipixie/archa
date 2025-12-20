import Quickshell
import QtQuick

import qs.modules.bar

Scope {
    id: root

    required property Bar bar

    property list<Item> items: bar?.regionMasks ?? []

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
