import Quickshell
import QtQuick

import qs.util
import qs.util.helpers
import qs.windows
import qs.services.qs

UIModule {
    id: root

    property string text;

    property bool moduleActive;

    property ModuleHoverContents hoverContents: null;

    property string textColor: statusColor == "" ? Colors.secondary : statusColor;
    property string statusColor: "";

    implicitWidth: text.implicitWidth + (height - text.implicitHeight) + 10 + Styling.outlines;

    state: (Visibilities.dashboard || moduleActive) ? "shown" : "hidden";

    anchors {
        top: parent.top;
        bottom: parent.bottom;
    }

    color: Styling.barBackground ? Colors.tertiary : "transparent";

    topLeftRadius: 0;
    topRightRadius: 0;

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

    transitions: Transition { animations: [ Styling.anchorEasing ]; }

    Behavior on implicitWidth { animation: Styling.sizeEasing; }

    UIModule {
        anchors {
            fill: parent;

            margins: Styling.spacing;
        }

        UIText {
            id: text;

            anchors.centerIn: parent;

            anchors {
                margins: Styling.spacing;
            }

            text: root.text;

            color: root.textColor;
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
