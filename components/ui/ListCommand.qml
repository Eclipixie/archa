import Quickshell
import QtQuick

import qs.config

QtObject {
    id: root;

    property string name

    property string search
    
    signal exec()

    property list<ListCommand> sublist

    function query(q: string): var {
        q = q.toLowerCase().trim().split(" ");
        let word = q.shift();
        let listRes = queryExact(word);

        if (listRes == null) return root;
        else return listRes.query(q.join(" "));
    }

    function queryList(q: string): var {
        if (q == root.name) return sublist;
        else return sublist.filter((cmd) => cmd.name.toLowerCase().startsWith(q));
    }

    function queryExact(q: string): var {
        let res = sublist.filter((cmd) => cmd.name.toLowerCase() == q);
        if (res.length == 1) return res[0];
        return null;
    }

    property Component display: Component { UIList {
        model: queryList(search);
    } }
}