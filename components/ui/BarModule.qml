pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.primitives

Item {
    id: root

    property string textColor: statusColor == "" ? Colors.secondary : statusColor;
    property string statusColor: "";

    property Item surface: surfaceObject

    // property Component c_surface: Component { UIModule { } }

    property Component c_hoverContents

    readonly property bool open: (surfaceHover.hovered || dropdownHover.hovered) && 
        root.c_hoverContents != null

    implicitWidth: open ? 
        Math.max(surface.implicitWidth, dropdownLoader.implicitWidth) :
        surface.implicitWidth
    implicitHeight: open ?
        surface.implicitHeight + dropdownLoader.implicitHeight + Styling.spacing * 2 :
        surface.implicitHeight

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
            // margins: root.open ? -Styling.spacing : 0
        }
    }

    Loader {
        id: dropdownLoader

        active: root.open

        sourceComponent: root.c_hoverContents

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: Styling.spacing
        }

        HoverHandler {
            id: dropdownHover;
            acceptedDevices: PointerDevice.AllDevices;

            margin: Styling.spacing * 2
        }
    }

    Item {
        id: surfaceObject

        implicitHeight: Styling.barHeight

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
