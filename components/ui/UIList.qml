pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.primitives

ListView {
    id: root;

    delegate: listEntry;

    boundsBehavior: Flickable.DragAndOvershootBounds

    spacing: Styling.spacing

    property Component listEntry: Component {
        UITextModule {
            id: delegateRoot;
            required property var modelData
            required property int index
            readonly property string name: modelData.name
            
            property bool focused: false

            width: root.width;

            color: delegateRoot.focused ? Colors.secondary : Colors.primary;

            radius: 0

            MouseArea {
                anchors.fill: parent

                onClicked: { root.currentIndex = delegateRoot.index; }
            }

            text {
                text: delegateRoot.name;
                color: delegateRoot.focused ? Colors.primary : Colors.secondary;

                anchors {
                    centerIn: undefined
                    left: delegateRoot.left
                    verticalCenter: delegateRoot.verticalCenter
                    margins: Styling.spacing * 2
                }
            }
        }
    }
}
