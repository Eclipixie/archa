import Quickshell
import QtQuick
import QtQuick.Controls

import qs.util
import qs.widgets.controls

UITextModule {
    id: root

    implicitWidth: Styling.barHeight

    color: Colors.secondary
    text.color: Colors.primary
    text.text: state

    property list<QtObject> options

    states: variants.instances

    Variants {
        id: variants

        model: options

        delegate: State {
            required property var modelData
            readonly property Item item: modelData.item
            name: modelData.name

            AnchorChanges {
                target: root

                anchors.left: item.left
                anchors.right: item.right
                anchors.top: item.top
                anchors.bottom: item.bottom
            }
        }
    }

    transitions: Transition {
        Styling.AnchorEasing { }
    }

    component OptionData: QtObject {
        required property Item item
        required property string name
    }

    property Component c_OptionData: OptionData { }
}