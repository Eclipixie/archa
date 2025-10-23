import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.util
import qs.windows

SettingsZone {
    name: "Styling"

    surface: Component {
        ColumnLayout {
            anchors.fill: parent

            spacing: Styling.spacing

            UIZone {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

                implicitHeight: 200
                width: parent.width

                ColumnLayout {
                    anchors {
                        fill: parent
                        margins: Styling.spacing
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    
                        implicitWidth: Styling.barHeight

                        UITextModule {
                            id: l_rounding
                            implicitWidth: 200

                            topRightRadius: 0
                            bottomRightRadius: 0

                            text.text: "Rounding"
                        }

                        UIDropDown {
                            surfaceBackground.topLeftRadius: 0
                            surfaceBackground.bottomLeftRadius: 0

                            anchors {
                                left: l_rounding.right
                                right: parent.right
                                leftMargin: Styling.spacing
                            }

                            model: ["Capsule", "Rounded", "Square"]

                            onCurrentIndexChanged: {
                                switch (currentIndex) {
                                    case 0:
                                        Styling.barModuleRadius = Styling.barRadiusMode.capsule;
                                        break;
                                    case 1:
                                        Styling.barModuleRadius = Styling.barRadiusMode.rounded;
                                        break;
                                    case 2:
                                        Styling.barModuleRadius = Styling.barRadiusMode.square;
                                        break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}