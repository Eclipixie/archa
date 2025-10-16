import Quickshell
import QtQuick

import qs.util
import qs.util.helpers
import qs.windows
import qs.services.qs

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
        onTriggered: moduleActive = false
    }

    property alias surface: surfaceLoader.item

    implicitWidth: surface.implicitWidth + Styling.spacing * 2;

    state: (Visibilities.dashboard || moduleActive) ? "shown" : "hidden";

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

    states: [
        State {
            name: "hidden";
            AnchorChanges {
                target: root;
                anchors.top: parent.top;
                anchors.bottom: parent.verticalCenter;
            }
        },
        State {
            name: "shown";
            AnchorChanges {
                target: root;
                anchors.top: parent.verticalCenter;
                anchors.bottom: parent.bottom;
            }
        }
    ]

    transitions: Transition { animations: [ Styling.AnchorEasing { } ] }

    Behavior on implicitWidth { animation: Styling.PropertyEasing { } }

    Loader {
        id: surfaceLoader

        sourceComponent: c_surface

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
