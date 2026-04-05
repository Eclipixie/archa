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

        property double thetaDelta: (Styling.barHeight + Styling.spacing) / radius

        RadialContainer {
            theta: radial.minTheta + radial.thetaDelta
            radius: radial.radius

            BatteryReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            theta: radial.minTheta + radial.thetaDelta * 2
            radius: radial.radius

            TempReadout {
                primaryZone: "x86_pkg_temp"

                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            theta: radial.minTheta + radial.thetaDelta * 3
            radius: radial.radius

            NetworkReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        component RadialContainer: Item {
            width: childrenRect.width
            height: childrenRect.height

            required property double theta
            required property double radius

            x: -width + Styling.barHeight / 2 + Math.cos(theta) * radius
            y: -height / 2 + Math.sin(theta) * radius
        }
    }
}
