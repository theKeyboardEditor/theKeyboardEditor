package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class PlaceKey extends Action {
	final viewport: Viewport;
	var placed: Array<KeyRenderer>;
	final shape: String;
	final unit: Int; // the receiving unit (numpad, left half...)
	final x: Float; // in 1U keyson units
	final y: Float;

	override public function new(viewport: Viewport, unit: Int, shape: String, x: Float, y: Float) {
		super();
		this.viewport = viewport;
		this.placed = placed.copy();
		this.unit = unit;
		this.x = x;
		this.y = y;
		this.shape = shape;
	};

	override public function act(type: ActionType) {
		// Create a keyson key, the second shape is legend!
		final key = viewport.keyson.units[unit].addKey(shape, [x, y], shape);
		// Draw that key
		final keycap: KeyRenderer = KeyMaker.createKey(this.viewport.keyson.units[unit], key, this.viewport.unit, this.viewport.gapX,
			this.viewport.gapY, keyboardUnit.keysColor)
		keycap.pos(this.viewport.unit * key.position[Axis.X], this.viewport.unit * key.position[Axis.Y]);
		this.viewport.workKeyboard.add(keycap);
		this.placed = keycap;
		
		super.act(type);
	}

	override public function undo() {
		for (unit in viewport.keyson.units) {
			for (key in unit.keys) {
				if (placed.sourceKey == key) {
					// clear keyson:
					this.viewport.keyson.units[unit].removeKey(placed.sourceKey);
					// clear Ceramic:
					this.viewport.workKeyboard.dispose(placed);
				}
			}
		}
		super.undo();
	}
}
