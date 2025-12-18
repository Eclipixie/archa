import Quickshell
import QtQuick

import qs.components.ui

ListCommand {
    id: root;

    property bool value: false

    sublist: [
        ListCommand { name: "true"
            onExec: {
                root.value = true;
                root.exec();
            }
        },
        ListCommand { name: "false"
            onExec: {
                root.value = false;
                root.exec();
            }
        }
    ]
}
