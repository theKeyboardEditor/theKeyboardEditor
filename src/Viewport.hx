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
	var cursor: ViewportCursor = new ViewportCursor(unit, unit);
	var selected: Map<Int, KeyRenderer> = [];

	// Constants
	inline static final unit = 100;
	inline static final quarterUnit = unit / 4;
	inline static final movementSpeed: Int = 1000;
	inline static final zoom = 2;
	inline static final originX: Float = 510;
	inline static final originY: Float = 60;

	// Gap between the different keys
	final gapX: Int;
	final gapY: Int;

	// UI Accessors
	public var statusBar: haxe.ui.containers.HBox;

	var snappedPosX: Float = 0;
	var snappedPosY: Float = 0;

	override public function new(keyboard: Keyboard) {
		super();

		this.keyboard = keyboard;
		this.universe = new Visual();
		this.universe.pos(originX, originY);

		gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit);
		gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit);

		// Create cursor
		cursor.create();

		// Define the inputs
		bindInput();
	}

	override function create() {
		for (key in this.keyboard.keys) {
			drawKey(key);
		}
		this.add(universe);
	}

	override function update(delta: Float) {
		// Handle keyboard input
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

		// Difference between Int and Float division by 25!
		var moduloX = ((this.universe.x / 25) - Std.int(this.universe.x / 25)) * 25;
		var moduloY = ((this.universe.y / 25) - Std.int(this.universe.y / 25)) * 25;

		// The real screen coordinates we should draw our placing curor on
		var screenPosX = Std.int((screen.pointerX - unit / 2) / 25) * 25 + moduloX;
		var screenPosY = Std.int((screen.pointerY - unit / 2) / 25) * 25 + moduloY;

		// The keyson space (U/100) coordinates we should draw the to_be_placed_key on:
		snappedPosX = (Std.int((screenPosX + unit / 2 - this.universe.x) / 25) * 25 / 100) - 0.5;
		snappedPosY = (Std.int((screenPosY + unit / 2 - this.universe.y) / 25) * 25 / 100) - 0.5;

		if (inputMap.justPressed(PLACE_1U)) {
			drawKey(this.keyboard.addKey("1U", [snappedPosX, snappedPosY], "1U"));
		} else if (inputMap.justPressed(DELETE_SELECTED)) {
			// Delete all keys
			for (key in this.selected.keys()) {
				// First deselect everything
				this.selected[key].select();
				this.selected[key].dispose();
				// Delete from the keyson
				this.keyboard.removeKey(key);
				// Delete from viewport renderer
				this.selected.remove(key);
			}
		}

		this.cursor.pos(screenPosX - gapX / 2, screenPosY - gapY / 2); // shift the cursor right on top of the keycaps
		this.statusBar.findComponent("status").text = 'cursor pos: $snappedPosX x $snappedPosY';
	}

	// Draws and adds a key to the universe
	public function drawKey(k: keyson.Keyson.Key) {
		final key: KeyRenderer = KeyMaker.createKey(this.keyboard, k, unit, this.gapX, this.gapY, this.keyboard.keysColor);
		this.universe.add(key.create());

		// A ceramic visual does not inherit the size of it's children
		// Hence we must set it ourselves
		if (key.width + key.x > this.universe.width) {
			this.universe.width = key.width + this.gapX + key.x;
		} // we end up with the biggest value when the loop is over

		if (key.height + key.y > this.universe.height) {
			this.universe.height = key.height + this.gapY + key.y;
		}

		key.pos(unit * k.position[Axis.X], unit * k.position[Axis.Y]);
		key.onPointerDown(key, (_) -> {
			if (!key.border.visible) {
				selected[k.keyId] = key;
			} else {
				selected.remove(k.keyId);
			}
			key.select();
		});
	}

	function bindInput() {
		// We use scan code for these so that it will work with non-qwerty layouts as well
		// Basic movement
		inputMap.bindKeyCode(UP, UP);
		inputMap.bindKeyCode(DOWN, DOWN);
		inputMap.bindKeyCode(LEFT, LEFT);
		inputMap.bindKeyCode(RIGHT, RIGHT);
		// Same as above, but with arrow keys
		inputMap.bindScanCode(UP, KEY_W);
		inputMap.bindScanCode(DOWN, KEY_S);
		inputMap.bindScanCode(LEFT, KEY_A);
		inputMap.bindScanCode(RIGHT, KEY_D);

		// Zoom Time
		inputMap.bindScanCode(ZOOM_IN, EQUALS);
		inputMap.bindScanCode(ZOOM_OUT, MINUS);

		// Key Placement (Temporary)
		inputMap.bindScanCode(PLACE_1U, KEY_P);
		inputMap.bindScanCode(DELETE_SELECTED, BACKSPACE);
	}
}

enum abstract ViewportInput(Int) {
	var UP;
	var DOWN;
	var LEFT;
	var RIGHT;
	var ZOOM_IN;
	var ZOOM_OUT;
	var PLACE_1U;
	var DELETE_SELECTED;
}
