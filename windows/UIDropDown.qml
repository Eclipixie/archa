import Quickshell
import QtQuick
import QtQuick.Controls

import qs.util

ComboBox {
    id: root

    property alias surfaceBackground: o_background

    background: o_background
    
    UITextModule {
        id: o_background
        text.text: root.currentText

        bottomLeftRadius: popup.visible ? 0 : Styling.barModuleRadius
        bottomRightRadius: popup.visible ? 0 : Styling.barModuleRadius
    }

    indicator: UIText {
        y: (root.height - height) / 2
        x: root.width - width - y * 2
        
        text: root.popup.visible ? "󰁢" : "󰁊"
    }

    contentItem: null

    delegate: ItemDelegate {
        required property var modelData
        implicitHeight: container.implicitHeight

        background: Item {
            id: container
            implicitHeight: surface.implicitHeight + Styling.spacing
            implicitWidth: root.width - Styling.spacing * 2

            UITextModule {
                id: surface
                text.text: modelData

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 0
                }

                color: Colors.tertiary
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        height: Math.min(contentItem.implicitHeight, root.Window.height - topMargin - bottomMargin)
        padding: Styling.spacing

        background: UIZone {
            topLeftRadius: 0
            topRightRadius: 0

            color: Colors.primary

            anchors {
                fill: parent
                margins: 0
            }
        }

        contentItem: ListView {
            clip: false
            implicitHeight: 3 * (Styling.barHeight + Styling.spacing) + Styling.spacing
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
}
