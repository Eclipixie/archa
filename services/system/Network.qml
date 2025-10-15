pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property alias networks: v_networks.instances
    readonly property AccessPoint activeAP: networks.find(n => n.active) ?? null
    readonly property bool active: activeAP != null || activeDevice != null;

    property var activeDevice

    signal networksUpdated(newNetworks: var);

    onNetworksChanged: root.networksUpdated(root.networks);

    reloadableId: "network"

    property list<string> networkRows: [];

    Variants {
        id: v_networks

        model: networkRows

        delegate: AccessPoint {
            required property var modelData
            property var net: modelData.split(":");
            active: net[0] === "yes"
            strength: parseInt(net[1])
            frequency: parseInt(net[2].split(" ")[0])
            ssid: net[3]
            bssid: net[4]
            security: net[5]
        }
    }

    Process {
        running: true;
        command: ["nmcli", "m"];
        stdout: SplitParser {
            onRead: reloadNetworks();
        }
    }

    Timer {
        id: netTimer;
        running: false;
        interval: 5000;
        repeat: false;

        onTriggered: getNetworks.running = true;
    }

    function reloadNetworks() {
        getNetworks.running = true;
    }

    Process {
        id: getNetworks
        running: true
        command: ["nmcli", "-g", "ACTIVE,SIGNAL,FREQ,SSID,BSSID,SECURITY", "d", "w"]
        stdout: StdioCollector {
            onStreamFinished: {
                const netstr = this.text.trim().split("\n");

                let ssids = [];

                let uniques = [];

                for (let i = 0; i < netstr.length; i++) {
                    let ssid = netstr[i].split(":")[3];

                    if (ssid != "" && !ssids.includes(ssid)) {
                        ssids.push(ssid);
                        // removing bssid colons
                        uniques.push(netstr[i].split(/\\:/).join(""));
                    }
                }

                root.networkRows = uniques;
            }
        }
    }

    Process {
        id: getActiveDevices
        running: true;
        command: ["nmcli", "-g", "common", "d"];
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n");
                let devices = [];

                for (let i = 0; i < lines.length; i++) {
                    devices.push(lines[i].split(":"));
                }

                let newDev = devices.filter((dev) => dev[1] == "ethernet")[0];
                if (!newDev) 
                    newDev = devices.filter((dev) => dev[1] == "wifi")[0];
                if (!newDev) {
                    root.activeDevice = null;
                    return;
                }

                root.activeDevice = {
                    if: newDev[0],
                    type: newDev[1],
                    status: newDev[2],
                    name: newDev[3]
                };
            }
        }
    }

    component AccessPoint: QtObject {
        required property string ssid
        required property string bssid
        required property int strength
        required property int frequency
        required property bool active
        required property string security
    }
}