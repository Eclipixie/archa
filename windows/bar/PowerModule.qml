import Quickshell
import QtQuick

import Quickshell.Services.UPower

import qs.util
import qs.services.system
import qs.widgets.controls
import qs.windows

BarModule {
    text: profileChar() + " | " + 
        batteryChar() + " " + 
        MathUtil.roundPercentage(power) + "%";
    
    readonly property double power: Battery.percentage;

    moduleActive: power <= 0.20;

    statusColor: getStatusColor();

    readonly property ProfileInfo currentProfile: profiles[PowerProfiles.profile]

    readonly property list<ProfileInfo> profiles: [
        ProfileInfo {
            name: "saver"
            icon: "󰌪"
            color: Colors.active
            button: saverButton
        },
        ProfileInfo {
            name: "balanced"
            icon: "󰗑"
            color: Colors.secondary
            button: balancedButton
        },
        ProfileInfo {
            name: "performance"
            icon: "󱐋"
            color: Colors.error
            button: performanceButton
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

                text.text: profileChar()
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

                text.text: batteryChar() + " " + MathUtil.roundPercentage(power) + "%"
                text.color: getStatusColor()
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

        LabeledButton {
            id: saverButton

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                margins: Styling.spacing
            }

            a_background.text.text: profiles[0].icon
            onClicked: { Battery.setProfile(0) }
        }

        LabeledButton {
            id: balancedButton

            anchors {
                verticalCenter: parent.verticalCenter
                left: saverButton.right
                margins: Styling.spacing
            }

            a_background.text.text: profiles[1].icon
            onClicked: { Battery.setProfile(1) }
        }

        LabeledButton {
            id: performanceButton

            anchors {
                verticalCenter: parent.verticalCenter
                left: balancedButton.right
                margins: Styling.spacing
            }

            a_background.text.text: profiles[2].icon
            onClicked: { Battery.setProfile(2) }
        }

        UISwatch {
            id: selector

            state: currentProfile.icon

            options: [
                UISwatch.OptionData { 
                    name: profiles[0].icon;
                    item: saverButton
                },
                UISwatch.OptionData { 
                    name: profiles[1].icon;
                    item: balancedButton
                },
                UISwatch.OptionData { 
                    name: profiles[2].icon;
                    item: performanceButton
                }
            ]
        }
    }

    component ProfileInfo: QtObject {
        required property string name
        required property string icon
        required property string color
        required property Item button
    }
}