pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import qs.config
import qs.components.primitives

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: Styling.barHeight

    required property list<string> model

    property alias group: buttonGroup

    property string value: ""

    ButtonGroup {
        id: buttonGroup

        property int checkedButtonIndex: buttons.indexOf(checkedButton)
    }

    UIModule {
        implicitHeight: row.implicitHeight
        implicitWidth: row.implicitWidth

        Row {
            id: row
            spacing: Styling.spacing

            Repeater {
                model: root.model
                delegate: UIRadioButton {
                    required property var modelData

                    a_background.text.text: modelData

                    ButtonGroup.group: buttonGroup

                    onClicked: {
                        root.value = modelData;
                    }
                }
            }
        }
    }
}