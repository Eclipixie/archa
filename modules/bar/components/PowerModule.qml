pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.UPower

import qs.config
import qs.services.system
import qs.components.ui

BarModule {
    id: root

    text: profileChar() + " | " + 
        batteryChar() + " " + 
        MathUtil.roundPercentage(power) + "%";
    
    readonly property double power: Battery.percentage;

    moduleActive: power <= 0.20;

    statusColor: getStatusColor();

    readonly property ProfileInfo currentProfile: profiles[PowerProfiles.profile]

    readonly property list<QtObject> profiles: [
        ProfileInfo {
            name: "saver"
            icon: "󰌪"
            color: Colors.active
        },
        ProfileInfo {
            name: "balanced"
            icon: "󰗑"
            color: Colors.secondary
        },
        ProfileInfo {
            name: "performance"
            icon: "󱐋"
            color: Colors.error
        }
    ]

    function batteryChar(): string {
        if (UPower.onBattery) {
            if(power <= 0.1) { return "󰂃" }
            if(power <= 0.2) { return "󰁻" }
            if(power <= 0.3) { return "󰁼" }
            if(power <= 0.4) { return "󰁽" }
            if(power <= 0.5) { return "󰁾" }
            if(power <= 0.6) { return "󰁿" }
            if(power <= 0.7) { return "󰂀" }
            if(power <= 0.8) { return "󰂁" }
            if(power <= 0.9) { return "󰂂" }
            return "󰁹";
        }
        else {
            if(power <= 0.1) { return "󰢜" }
            if(power <= 0.2) { return "󰂆" }
            if(power <= 0.3) { return "󰂇" }
            if(power <= 0.4) { return "󰂈" }
            if(power <= 0.5) { return "󰢝" }
            if(power <= 0.6) { return "󰂉" }
            if(power <= 0.7) { return "󰢞" }
            if(power <= 0.8) { return "󰂊" }
            if(power <= 0.9) { return "󰂋" }
            return "󰂅";
        }
    }

    function profileChar(): string {
        return profiles[PowerProfiles.profile].icon;
    }

    function profileColor(): string {
        return profiles[PowerProfiles.profile].color;
    }

    function getStatusColor(): string {
        if (!UPower.onBattery) return Colors.active;

        if (power <= 0.1) return Colors.error;
        if (power <= 0.2) return Colors.warning;
        return Colors.secondary;
    }

    c_surface: Component {
        Item {
            implicitHeight: Styling.barHeight
            implicitWidth: profileReadout.implicitWidth + powerReadout.implicitWidth + Styling.spacing

            UITextModule {
                id: profileReadout

                implicitWidth: Styling.barHeight

                topRightRadius: 0
                bottomRightRadius: 0

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                text.text: root.profileChar()
            }

            UITextModule {
                id: powerReadout

                topLeftRadius: 0
                bottomLeftRadius: 0

                anchors {
                    left: profileReadout.right
                    verticalCenter: parent.verticalCenter

                    leftMargin: Styling.spacing
                }

                text.text: root.batteryChar() + " " + MathUtil.roundPercentage(root.power) + "%"
                text.color: root.getStatusColor()
            }
        }
    }

    // 0 is power saver
    // 1 is balanced
    // 2 is performance

    hoverContents: ModuleHoverContents {
        color: Colors.tertiary;

        implicitHeight: Styling.barHeight + Styling.spacing * 2;
        implicitWidth: (Styling.barHeight + Styling.spacing) * 3 + Styling.spacing;

        bottomLeftRadius: Styling.barModuleRadius + Styling.spacing;
        bottomRightRadius: Styling.barModuleRadius + Styling.spacing;

        UISwatch {
            id: selector

            anchors {
                top: parent.top
                left: parent.left
                topMargin: Styling.spacing
                leftMargin: Styling.spacing
            }

            model: [root.profiles[0].icon, root.profiles[1].icon, root.profiles[2].icon]

            group.checkedButton: group.buttons[PowerProfiles.profile]

            onValueChanged: {
                Battery.setProfile(group.checkedButtonIndex);
            }
        }
    }

    component ProfileInfo: QtObject {
        required property string name
        required property string icon
        required property string color
    }
}