package actions;

import viewport.Viewport;
import viewport.KeyMaker;
import ceramic.TouchInfo;
import keyson.Keyson;
import keyson.Axis;

class EditPaste extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	final shapes: Array<KeyRenderer>; // the receiving unit
	final x: Float; // in 1U keyson units
	final y: Float;

	override public function new(viewport: Viewport, device: keyson.Keyboard, x: Float, y: Float) {
		super();
		this.viewport = viewport;
		this.device = device;
		// TODO make this x and y be offsets for the whole ordeal
		this.x = x;
		this.y = y;
		this.shapes = [];
	};

	override public function act(type: ActionType) {
		/*if (type != Redo) {
				// is there any difference?
			} else {
		 */ // we already store the key object on redo
		for (key in CopyBuffer.selectedObjects.keys) {
			// add to keyson:
			this.device.insertKey(key);
			// TODO recreate shapes:
			final keycap: KeyRenderer = KeyMaker.createKey(CopyBuffer.selectedObjects, key, viewport.unit, viewport.gapX, viewport.gapY,
				viewport.keyboardUnit.keysColor);
			keycap.pos(viewport.unit * key.position[Axis.X], viewport.unit * key.position[Axis.Y]);
			keycap.onPointerDown(keycap, (t: TouchInfo) -> {
				viewport.keyMouseDown(t, keycap);
			});
			viewport.workSurface.add(keycap);
			this.device.sortKeys();
		}
		super.act(type);
	}

	override public function undo() {
		// clear by the recorded workSurface shapes:
		for (member in shapes) {
			this.device.removeKey(member.sourceKey);
			this.viewport.workSurface.remove(member);
		}
		CopyBuffer.selectedObjects.keys = [];
		super.undo();
	}
}
