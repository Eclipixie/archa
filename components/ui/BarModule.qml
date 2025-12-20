pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.util.helpers
import qs.services.qs
import qs.components.primitives

UIModule {
    id: root

    property string text

    property bool moduleActive

    property ModuleHoverContents hoverContents: null;

    property string textColor: statusColor == "" ? Colors.secondary : statusColor;
    property string statusColor: "";

    property Component c_surface: Component {
        UITextModule {
            text.text: root.text
        }
    }

    function setActive(time: int): void {
        moduleActive = true;
        t_visible.interval = time;
        t_visible.restart();
    }

    Timer {
        id: t_visible
        interval: 1000
        onTriggered: root.moduleActive = false
    }

    property alias surface: surfaceLoader.item

    implicitWidth: surface.implicitWidth + Styling.spacing * 2;

    anchors {
        top: parent.top;
        bottom: parent.bottom;

        rightMargin: -Styling.spacing
        leftMargin: -Styling.spacing
    }

    color: Styling.barBackground ? Colors.tertiary : "transparent";

    topLeftRadius: 0;
    topRightRadius: 0;
    bottomLeftRadius: Styling.barModuleRadius + Styling.spacing
    bottomRightRadius: Styling.barModuleRadius + Styling.spacing

    transitions: Transition { animations: [ Styling.AnchorEasing { } ] }

    Behavior on implicitWidth { animation: Styling.PropertyEasing { } }

    Loader {
        id: surfaceLoader

        sourceComponent: root.c_surface

        anchors {
            right: root.right
            left: root.left
            bottom: root.bottom

            margins: Styling.spacing
        }
    }

    HoverHandler {
        id: mouseHover;
        acceptedDevices: PointerDevice.AllDevices;

        onHoveredChanged: {
            if (hovered && root.hoverContents != null)
                BarPopoutHelper.hoveredModule = root;
        }
    }
}
