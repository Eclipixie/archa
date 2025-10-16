import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Wayland

import qs.services.system
import qs.util
import qs.windows

Item {
	id: root
	required property LockContext context

	Rectangle {
		anchors.fill: root
		color: Colors.secondary
	}

	Image {
		asynchronous: true

		fillMode: Image.PreserveAspectCrop;

		source: Colors.wallpaper;

		anchors.fill: parent
	}
	
	UIModule {
		anchors {
			horizontalCenter: parent.horizontalCenter;
			top: parent.top;
			topMargin: 100;
		}

		implicitWidth: clockLabel.implicitWidth + 50;
		implicitHeight: clockLabel.implicitHeight + 10;

		border.width: Styling.outlines;

		Label {
			id: clockLabel;

			anchors {
				horizontalCenter: parent.horizontalCenter;
				verticalCenter: parent.verticalCenter;
			}

			property var date: new Date();

			// The native font renderer tends to look nicer at large sizes.
			renderType: Text.NativeRendering;
			font.pointSize: Styling.lockScreenFontPointSize;
			font.family: Styling.fontFamily;

			color: Colors.secondary;

			// updated when the date changes
			text: Qt.formatDateTime(Time.clock.date, "hh:mm:ss");
		}
	}

	ColumnLayout {
		// Uncommenting this will make the password entry invisible except on the active monitor.
		visible: Window.active

		anchors {
			horizontalCenter: parent.horizontalCenter
			top: parent.verticalCenter
		}

		RowLayout {
			TextField {
				id: passwordBox;

				background: UIModule { border.width: Styling.outlines; }

				color: Colors.secondary;

				implicitWidth: 400;
				implicitHeight: 35;
				padding: 10;

				focus: true;
				enabled: !root.context.unlockInProgress;
				echoMode: TextInput.Password;
				inputMethodHints: Qt.ImhSensitiveData;

				// Update the text in the context when the text in the box changes.
				onTextChanged: root.context.currentText = this.text;

				// Try to unlock when enter is pressed.
				onAccepted: root.context.tryUnlock();

				// Update the text in the box to match the text in the context.
				// This makes sure multiple monitors have the same text.
				Connections {
					target: root.context;

					function onCurrentTextChanged() {
						passwordBox.text = root.context.currentText;
					}
				}
			}

			RoundButton {
				id: enterButton;

				font.family: Styling.fontFamily;

				background: UIModule {
					border.width: Styling.borders;

					color: root.context.showFailure ? 
						Colors.error :
						enterButton.enabled ? 
							Colors.active : 
							Colors.inactive;
				}

				implicitWidth: 35;
				implicitHeight: 35;

				text: "";

				// don't steal focus from the text box
				focusPolicy: Qt.NoFocus;

				enabled: !root.context.unlockInProgress && root.context.currentText !== "";
				onClicked: root.context.tryUnlock();
			}
		}

		Label {
			visible: root.context.showFailure;
			text: "Incorrect password";
			color: Colors.secondary;
		}
	}
}
