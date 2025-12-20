pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.primitives

Item {
    id: root

    property bool moduleActive

    property string textColor: statusColor == "" ? Colors.secondary : statusColor;
    property string statusColor: "";

    property Component c_surface: Component { UIModule { } }

    property Component c_hoverContents

    property alias surface: surfaceLoader.item

    implicitWidth: dropdownLoader.active ? 
        Math.max(surfaceLoader.implicitWidth, dropdownLoader.implicitWidth) :
        surfaceLoader.implicitWidth
    implicitHeight: surfaceLoader.implicitHeight + dropdownLoader.implicitHeight

    anchors {
        top: parent.top;
        // bottom: parent.bottom;
    }

    transitions: Transition { animations: [ Styling.AnchorEasing { } ] }

    Behavior on implicitWidth { animation: Styling.PropertyEasing { } }

    Loader {
        id: dropdownLoader

        active: surfaceHover.hovered || dropdownHover.hovered

        sourceComponent: root.c_hoverContents

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            leftMargin: -Styling.spacing
            rightMargin: -Styling.spacing
        }

        HoverHandler {
            id: dropdownHover;
            acceptedDevices: PointerDevice.AllDevices;

            margin: Styling.spacing
        }
    }

    Loader {
        id: surfaceLoader

        sourceComponent: root.c_surface

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        HoverHandler {
            id: surfaceHover;
            acceptedDevices: PointerDevice.AllDevices;

            margin: Styling.spacing
        }
    }
}
