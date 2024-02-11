package actions;

import viewport.Viewport;
import keyson.Keyson;

class EditCopy extends Action {
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
		trace('Copy: ${CopyBuffer.selectedObjects}');
		super.act(type);
	}

	override public function undo() {
		// clear the editBuffer
		super.undo();
	}
}
