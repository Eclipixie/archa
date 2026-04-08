pragma ComponentBehavior: Bound

import QtQuick

import qs.components.primitives
import qs.config
import qs.services.qs
import qs.components.readouts

Item {
    id: root

    property double size: 150

    implicitHeight: size
    implicitWidth: size

    property list<Item> regionMasks: [
        center
    ].concat(radial.children)

    enum DisplayMode {
        Theta,
        Y
    }

    property int displayState: Visibilities.superDown ? Radial.DisplayMode.Y : Radial.DisplayMode.Theta

    UIModule {
        id: center

        implicitWidth: radius * 2
        implicitHeight: radius * 2

        radius: (root.size + offset) / 2

        property double offset: root.size * (1 - Math.sqrt(0.5)) / (1 + Math.sqrt(0.5))

        anchors {
            right: root.right
            bottom: root.bottom
            margins: -offset
        }
    }

    Item {
        id: radial

        // acts as a sort of centered anchor point to make working with the radials easier
        //    (do not enable clip)
        width: 0
        height: 0

        anchors.centerIn: center

        property double radius: (root.size + Styling.barHeight) / 2 + Styling.spacing

        property double maxOffset: center.radius - center.anchors.margins - Styling.barHeight * 2 - Styling.spacing

        property double minTheta: Math.asin(
            (Styling.spacing + Styling.barHeight / 2 - (center.radius - center.offset))/
            (center.radius + Styling.spacing + Styling.barHeight / 2))

        RadialContainer {
            minTheta: radial.minTheta
            index: 0
            radius: radial.radius

            BatteryReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            minTheta: radial.minTheta
            index: 1
            radius: radial.radius

            TempReadout {
                primaryZone: "x86_pkg_temp"

                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            minTheta: radial.minTheta
            index: 2
            radius: radial.radius

            NetworkReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        RadialContainer {
            minTheta: radial.minTheta
            index: 3
            radius: radial.radius

            MPCReadout {
                state: Visibilities.superDown ? "bar" : "icon"
            }
        }

        component RadialContainer: Item {
            width: childrenRect.width
            height: Styling.barHeight

            required property double minTheta
            required property int index
            required property double radius

            readonly property double thetaDelta: (Styling.barHeight + Styling.spacing) / radius
            readonly property double theta: minTheta + index * (Styling.spacing + Styling.barHeight) / (center.radius + Styling.spacing + Styling.barHeight / 2)

            readonly property double yRelativeTheta: Math.asin((y + height - Styling.barHeight / 2) / (center.radius + Styling.spacing + Styling.barHeight / 2))

            Behavior on y { Anim.NumberAnim { } }

            x: -(center.radius + Styling.spacing + Styling.barHeight / 2) * 
                Math.cos(yRelativeTheta) - 
                width + Styling.barHeight / 2

            y: root.displayState == Radial.DisplayMode.Theta ?
                -(center.radius + Styling.spacing + Styling.barHeight / 2) * Math.sin(theta) - height + Styling.barHeight / 2 :
                center.radius - (center.offset + Styling.spacing + Styling.barHeight + index * (Styling.spacing + Styling.barHeight))
        }
    }
}
