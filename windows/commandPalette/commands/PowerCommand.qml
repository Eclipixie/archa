import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services.system
import qs.windows
import qs.util

ListCommand { 
    id: root

    sublist: [
        ListCommand { name: "off"
            onExec: { System.poweroff() }
        },
        ListCommand { name: "reboot"
            onExec: { System.reboot() }
        },
        ListCommand { name: "sleep"
            onExec: { System.suspend() }
        },
        ListCommand { name: "profile"
            id: c_profile

            sublist: [
                ListCommand { name: "saver"
                    onExec: { Battery.setProfile(0) }
                },
                ListCommand { name: "balanced"
                    onExec: { Battery.setProfile(1) }
                },
                ListCommand { name: "performance"
                    onExec: { Battery.setProfile(2) }
                }
            ]

            display: Component {
                UIHorizontalList {
                    model: c_profile.queryList(c_profile.search)
                }
            }
        }
    ]

    display: Component {
        UIHorizontalList {
            model: root.queryList(root.search)
        }
    }
}