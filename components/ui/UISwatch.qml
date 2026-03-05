pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import qs.config
import qs.components.primitives

UIModule {
    id: root

    implicitHeight: row.implicitHeight
    implicitWidth: collapsed ? Styling.barHeight : row.implicitWidth

    Behavior on implicitWidth { Anim.NumberAnim { } }

    property bool collapsed: false

    required property list<string> model

    property alias group: buttonGroup

    property int index: 0
    property string value: group[index]?.value ?? ""

    signal clicked(newValue: string);

    ButtonGroup {
        id: buttonGroup

        property int checkedButtonIndex: buttonIndex(checkedButton)

        function buttonIndex(button: UIButton): int {
            return buttons.indexOf(button)
        }
    }

    Row {
        id: row
        spacing: Styling.spacing

        Repeater {
            model: root.model
            delegate: UIButton {
                required property var modelData

                property string value: modelData

                a_background.text.text: value

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

        Behavior on x { Anim.NumberAnim { } }

        x: root.collapsed ? 
            (root.implicitWidth - Styling.barHeight) / 2
            : Math.min(root.group.buttons[root.index]?.x, root.implicitWidth - Styling.barHeight) ?? 0

        a_background.text.text: root.group.buttons[root.index]?.value ?? ""
    }
}