pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Services.UPower

import qs.services.system
import qs.config

Singleton {
    id: root
    property string bat_id: System.batteryID
    property string currentCharge: "0"
    property string fullCharge: "1"

    property double percentage: Number(currentCharge) / Number(fullCharge)
    property string prettyPercentage: MathUtil.roundPercentage(percentage) + "%"

    function batteryChar(): string {
        if (UPower.onBattery) {
            if (root.percentage <= 0.1) { return "󰂃" }
            if (root.percentage <= 0.2) { return "󰁻" }
            if (root.percentage <= 0.3) { return "󰁼" }
            if (root.percentage <= 0.4) { return "󰁽" }
            if (root.percentage <= 0.5) { return "󰁾" }
            if (root.percentage <= 0.6) { return "󰁿" }
            if (root.percentage <= 0.7) { return "󰂀" }
            if (root.percentage <= 0.8) { return "󰂁" }
            if (root.percentage <= 0.9) { return "󰂂" }
            return "󰁹";
        }
        else {
            if (root.percentage <= 0.1) { return "󰢜" }
            if (root.percentage <= 0.2) { return "󰂆" }
            if (root.percentage <= 0.3) { return "󰂇" }
            if (root.percentage <= 0.4) { return "󰂈" }
            if (root.percentage <= 0.5) { return "󰢝" }
            if (root.percentage <= 0.6) { return "󰂉" }
            if (root.percentage <= 0.7) { return "󰢞" }
            if (root.percentage <= 0.8) { return "󰂊" }
            if (root.percentage <= 0.9) { return "󰂋" }
            return "󰂅";
        }
    }

    function getStatusColor(): string {
        if (!UPower.onBattery) return Colors.active;

        if (root.percentage <= 0.1) return Colors.tertiary;
        if (root.percentage <= 0.2) return Colors.warning;
        return Colors.secondary;
    }

    onCurrentChargeChanged: {
        if (percentage <= .2)
            Colors.gradientActive = false;
        else 
            Colors.gradientActive = Colors.preferredGradientActive;
    }

    function calcCharge(): double {
        return Number(currentCharge) / Number(fullCharge);
    }

    function setProfile(profile) {
        PowerProfiles.profile = profile;
    }

    Process {
        id: p_checkCurrent;
        command: ["cat", "/sys/class/power_supply/"+root.bat_id+"/charge_now"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: { root.currentCharge = this.text; }
        }
    }

    Process {
        id: p_checkMax;
        command: ["cat", "/sys/class/power_supply/"+root.bat_id+"/charge_full"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: { root.fullCharge = this.text; }
        }
    }

    property int counter: 0;

    // check percentage every minute, check capacity every hour
    function tick() {
        p_checkCurrent.running = true;

        counter++;

        if (counter > 60) {
            counter = 0;
            p_checkMax.running = true;
        }
    }

    Timer {
        // pretty sure this is one minute
        interval: 60000;
        running: true;
        repeat: true;
        onTriggered: root.tick();
    }
}
