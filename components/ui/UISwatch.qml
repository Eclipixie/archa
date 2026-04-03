pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import qs.config
import qs.components.primitives

Item {
    id: root

    implicitHeight: row.implicitHeight
    implicitWidth: collapsed ? Styling.barHeight : row.uncollapsedWidth

    property bool collapsed: false

    UIModule {
        anchors.fill: parent

        color: Colors.tertiary

        Behavior on implicitWidth { Anim.NumberAnim { duration: 0 } }
    }

    required property list<string> model

    property alias group: buttonGroup

    property int index: 0
    property string value: group[index]?.value ?? ""

    // do not rebind this, i can't make it readonly without breaking the behavior
    property double visualIndex: index
    Behavior on visualIndex { Anim.NumberAnim { } }

    signal clicked(newValue: string);

    Behavior on implicitWidth { Anim.NumberAnim { } }

    ButtonGroup {
        id: buttonGroup

        property int checkedButtonIndex: buttonIndex(checkedButton)

        function buttonIndex(button: UIButton): int {
            return buttons.indexOf(button)
        }
    }

    // todo: implement animations for the repeater here

    Row {
        id: row
        spacing: (root.width - (Styling.barHeight * repeater.count)) / (repeater.count - 1)

        property int uncollapsedWidth: repeater.count * (Styling.barHeight + Styling.spacing) - Styling.spacing

        Repeater {
            id: repeater

            model: root.model
            delegate: UIButton {
                required property var modelData

                property string value: modelData

                surface.text.text: value

                ButtonGroup.group: root.group

                onClicked: {
                    root.index = root.group.buttonIndex(this)

                    root.clicked(value)
                }
            }
        }
    }

    UIButton {
        id: selector

        enabled: false

        checked: true

        property double targetX: root.group.buttons[root.index]?.x ?? 0
        x: Math.max(0, Math.min(row.width - selector.width, 
            targetX + (Styling.barHeight + row.spacing) * (root.visualIndex - root.index))) ?? 0

        surface.text.text: root.group.buttons[root.index]?.value ?? ""
    }
}