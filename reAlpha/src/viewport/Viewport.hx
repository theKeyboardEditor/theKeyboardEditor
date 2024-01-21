package viewport;

import ceramic.Scene;
import ceramic.Visual;
import ceramic.TouchInfo;
import keyson.Axis;
import keyson.Keyson;
import keyson.Keyson.Keyboard;
import keyson.Keyson.Key;

/*
 * Viewport is the screenarea that contains the project representation
 * 		with all helpers
 */
class Viewport extends Scene {
	// TODO: Replace instances of keyboard with just keyson
	public var keyson: Keyson;
	public var keyboard: Keyboard;

	var i: Int = 0;

	public var selected: Map<Key, KeyRenderer> = [];

	// renders our keyson elements into a compound ceramic entity
	public var keyboardUnit: Visual = new Visual();

	var oldX: Float;
	var oldY: Float;
	var olderX: Float;
	var olderY: Float;

	// The square that shows where the placed key is going to be located
	public var cursor: Cursor = new Cursor(unit1U, unit1U);
	public var grid: Grid = new Grid(unit1U, unit1U);
	public var distance: Float;

	// Constants
	inline static final unit1U: Float = 100; // TODO unit1U is 1U for keyson key size
	inline static final unitFractionU: Float = Std.int(unit1U / 4); // This is the keyson placement step size
	// for some reason that eludes me setting this to anything lower than 1/5 breaks placing cursor fine alignment?
	inline static final movementSpeed: Int = 1000;
	inline static final zoom = 2;
	inline static final maxZoom = 2.0;
	inline static final minZoom = 0.25;
	inline static final zoomUnit = 1 / 16; // 1/32 is accurate enough for most zooming cases
	inline static final originX: Float = 110;
	inline static final originY: Float = 60;

	// Gap between the different keys
	final gapX: Int;
	final gapY: Int;

	// initialize new viewport
	override public function new(keyson: Keyson) {
		super();

		// Initialize variables
		this.keyson = keyson;
		this.keyboard = keyson.unit[0]; // TODO  we presume a single unit
		this.keyboardUnit.pos(originX, originY); // position the worksurface no the viewport

		// Set the gap between the keys based on the keyson file
		gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit1U);
		gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit1U);

		// Create cursor object
		this.cursor.create();

		// Define grid
		this.grid.offsetX = -gapX / 2;
		this.grid.offsetY = -gapY / 2;
		this.grid.subStepX = unitFractionU;
		this.grid.subStepY = unitFractionU;
		this.grid.pos(originX, originY);
		this.grid.create();
		this.add(grid); // grid is part of the viewport

	}

	/**
	 * Called when scene has finished preloading
	 */
	override function create() {
		for (key in this.keyboard.keys) {
			drawKey(key);
		}
		this.add(keyboardUnit); // adding the worksurface to the viewport
	}

	/**
	 * Here, you can add code that will be executed at every frame
	 */
	override function update(delta: Float) {
		cursorUpdate();
	}

	/**
	 * Handles the position of the cursor and key placing, removing, and other manipulations
	 */
	public function cursorUpdate() {
		// presuming both our axes are scaled uniformly and in accord:
		final scale = this.keyboardUnit.scaleX;
		final scaledUnitFractionU = unitFractionU * scale;
		final scaledUnit1U = unit1U * scale;

		// Difference between Int and Float division by unitFractionU!
		final moduloX = (((this.keyboardUnit.x / scaledUnitFractionU)
			- Std.int(this.keyboardUnit.x / scaledUnitFractionU)) * scaledUnitFractionU);
		final moduloY = (((this.keyboardUnit.y / scaledUnitFractionU) - Std.int(this.keyboardUnit.y / scaledUnitFractionU)) * scaledUnitFractionU); // this is in pixels

		// The real screen coordinates we should draw our placing curor on
		final screenPosX = (Std.int((screen.pointerX - scaledUnit1U / 2) / scaledUnitFractionU) * scaledUnitFractionU + moduloX);
		final screenPosY = (Std.int((screen.pointerY - scaledUnit1U / 2) / scaledUnitFractionU) * scaledUnitFractionU + moduloY);

		// The keyson space (1U) coordinates we would draw the to_be_placed_key on:
		final snappedPosX = (Std.int((screenPosX - this.keyboardUnit.x) / scaledUnitFractionU) * scaledUnitFractionU / scaledUnit1U);
		final snappedPosY = (Std.int((screenPosY - this.keyboardUnit.y) / scaledUnitFractionU) * scaledUnitFractionU / scaledUnit1U);

		// Position the cursor right on top of the keycaps
		this.cursor.pos(screenPosX - gapX / 2 * scale, screenPosY - gapY / 2 * scale);

		// Adjust the status bar with the position of the cursor
		StatusBar.pos(snappedPosX, snappedPosY); // can only have 2 args
	}

	/**
	 * Draws and adds a key to the work surface
	 */
	public function drawKey(k: Key): Visual {
		if (this.keyboard.keys.contains(k) == false) {
			throw "Key does not exist inside the Keyson keyboard";
		}

		final key: KeyRenderer = KeyMaker.createKey(this.keyboard, k, unit1U, this.gapX, this.gapY, this.keyboard.keysColor);
		key.pos(unit1U * k.position[Axis.X], unit1U * k.position[Axis.Y]);
		key.onPointerOver(key, (_) -> {
			StatusBar.inform('Mouse hovering at: ${k.position}');
		});
		final createdKey = key.create();
		this.keyboardUnit.add(createdKey);

		/**
		 * A ceramic visual does not inherit the size of it's children
		 * Hence we must set it ourselves
		 * We will end up with the biggest value once the loop is over
		 */
		if (key.width + key.x > this.keyboardUnit.width) {
			this.keyboardUnit.width = key.width + this.gapX + key.x;
		}

		if (key.height + key.y > this.keyboardUnit.height) {
			this.keyboardUnit.height = key.height + this.gapY + key.y;
		}

		return createdKey;
	}
}
