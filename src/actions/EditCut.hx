package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class EditCut extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	var cutKeys: Array<Keycap>;

	override public function new(viewport: Viewport, device: keyson.Keyboard, cutKeys: Array<Keycap>) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.cutKeys = cutKeys.copy();
	}

	override public function act(type: ActionType) {
		final cloner = new cloner.Cloner();
		// take in the selection to the editBuffer
		CopyBuffer.selectedObjects.keys = [
			for (shape in cutKeys) {
				// severe ties to the originals:
				cloner.clone(shape.sourceKey);
			}
		];
		CopyBuffer.selectedObjects.sortKeys();
		// remove the selection from the keyboard:
		for (key in cutKeys) {
			// clear keyson:
			this.device.removeKey(key.sourceKey);
			// clear Ceramic:
			key.destroy();
		}
		super.act(type);
	}

	override public function undo() {
		// restore the cutKeys to the work surface
		var i = 0;
		for (key in cutKeys) {
			final recreatedKey = KeyMaker.createKey(this.device, key.sourceKey, this.viewport.unit, this.viewport.gapX, this.viewport.gapY);
			recreatedKey.pos(this.viewport.unit * key.sourceKey.position[Axis.X], viewport.unit * key.sourceKey.position[Axis.Y]);
			recreatedKey.component('logic', new viewport.KeyLogic(viewport));
			cutKeys[i] = recreatedKey;
			// recreate keyson:
			this.device.insertKey(recreatedKey.sourceKey);
			// recreate Ceramic:
			this.viewport.keyboard.add(recreatedKey);
			i++;
		}
		super.undo();
	}
}
