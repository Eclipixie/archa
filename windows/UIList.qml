import Quickshell
import QtQuick

import qs.util

ListView {
    id: root;

    implicitHeight: model.length * (Styling.barHeight + Styling.spacing) - Styling.spacing;

    delegate: listEntry;

    property Component listEntry: Component {
        Item {
            id: wrapper;
            required property var modelData
            required property int index
            readonly property string name: modelData.name
            
            property bool focused: false

            width: root.width;
            implicitHeight: surface.height + Styling.spacing;

            UIModule {
                id: surface;

                color: focused ? Colors.secondary : Colors.primary;

                anchors {
                    top: wrapper.top;
                    right: wrapper.right;
                    left: wrapper.left;
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: { root.currentIndex = index; }
                }

                UIText {
                    text: name;
                    color: focused ? Colors.primary : Colors.secondary;

                    anchors {
                        left: parent.left;
                        verticalCenter: parent.verticalCenter;

                        leftMargin: (parent.height - height) * .5 + 5;
                    }
                }
            }
        }
    }
}
