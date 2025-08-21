pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Services.UPower

import qs.util

Singleton {
    id: root
    property string bat_id: "BAT0";
    property string currentCharge: "0";
    property string fullCharge: "1";

    property double percentage: calcCharge();

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
        id: checkCurrent;
        command: ["cat", "/sys/class/power_supply/"+bat_id+"/charge_now"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: { root.currentCharge = this.text; }
        }
    }

    Process {
        id: checkMax;
        command: ["cat", "/sys/class/power_supply/"+bat_id+"/charge_full"];
        running: true;

        stdout: StdioCollector {
            onStreamFinished: { root.fullCharge = this.text; }
        }
    }

    property int counter: 0;

    function tick() {
        checkCurrent.running = true;

        counter++;

        if (counter > 60) {
            counter = 0;
            checkMax.running = true;
        }
    }

    Timer {
        // pretty sure this is one minute
        interval: 60000;
        running: true;
        repeat: true;
        onTriggered: tick();
    }
}
