pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.components.primitives

Item {
    id: root

    property string statusColor: "";

    property Item surface: surfaceObject

    // misleading name, should change later
    property Component hoverContents

    // flag to actually render the drawer
    // this should never be controlled by something other than BarModule unless absolutely necessary
    //    (i don't know if i can scope this properly)
    property bool drawerVisible: false

    // whether the drawer is open
    readonly property bool open: (surfaceHover.hovered || dropdownHover.hovered) && 
        root.hoverContents != null

    onOpenChanged: if (open) drawerVisible = true

    implicitWidth: open ? 
        Math.max(surface.implicitWidth, dropdownLoader.implicitWidth) :
        surface.implicitWidth
    implicitHeight: drawerVisible ?
        surface.implicitHeight + dropdownLoader.implicitHeight + Styling.spacing * 2 :
        surface.implicitHeight

    Behavior on implicitHeight { Anim.NumberAnim { duration: 0 } }

    anchors {
        top: parent.top;
    }

    Behavior on implicitWidth { animation: Anim.NumberAnim { } }

    UIModule {
        id: background

        color: Colors.tertiary

        visible: root.drawerVisible
        opacity: root.open ? 1 : 0

        Behavior on opacity { Anim.NumberAnim {
            onRunningChanged: if (!running) root.drawerVisible = (background.opacity == 1)
        } }

        radius: Styling.barModuleRadius + Styling.spacing

        anchors {
            fill: parent
            // margins: root.open ? -Styling.spacing : 0
        }
    }

    Loader {
        id: dropdownLoader

        active: root.drawerVisible
        opacity: root.open ? 1 : 0

        Behavior on opacity { Anim.NumberAnim { } }

        sourceComponent: root.hoverContents

        anchors {
            bottom: background.bottom
            left: background.left
            right: background.right

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

            // so, idk why, but having this be negative is the only way i can get the 
            //    drawer to remain open when the surface is not hovered.
            margin: -Styling.spacing
        }
    }
}
