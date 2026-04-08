pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.components.primitives
import qs.config
import qs.services.qs
import qs.components.readouts

Item {
    id: root

    property double size: 150

    implicitHeight: size
    implicitWidth: size

    enum DisplayState {
        Normal,
        StackVertical
    }

    property int displayState: Radial.DisplayState.Normal

    UIModule {
        id: center

        property double sizeRadius: root.size / 2

        implicitWidth: sizeRadius * 2
        implicitHeight: sizeRadius * 2

        radius: sizeRadius

        anchors {
            right: root.right
            bottom: root.bottom
            margins: -sizeRadius * (1 - Math.sqrt(0.5))
        }
    }

    Item {
        id: radial

        anchors.centerIn: center

        property double radius: (root.size + Styling.barHeight) / 2 + Styling.spacing

        property double maxOffset: center.sizeRadius - center.anchors.margins - Styling.barHeight * 2 - Styling.spacing

        property double minTheta: Math.PI - Math.asin(maxOffset / radius)
        property double maxTheta: -Math.acos(maxOffset / radius)

        RadialContainer {
            minTheta: radial.minTheta
            index: 1
            radius: radial.radius

            BatteryReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            minTheta: radial.minTheta
            index: 2
            radius: radial.radius

            TempReadout {
                primaryZone: "x86_pkg_temp"

                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            minTheta: radial.minTheta
            index: 3
            radius: radial.radius

            NetworkReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            minTheta: radial.minTheta
            index: 4
            radius: radial.radius

            MPCReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        component RadialContainer: Item {
            width: childrenRect.width
            height: childrenRect.height

            required property int minTheta
            required property int index
            required property double radius

            readonly property double thetaDelta: (Styling.barHeight + Styling.spacing) / radius
            readonly property double theta: minTheta + thetaDelta * (index + 2)

            x: -width + Styling.barHeight / 2 + Math.cos(theta) * radius

            y: root.displayState == Radial.DisplayState.Normal ? 
                -height / 2 + Math.sin(theta) * radius :
                -height / 2 + Math.sin(minTheta) * radius + index * Styling.barHeight
        }
    }
}
