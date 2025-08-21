pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var networks: []
    readonly property AccessPoint activeAP: networks.find(n => n.active) ?? null
    readonly property bool active: activeAP != null || activeDevice != null;

    property var activeDevice

    signal networksUpdated(newNetworks: var);

    onNetworksChanged: root.networksUpdated(root.networks);

    reloadableId: "network"

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
                netstr.pop();

                const networks = netstr.map(n => {
                    const net = n.split(":");
                    return {
                        active: net[0] === "yes",
                        strength: parseInt(net[1]),
                        frequency: parseInt(net[2].split(" ")[0]),
                        ssid: net[3],
                        bssid: net[4],
                        security: net[5]
                    };
                });

                const newNetworks = []

                let seen = [];

                for (const network of networks) {
                    // supposedly each subsequent network has a worse connection strength, so "identical" networks should simply be skipped

                    if (seen.includes(network.ssid.toString())) continue;
                    else seen.push(network.ssid.toString());

                    if (network.strength <= 30) continue;
                    if (network.ssid == "") continue;

                    let obj = apComp.createObject(root, { lastIpcObject: network });

                    if (network.active) 
                        newNetworks.unshift(obj); 
                    else 
                        newNetworks.push(obj);
                }

                root.networks = newNetworks;
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
        required property var lastIpcObject
        readonly property string ssid: lastIpcObject.ssid
        readonly property string bssid: lastIpcObject.bssid
        readonly property int strength: lastIpcObject.strength
        readonly property int frequency: lastIpcObject.frequency
        readonly property bool active: lastIpcObject.active
        readonly property string security: lastIpcObject.security
    }

    Component {
        id: apComp

        AccessPoint { }
    }
}