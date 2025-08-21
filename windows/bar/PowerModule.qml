import Quickshell
import QtQuick

import Quickshell.Services.UPower

import qs.util
import qs.services.system
import qs.widgets.controls

BarModule {
    text: profileChar() + " | " + 
        batteryChar() + " " + 
        MathUtil.roundPercentage(power) + "%";
    
    readonly property double power: Battery.percentage;

    moduleActive: power <= 0.20;

    statusColor: getStatusColor();

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
        switch (PowerProfiles.profile) {
            case 0: return "󰌪";
            case 1: return "󰗑";
            case 2: return "󱐋";
            default: return "󱈸";
        }
    }

    function getStatusColor(): string {
        if (!UPower.onBattery) return Colors.active;

        if (power <= 0.1) return Colors.error;
        if (power <= 0.2) return Colors.warning;
        return "";
    }

    // 0 is power saver
    // 1 is balanced
    // 2 is performance

    hoverContents: ModuleHoverContents {
        color: Colors.tertiary;

        implicitHeight: Styling.barHeight + Styling.spacing * 2;
        implicitWidth: (balancedButton.implicitWidth + Styling.spacing) * 3 - Styling.spacing + Styling.spacing * 2;

        bottomLeftRadius: Styling.barModuleRadius + Styling.spacing;
        bottomRightRadius: Styling.barModuleRadius + Styling.spacing;

        LabeledButton {
            id: balancedButton;

            anchors {
                verticalCenter: parent.verticalCenter;
                left: parent.left;

                margins: Styling.spacing;
            }

            text: "󰗑";

            textColor: PowerProfiles.profile == 1 ? Colors.active : Colors.secondary;

            onClicked: Battery.setProfile(1);
        }

        LabeledButton {
            id: performanceButton;

            anchors {
                centerIn: parent;
            }

            text: "󱐋"

            onClicked: Battery.setProfile(2);

            textColor: PowerProfiles.profile == 2 ? Colors.active : Colors.secondary;
        }

        LabeledButton {
            id: saverButton;

            anchors {
                verticalCenter: parent.verticalCenter;
                right: parent.right;

                margins: Styling.spacing;
            }

            text: "󰌪"

            onClicked: Battery.setProfile(0);

            textColor: PowerProfiles.profile == 0 ? Colors.active : Colors.secondary;
        }
    }
}