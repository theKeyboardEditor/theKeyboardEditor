package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class EditPaste extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard;
	var clonedKeys: keyson.Keyboard;
	final x: Float;
	final y: Float;

	override public function new(viewport: Viewport, device: keyson.Keyboard, x: Float, y: Float) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.x = x;
		this.y = y;
	};

	override public function act(type: ActionType) {
		final cloner = new cloner.Cloner();
		// severe any entanglement with the buffer and placed elements:
		// this can't be final we store information for undo here
		clonedKeys = cloner.clone(CopyBuffer.selectedObjects);
		for (key in clonedKeys.keys) {
			// add to keyson:
			this.device.insertKey(key);
			// recreate shapes:
			final keycap: Keycap = KeyMaker.createKey(clonedKeys, key, viewport.unit, viewport.gapX, viewport.gapY,
				Std.parseInt(viewport.keyboardUnit.defaults.keyColor));
			keycap.pos(viewport.unit * key.position[Axis.X] + x, viewport.unit * key.position[Axis.Y] + y);
			keycap.component('logic', new viewport.KeyLogic(viewport));
			viewport.keyboard.add(keycap);
		}
		this.device.sortKeys();
		super.act(type);
	}

	override public function undo() {
		// clear by the recorded keyboard shapes:
		for (member in clonedKeys.keys) {
			final keysOnUnit: Array<Keycap> = cast viewport.keyboard.children;
			for (keycap in keysOnUnit) {
				if (keycap.sourceKey == member) {
					this.device.removeKey(member);
					this.viewport.keyboard.remove(keycap);
				}
			}
		}
		super.undo();
	}
}
