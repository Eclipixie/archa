pragma Singleton

import Quickshell
import Quickshell.Wayland

import qs.widgets

Singleton {
    property WlSessionLock sessionLock: lock;

    // This stores all the information shared between the lock surfaces on each screen.
	LockContext {
		id: lockContext

		onUnlocked: {
			// Unlock the screen before exiting, or the compositor will display a
			// fallback lock you can't interact with.
			lock.locked = false;

			// Qt.quit();
		}
	}

	WlSessionLock {
		id: lock

		locked: false

		WlSessionLockSurface {
			LockSurface {
				anchors.fill: parent
				context: lockContext
			}
		}
	}

}
