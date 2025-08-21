import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services.system
import qs.windows
import qs.util

ListCommand { 
    sublist: [
        ListCommand { name: "off"
            onExec: System.poweroff()
        },
        ListCommand { name: "reboot"
            onExec: System.reboot()
        },
        ListCommand { name: "sleep"
            onExec: System.suspend()
        }
    ]

    display: Component {
        UIList {
            id: c_root
            orientation: Qt.Horizontal

            implicitHeight: Styling.barHeight

            interactive: false

            listEntry: Component {
                Item {
                    id: wrapper
                    required property string name

                    property bool focused: false

                    implicitWidth: surface.implicitWidth + Styling.spacing;

                    UIModule {
                        id: surface;

                        color: focused ? Colors.secondary : Colors.primary;

                        implicitWidth: (c_root.width - (Styling.spacing * 2)) / 3;

                        UIText {
                            text: name;
                            color: focused ? Colors.primary : Colors.secondary;

                            anchors {
                                horizontalCenter: parent.horizontalCenter;
                                verticalCenter: parent.verticalCenter;

                                leftMargin: (parent.height - height) * .5 + 5;
                            }
                        }
                    }
                }
            }
        }
    }
}