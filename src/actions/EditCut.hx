package actions;

import viewport.Viewport;
import keyson.Keyson;
import CopyBuffer;

class EditCut extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	var cutees: Array<KeyRenderer>;

	override public function new(viewport: Viewport, device: keyson.Keyboard, cutees: Array<KeyRenderer>) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.cutees = cutees.copy();
	}

	override public function act(type: ActionType) {
		// take in the selection to the editBuffer
		CopyBuffer.selectedObjects = cutees.copy();
		// remove the selection from the workSurface:
		for (member in cutees) {
			// clear keyson:
			this.device.removeKey(member.sourceKey);
			// clear Ceramic:
			this.viewport.workSurface.remove(member);
		}
		super.act(type);
	}

	override public function undo() {
		// restore the cutees to the work surface
		for (member in cutees) {
			// recreate keyson:
			this.device.insertKey(member.sourceKey);
			// recreate Ceramic:
			this.viewport.workSurface.add(member);
		}
		// clear the editBuffer
		CopyBuffer.selectedObjects = [];
	}
}
