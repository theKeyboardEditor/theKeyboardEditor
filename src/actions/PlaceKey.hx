package actions;

import viewport.Viewport;
import viewport.KeyMaker;
import ceramic.TouchInfo;
import keyson.Axis;
import keyson.Keyson;

class PlaceKey extends Action {
	final viewport: Viewport;
	var placed: KeyRenderer; // it holds all info for undo/redo
	final shape: String;
	final device: keyson.Keyboard; // the receiving unit
	final x: Float; // in 1U keyson units
	final y: Float;
	var key: keyson.Key;

	override public function new(viewport: Viewport, device: keyson.Keyboard, shape: String, x: Float, y: Float) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.x = x;
		this.y = y;
		this.shape = shape;
	};

	override public function act(type: ActionType) {
		if (type != Redo) {
			// Create a new keyson key, the second shape is the legend!
			this.key = device.createKey(this.shape, [this.x, this.y], this.shape);
		} else {
			// we already store the key object on redo
			this.key = device.insertKey(this.placed.sourceKey);
		}
		// Draw and place the key
		final keycap: KeyRenderer = KeyMaker.createKey(this.device, key, this.viewport.unit, this.viewport.gapX, this.viewport.gapY,
			this.device.keysColor);
		keycap.pos(this.viewport.unit * this.key.position[Axis.X], this.viewport.unit * this.key.position[Axis.Y]);
		this.viewport.workSurface.add(keycap);
		keycap.onPointerDown(keycap, (t: TouchInfo) -> {
			this.viewport.keyMouseDown(t, keycap);
		});
		this.placed = keycap;
		super.act(type);
	}

	override public function undo() {
		for (key in device.keys) {
			if (placed.sourceKey == key) {
				// clear keyson:
				this.device.removeKey(placed.sourceKey);
				// clear Ceramic:
				this.viewport.workSurface.remove(placed);
			}
		}
		super.undo();
	}
}
