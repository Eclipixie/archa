import QtQuick

import qs.components.ui
import qs.modules.bar.components
import qs.config
import qs.components.primitives
import qs.util

Item {
    id: row;

    property list<Item> regionMasks: [
        container,
        systemModule,
        mpcModule,
        fSettingsModule,
        windowModule,
        networkModule,
        powerModule,
        timeModule
    ]

    implicitHeight: Styling.barHeight + Styling.spacing * 2;

    anchors {
        right: parent.right;
        left: parent.left;
        top: parent.top;
    }

    UIModule {
        id: container

        visible: Styling.barBackground;

        topLeftRadius: 0
        topRightRadius: 0

        color: Colors.tertiary

        anchors {
            fill: parent
            margins: 0
        }

        Item {
            anchors {
                fill: parent
                margins: Styling.spacing
            }

            Row {
                id: leftRow 

                height: Styling.barHeight

                anchors.left: parent.left

                spacing: Styling.spacing

                SystemModule { id: systemModule; }

                MPCModule { id: mpcModule; }

                FSettingsModule { id: fSettingsModule; }
            }

            BarModule {
                anchors.left: leftRow.right;
                anchors.right: middleRow.left;

                anchors.leftMargin: Styling.spacing
                anchors.rightMargin: Styling.spacing

                visible: Styling.barSpacers;
            }

            Row {
                id: middleRow

                height: Styling.barHeight

                anchors.horizontalCenter: parent.horizontalCenter

                WindowModule { id: windowModule; }
            }

            BarModule {
                anchors.left: middleRow.right;
                anchors.right: rightRow.left

                anchors.leftMargin: Styling.spacing
                anchors.rightMargin: Styling.spacing

                visible: Styling.barSpacers;
            }

            Row {
                id: rightRow 

                height: Styling.barHeight

                anchors.right: parent.right

                spacing: Styling.spacing

                NetworkModule { id: networkModule; }

                PowerModule { id: powerModule }

                TimeModule { id: timeModule }
            }
        }
    }
}