import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.util
import qs.windows

SettingsZone {
    name: "Styling"

    surface: Component {
        ColumnLayout {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            spacing: Styling.spacing * 2

            UIZone {
                id: shapesZone

                Layout.fillWidth: true

                implicitHeight: shapesColumn.implicitHeight + Styling.spacing * 2
                width: parent.width

                ColumnLayout {
                    id: shapesColumn
                    spacing: Styling.spacing

                    anchors {
                        fill: parent
                        margins: Styling.spacing
                    }

                    DropDownSetting {
                        settingName: "Rounding"
                        model: ["Capsule", "Rounded", "Square"]
                        onSettingChanged: {
                            switch (setting) {
                                case "Capsule":
                                    Styling.barModuleRadius = Styling.barRadiusMode.capsule;
                                    break;
                                case "Rounded":
                                    Styling.barModuleRadius = Styling.barRadiusMode.rounded;
                                    break;
                                case "Square":
                                    Styling.barModuleRadius = Styling.barRadiusMode.square;
                                    break;
                            }
                        }
                    }

                    DropDownSetting {
                        settingName: "Font"
                        model: Styling.availableFonts
                        onSettingChanged: {
                            Styling.fontFamily = setting
                        }
                    }
                }
            }

            Item {
                implicitHeight: Styling.spacing
                Layout.fillWidth: true

                Rectangle {
                    implicitHeight: Styling.spacing
                    color: Colors.secondary
                    radius: Styling.spacing / 2
                    anchors {
                        fill: parent
                        leftMargin: Styling.spacing * 2
                        rightMargin: Styling.spacing * 2
                    }
                }
            }
        }
    }

    component DropDownSetting: Item {
        id: dropDownSetting
        required property string settingName
        required property list<string> model
        readonly property string setting: control.currentText

        Layout.fillWidth: true
    
        implicitHeight: Styling.barHeight

        UITextModule {
            id: l_rounding
            implicitWidth: 200

            topRightRadius: 0
            bottomRightRadius: 0

            text.text: settingName
        }

        UIDropDown {
            id: control
            surfaceBackground.topLeftRadius: 0
            surfaceBackground.bottomLeftRadius: 0

            anchors {
                left: l_rounding.right
                right: parent.right
                leftMargin: Styling.spacing
            }

            model: dropDownSetting.model
        }
    }
}