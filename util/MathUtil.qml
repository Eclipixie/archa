pragma Singleton

import Quickshell
import QtQuick

Singleton {
    function roundPercentage(val: real): real {
        return Math.round(val * 100);
    }

    function toDegrees(millidegrees: int): real {
        return millidegrees / 1000
    }
}