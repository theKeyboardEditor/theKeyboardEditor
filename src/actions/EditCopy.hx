package actions;

import viewport.Viewport;
import keyson.Keyson;
import CopyBuffer;

class EditCut extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	var copyees: Array<KeyRenderer>;

	override public function new(viewport: Viewport, device: keyson.Keyboard, copyees: Array<KeyRenderer>) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.copyees = copyees.copy();
	}

	override public function act(type: ActionType) {
		// take in the selection to the editBuffer
		CopyBuffer.selectedObjects = copyees.copy();
		super.act(type);
	}

	override public function undo() {
		// clear the editBuffer
		CopyBuffer.selectedObjects = [];
	}
}
