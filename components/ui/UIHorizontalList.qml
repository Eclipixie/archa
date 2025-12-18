import Quickshell
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
            required property var modelData
            readonly property string name: modelData.name

            property bool focused: false
            id: surface;

            color: focused ? Colors.secondary : Colors.primary;

            implicitWidth: (root.width - Styling.spacing * (root.model.length - 1)) / root.model.length;

            UIText {
                text: name;
                color: focused ? Colors.primary : Colors.secondary;

                anchors {
                    horizontalCenter: parent.horizontalCenter;
                    verticalCenter: parent.verticalCenter;

                    leftMargin: (parent.height - height) * .5 + 5;
                }
            }
        }
    }
}