pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property SystemClock clock: sysClock;

    SystemClock {
        id: sysClock;
        precision: SystemClock.Seconds;
    }
}
