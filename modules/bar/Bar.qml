import QtQuick

import qs.components.ui
import qs.modules.bar.components
import qs.config
import qs.util.helpers

Item {
    id: row;

    implicitHeight: (Styling.barHeight + Styling.spacing * 2) * 2;

    anchors {
        right: parent.right;
        left: parent.left;
        verticalCenter: parent.top;
        
        rightMargin: Styling.spacing
        leftMargin: Styling.spacing
    }

    BarModule {
        color: Colors.tertiary;

        visible: Styling.barBackground;

        radius: 0;

        anchors {
            margins: 0;
            right: parent.right;
            left: parent.left;
        }

        c_surface: Component { Item { } }
    }

    SystemModule {
        id: systemModule;

        anchors.left: parent.left;
    }

    MPCModule {
        id: mpcModule;

        anchors.left: systemModule.right;
    }

    FSettingsModule {
        id: fSettingsModule;

        anchors.left: mpcModule.right;
    }

    BarModule {
        anchors.left: fSettingsModule.right;
        anchors.right: windowModule.left;

        visible: Styling.barSpacers;
    }

    WindowModule {
        id: windowModule;

        anchors.horizontalCenter: parent.horizontalCenter;
    }

    BarModule {
        anchors.left: windowModule.right;
        anchors.right: networkModule.left;

        visible: Styling.barSpacers;
    }

    NetworkModule {
        id: networkModule;

        anchors.right: powerModule.left;
    }

    PowerModule {
        id: powerModule

        anchors.right: timeModule.left;
    }

    TimeModule {
        id: timeModule

        anchors.right: parent.right;
    }

    Item {
        anchors {
            fill: BarPopoutHelper.targetModule;
            margins: -Styling.spacing * 2;
        }

        HoverHandler {
            id: mouseHover;
            acceptedDevices: PointerDevice.AllDevices;

            onHoveredChanged: {
                if (!hovered)
                    BarPopoutHelper.hoveredModule = null;
                else
                    BarPopoutHelper.hoveredModule = BarPopoutHelper.targetModule;
            }
        }
    }
}