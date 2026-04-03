import QtQuick
import QtQuick.Controls

import qs.components.primitives
import qs.components.ui
import qs.config
import qs.services.qs
import qs.modules.launcher.entries

UIModule {
    id: root

    implicitHeight: search.implicitHeight + 
        pathReadout.implicitHeight + 
        list.height + Styling.spacing * 4
    implicitWidth: 500

    visible: Visibilities.launcher

    radius: Styling.barModuleRadius + Styling.spacing

    onVisibleChanged: {
        if (visible) {
            search.forceActiveFocus();
            treePath = [];
            search.text = "";

            root.current = root.tree.trace(root.treePath);
        }
    }

    color: Colors.tertiary

    property list<Item> regionMasks: visible ? [
        this
    ] : []

    property list<string> treePath: []

    property Launchable tree: Launchable {
        name: "root"

        branches: [
            BrowserLauncher { },
            SettingsLauncher { },
            AppLauncher { }
        ]
    }

    property Launchable current: tree

    Column {
        spacing: Styling.spacing

        anchors {
            fill: parent
            margins: Styling.spacing
        }

        TextField {
            id: search

            implicitHeight: Styling.barHeight

            anchors {
                left: parent.left
                right: parent.right
            }

            background: UIModule {
                anchors.fill: search

                bottomLeftRadius: 0
                bottomRightRadius: 0
            }

            font: Styling.bodyFont
            color: Colors.secondary

            leftPadding: Styling.spacing * 3
            rightPadding: Styling.spacing * 3

            onTextEdited: {
                root.current.searchList(search.text);
            }

            Keys.onEscapePressed: {
                if (root.treePath.length == 0)
                    Visibilities.launcher = false;

                root.treePath.pop();

                text = "";

                root.current.reset();
                root.current = root.tree.trace(root.treePath);
            }

            Keys.onTabPressed: { choose(); }

            onAccepted: { choose(); }

            function choose() {
                search.text = ""

                let searchlist = root.current.searched;

                if (searchlist.length == 0) return;

                let selected = searchlist[0];
                
                if (selected.branches.length == 0) {
                    root.treePath = [];
                    Visibilities.launcher = false;

                    selected.launch();
                }
                else {
                    root.treePath.push(selected.name);
                }

                root.current.reset();
                root.current = root.tree.trace(root.treePath);
            }
        }

        Loader {
            id: list

            anchors {
                left: parent.left
                right: parent.right
            }

            clip: true

            sourceComponent: root.current?.list ?? null
        }

        UITextModule {
            id: pathReadout

            anchors {
                left: parent.left
                right: parent.right
            }

            topLeftRadius: 0
            topRightRadius: 0

            text {
                anchors {
                    left: pathReadout.left
                    verticalCenter: pathReadout.verticalCenter
                    centerIn: undefined

                    margins: Styling.spacing * 2
                }

                text: "/"+root.treePath.join("/")
            }
        }
    }
}
