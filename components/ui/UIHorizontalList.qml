pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.primitives

UIList {
    id: root
    orientation: Qt.Horizontal

    implicitHeight: Styling.barHeight
    spacing: Styling.spacing

    listEntry: Component {
        UIModule {
            id: surface;

            required property var modelData
            readonly property string name: modelData.name

            property bool focused: false

            color: focused ? Colors.secondary : Colors.primary;

            implicitWidth: (root.width - Styling.spacing * (root.model.length - 1)) / root.model.length;

            UIText {
                text: surface.name;
                color: surface.focused ? Colors.primary : Colors.secondary;

                anchors {
                    horizontalCenter: parent.horizontalCenter;
                    verticalCenter: parent.verticalCenter;

                    leftMargin: (parent.height - height) * .5 + 5;
                }
            }
        }
    }
}