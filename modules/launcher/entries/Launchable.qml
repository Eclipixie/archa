pragma ComponentBehavior: Bound

import QtQuick

import qs.components.ui

QtObject {
    id: root

    required property string name

    property list<Launchable> branches: []

    property list<Launchable> searched: branches

    property Component list: Component { UIList { model: root.searched } }

    signal launch()

    function searchList(search: string): void {
        searched = branches.filter((launchable) => launchable.name.includes(search));
    }

    function trace(path: list<string>): var {
        let pathVal = [...path];

        if (pathVal.length == 0) return root;

        let next = pathVal.shift();
        let selected = null;

        for (let i = 0; i < branches.length; i++) {
            if (branches[i].name == next) {
                selected = branches[i];
                break;
            }
        }

        if (selected == null) return null;

        return selected.trace(pathVal);
    }
}