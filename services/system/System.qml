pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.services.qs

Singleton {
    id: root

    property string home: "/home/eclipixie"
    property string batteryID: "BAT0"
    property string backlightID: "acpi_video0"

    property real cpuPerc
    property string gpuType: "NONE"
    property real gpuPerc
    property real memUsed
    property real memTotal
    readonly property real memPerc: memTotal > 0 ? memUsed / memTotal : 0
    property real storageUsed
    property real storageTotal
    property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    property real lastCpuIdle
    property real lastCpuTotal

    property int refCount

    function formatKib(kib: real): var {
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        if (kib >= tib)
            return {
                value: kib / tib,
                unit: "TiB"
            };
        if (kib >= gib)
            return {
                value: kib / gib,
                unit: "GiB"
            };
        if (kib >= mib)
            return {
                value: kib / mib,
                unit: "MiB"
            };
        return {
            value: kib,
            unit: "KiB"
        };
    }

    Timer {
        // running: root.refCount > 0
        running: true
        interval: 3000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            f_stat.reload();
            f_meminfo.reload();
            p_storage.running = true;
            p_gpuUsage.running = true;
        }
    }

    FileView {
        id: f_stat

        path: "/proc/stat"
        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (data) {
                const stats = data.slice(1).map(n => parseInt(n, 10));
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3] + (stats[4] ?? 0);

                const totalDiff = total - root.lastCpuTotal;
                const idleDiff = idle - root.lastCpuIdle;
                root.cpuPerc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;

                root.lastCpuTotal = total;
                root.lastCpuIdle = idle;
            }
        }
    }

    FileView {
        id: f_meminfo

        path: "/proc/meminfo"
        onLoaded: {
            const data = text();
            root.memTotal = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.memUsed = (root.memTotal - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process {
        id: p_storage

        command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $1, $3, $4}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const deviceMap = new Map();

                for (const line of text.trim().split("\n")) {
                    if (line.trim() === "")
                        continue;

                    const parts = line.trim().split(/\s+/);
                    if (parts.length >= 3) {
                        const device = parts[0];
                        const used = parseInt(parts[1], 10) || 0;
                        const avail = parseInt(parts[2], 10) || 0;

                        // Only keep the entry with the largest total space for each device
                        if (!deviceMap.has(device) || (used + avail) > (deviceMap.get(device).used + deviceMap.get(device).avail)) {
                            deviceMap.set(device, {
                                used: used,
                                avail: avail
                            });
                        }
                    }
                }

                let totalUsed = 0;
                let totalAvail = 0;

                for (const [device, stats] of deviceMap) {
                    totalUsed += stats.used;
                    totalAvail += stats.avail;
                }

                root.storageUsed = totalUsed;
                root.storageTotal = totalUsed + totalAvail;
            }
        }
    }

    Process {
        id: p_gpuTypeCheck

        running: true
        command: ["sh", "-c", "if ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | grep -q .; then echo GENERIC; elif command -v nvidia-smi >/dev/null; then echo NVIDIA; else echo NONE; fi"]
        stdout: StdioCollector {
            onStreamFinished: root.gpuType = text.trim()
        }
    }

    Process {
        id: p_gpuUsage

        command: root.gpuType === "GENERIC" ? ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent"] : root.gpuType === "NVIDIA" ? ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"] : ["echo"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (root.gpuType === "GENERIC") {
                    const percs = text.trim().split("\n");
                    const sum = percs.reduce((acc, d) => acc + parseInt(d, 10), 0);
                    root.gpuPerc = sum / percs.length / 100;
                } else if (root.gpuType === "NVIDIA") {
                    const [usage, temp] = text.trim().split(",");
                    root.gpuPerc = parseInt(usage, 10) / 100;
                } else {
                    root.gpuPerc = 0;
                }
            }
        }
    }

    Process {
        id: p_pavucontrol;
        running: false;
        command: ["pavucontrol"];
    }

    function pavucontrol(): void { p_pavucontrol.running = true; }

    Process {
        id: p_nwglook;
        running: false;
        command: ["nwg-look"];
    }

    function nwglook(): void { p_nwglook.running = true; }

    Process {
        id: p_poweroff;
        running: false;
        command: ["poweroff"];
    }

    function poweroff() { p_poweroff.running = true; }

    Process {
        id: p_reboot;
        running: false;
        command: ["reboot"];
    }

    function reboot() { p_reboot.running = true; }

    Process {
        id: p_suspend;
        running: false;
        command: ["systemctl", "p_suspend"];
    }

    function suspend() { p_suspend.running = true; }
}
