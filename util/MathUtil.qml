pragma Singleton

import Quickshell
import QtQuick

Singleton {
    function roundPercentage(val: double): double {
        return Math.round(val * 100);
    }
}