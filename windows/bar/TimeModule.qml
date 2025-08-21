import Quickshell
import QtQuick

import qs.services.system

BarModule {
    id: root;

    text: timeChar() + " " + Qt.formatDateTime(Time.clock.date, "hh:mm:ss");

    function timeChar(): string {
        var hr = parseInt(Qt.formatDateTime(Time.clock.date, "hh"));

        var chars = [
            "󱑖", "󱑋", "󱑌", "󱑍", "󱑎", "󱑏",
            "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕"
        ];

        return chars[hr % 12];
    }
}