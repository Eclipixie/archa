pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.primitives

Item {
    id: root

    property string textColor: statusColor == "" ? Colors.secondary : statusColor;
    property string statusColor: "";

    property Component c_surface: Component { UIModule { } }

    property Component c_hoverContents

    property alias surface: surfaceLoader.item

    readonly property bool open: (surfaceHover.hovered || dropdownHover.hovered) && 
        root.c_hoverContents != null

    implicitWidth: open ? 
        Math.max(surfaceLoader.implicitWidth, dropdownLoader.implicitWidth) :
        surfaceLoader.implicitWidth
    implicitHeight: open ?
        surfaceLoader.implicitHeight + dropdownLoader.implicitHeight + Styling.spacing :
        surfaceLoader.implicitHeight

    Behavior on implicitHeight { Anim.NumberAnim { } }

    anchors {
        top: parent.top;
    }

    transitions: Transition { animations: [ Styling.AnchorEasing { } ] }

    Behavior on implicitWidth { animation: Styling.PropertyEasing { } }

    UIModule {
        color: Colors.tertiary

        radius: Styling.barModuleRadius + Styling.spacing

        anchors {
            fill: parent
            margins: -Styling.spacing
        }
    }

    Loader {
        id: dropdownLoader

        sourceComponent: root.c_hoverContents

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        HoverHandler {
            id: dropdownHover;
            acceptedDevices: PointerDevice.AllDevices;

            margin: Styling.spacing * 2
        }
    }

    Rectangle {
        color: Colors.tertiary

        anchors {
            fill: surfaceLoader
            margins: -Styling.spacing
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
