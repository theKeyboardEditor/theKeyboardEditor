package;

import ceramic.InputMap;
import ceramic.Scene;
import ceramic.Visual;
import keyson.Axis;
import keyson.Keyson.Keyboard;

class Viewport extends Scene {
	var keyboard: Keyboard;
	var inputMap = new InputMap<ViewportInput>();

	// Everything inside the viewport is stored here
	var universe: Visual = new Visual();
	var selected: Array<KeyRenderer> = [];

	// Constants
	inline static final unit = 100;
	inline static var movementSpeed: Int = 1000;
	inline static var originX: Float = 510;
	inline static var originY: Float = 60;

	override public function new(keyboard: Keyboard) {
		super();
		this.keyboard = keyboard;
		this.universe = new Visual();
		this.universe.pos(originX, originY);

		// Define the inputs
		bindInput();
	}

	function bindInput() {
		inputMap.bindKeyCode(UP, UP);
		inputMap.bindKeyCode(DOWN, DOWN);
		inputMap.bindKeyCode(LEFT, LEFT);
		inputMap.bindKeyCode(RIGHT, RIGHT);
		// We use scan code for these so that it will work with non-qwerty layouts as well
		inputMap.bindScanCode(UP, KEY_W);
		inputMap.bindScanCode(DOWN, KEY_S);
		inputMap.bindScanCode(LEFT, KEY_A);
		inputMap.bindScanCode(RIGHT, KEY_D);
		// Zoom Time
		inputMap.bindScanCode(ZOOM_IN, EQUALS);
		inputMap.bindScanCode(ZOOM_OUT, MINUS);
	}

	override function create() {
		final gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit);
		final gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit);

		for (k in this.keyboard.keys) {
			final key: KeyRenderer = KeyMaker.createKey(k, unit, gapX, gapY, this.keyboard.keysColor);
			this.universe.add(key.create());

			final keyLegends: Array<LegendRenderer> = KeyMaker.createLegend(this.keyboard, k, unit);
			for (l in keyLegends) {
				this.universe.add(l.create());
			}

			// A ceramic visual does not inherit the size of it's children
			// Hence we must set it ourselves
			if (key.width + key.x > this.universe.width) {
				this.universe.width = key.width + gapX + key.x;
			} // we end up with the biggest value when the loop is over

			if (key.height + key.y > this.universe.height) {
				this.universe.height = key.height + gapY + key.y;
			}

			key.pos(unit * k.position[Axis.X], unit * k.position[Axis.Y]);
			key.onPointerDown(key, (_) -> {
				if (key.border.visible) {
					selected.remove(key); // just in case
					selected.push(key);
				} else {
					selected.remove(key);
				}
				key.select();
			});
		}
		this.add(universe);
	}

	final zoom = 2;

	override function update(delta: Float) {
		// Handle keyboard input.
		if (inputMap.pressed(UP)) {
			this.universe.y += movementSpeed * delta;
		}
		if (inputMap.pressed(LEFT)) {
			this.universe.x += movementSpeed * delta;
		}
		if (inputMap.pressed(DOWN)) {
			this.universe.y -= movementSpeed * delta;
		}
		if (inputMap.pressed(RIGHT)) {
			this.universe.x -= movementSpeed * delta;
		}
		// ZOOMING!
		if (inputMap.pressed(ZOOM_IN)) {
			this.universe.scaleX += zoom * delta;
			this.universe.scaleY += zoom * delta;
		} else if (inputMap.pressed(ZOOM_OUT)) {
			this.universe.scaleX -= zoom * delta;
			this.universe.scaleY -= zoom * delta;
		}
	}
}

enum abstract ViewportInput(Int) {
	var UP;
	var DOWN;
	var LEFT;
	var RIGHT;
	var ZOOM_IN;
	var ZOOM_OUT;
}
