import QtQuick
import QtQuick.Controls

import qs.components.primitives
import qs.config
import qs.services.qs
import qs.modules.launcher.entries

UIModule {
    id: root

    implicitHeight: search.implicitHeight + list.height + Styling.spacing
    implicitWidth: 300

    visible: Visibilities.launcher

    onVisibleChanged: {
        search.forceActiveFocus();
        treePath = [];
        search.text = "";

        root.current = root.tree.trace(root.treePath);
    }

    color: Colors.tertiary

    property list<Item> regionMasks: visible ? [
        this
    ] : []

    property list<string> treePath: []

    property Launchable tree: Launchable {
        name: "root"

        branches: [
            BrowserLauncher { }
        ]
    }

    property Launchable current: tree

    Column {
        anchors.fill: parent

        spacing: Styling.spacing

        TextField {
            id: search

            implicitHeight: Styling.barHeight

            anchors {
                left: parent.left
                right: parent.right
            }

            background: UIModule {
                anchors.fill: search
            }

            font: Styling.bodyFont
            color: Colors.secondary

            leftPadding: Styling.spacing * 3
            rightPadding: Styling.spacing * 3

            onTextEdited: {
                root.current.searchList(search.text);
            }

            Keys.onEscapePressed: {
                if (root.treePath.length == 0) Visibilities.launcher = false;

                root.treePath.pop();

                text = "";

                root.current = root.tree.trace(root.treePath);
            }

            Keys.onTabPressed: { choose(); }

            onAccepted: { choose(); }

            function choose() {
                search.text = ""

                let searchlist = root.current.searched;

                if (searchlist.length == 0) return;

                let selected = searchlist[0];

                selected.launch();
                
                if (root.current.branches.length == 0) {
                    root.treePath = [];
                }
                else {
                    root.treePath.push(selected.name);
                }

                root.current = root.tree.trace(root.treePath);
            }
        }

        Loader {
            id: list

            anchors {
                left: parent.left
                right: parent.right

                margins: Styling.spacing
            }

            sourceComponent: root.current?.list ?? null
        }
    }
}
