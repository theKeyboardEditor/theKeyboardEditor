package actions;

import viewport.Viewport;
import keyson.Keyson;

class EditCopy extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	var copyees: Array<Keycap>;

	override public function new(viewport: Viewport, device: keyson.Keyboard, copyees: Array<Keycap>) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.copyees = copyees.copy();
	}

	override public function act(type: ActionType) {
		final cloner = new cloner.Cloner();
		// take in the selection to the empty editBuffer:
		CopyBuffer.selectedObjects.keys = [
			for (shape in copyees) {
				// severe ties to the originals:
				cloner.clone(shape.sourceKey);
			}
		];
		CopyBuffer.selectedObjects.sortKeys();
		super.act(type);
	}

	override public function undo() {
		super.undo();
	}
}
