package viewport;

import ceramic.Scene;
import ceramic.Visual;
import keyson.Axis;
import keyson.Keyson.Keyboard;

class Viewport extends Scene {
	public var keyboard: Keyboard;
	public var inputMap: Input;
	public var selected: Map<Int, KeyRenderer> = [];

	// Everything inside the viewport is stored here
	public var universe: Visual = new Visual();

	// This queue goes through all of the actions every frame
	// Eventually we can use this to "rewind" and undo
	var actionQueue: ActionQueue = new ActionQueue();
	// The square that shows where the placed key is going to be located
	var cursor: Cursor = new Cursor(unit1U, unit1U);
	var grid: Grid = new Grid(unit1U, unit1U);

	// Constants
	inline static final unit1U: Float = 100; // TODO unit1U is 1U for keyson key size
	inline static final unit025U: Float = Std.int(unit1U / 4); // This is the keyson placement step size
	inline static final movementSpeed: Int = 1000;
	inline static final zoom = 2;
	inline static final originX: Float = 510;
	inline static final originY: Float = 60;

	// Gap between the different keys
	final gapX: Int;
	final gapY: Int;

	override public function new(keyboard: Keyboard) {
		super();

		// Initialize variables
		this.keyboard = keyboard;
		this.universe.pos(originX, originY);

		// Set the gap between the keys based on the keyson file
		gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit1U);
		gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit1U);

		// Create cursor object
		this.cursor.create();

		this.grid.offsetX = originX - gapX / 2;
		this.grid.offsetY = originY - gapY / 2;
		this.grid.subStepX = unit025U;
		this.grid.subStepY = unit025U;
		this.grid.create();

		// Define the inputs
		this.inputMap = new Input();
	}

	/**
	 * Called when scene has finished preloading
	 */
	override function create() {
		for (key in this.keyboard.keys) {
			drawKey(key);
		}
		this.add(universe);
	}

	/**
	 * Here, you can add code that will be executed at every frame
	 */
	override function update(delta: Float) {
		moveViewportCamera(delta);
		cursorUpdate();
		this.actionQueue.act();
	}

	/**
	 * Handles the movement of the viewport camera/universe
	 */
	public inline function moveViewportCamera(delta: Float) {
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
	}

	/**
	 * Handles the position of the cursor and key placing, removing, and other manipulations
	 */
	public function cursorUpdate() {
		// Difference between Int and Float division by unit025U!
		final moduloX = ((this.universe.x / unit025U) - Std.int(this.universe.x / unit025U)) * unit025U;
		final moduloY = ((this.universe.y / unit025U) - Std.int(this.universe.y / unit025U)) * unit025U; // this is in pixels

		// The real screen coordinates we should draw our placing curor on
		final screenPosX = Std.int((screen.pointerX - unit1U / 2) / unit025U) * unit025U + moduloX; // this is in pixels
		final screenPosY = Std.int((screen.pointerY - unit1U / 2) / unit025U) * unit025U + moduloY;

		// The keyson space (1U) coordinates we would draw the to_be_placed_key on:
		final snappedPosX = (Std.int((screenPosX + unit1U / 2 - this.universe.x) / unit025U) * unit025U / unit1U)
			- 0.5; // 0.5U is the offset from
		final snappedPosY = (Std.int((screenPosY + unit1U / 2 - this.universe.y) / unit025U) * unit025U / unit1U)
			- 0.5; // mouse to snapped cursor

		// Position the cursor right on top of the keycaps
		this.cursor.pos(screenPosX - gapX / 2, screenPosY - gapY / 2);

		// TODO make cursor size dynamic
		// Check for key presses and queue appropriate action
		if (inputMap.justPressed(PLACE_1U)) { // key [p] for 1U?
			this.actionQueue.push(new PlaceKey(this, snappedPosX, snappedPosY, "1U"));
		} else if (inputMap.justPressed(PLACE_ISO)) { // key [i] for ISO?
			this.actionQueue.push(new PlaceKey(this, snappedPosX, snappedPosY, "2U"));
		} else if (inputMap.justPressed(DELETE_SELECTED)) { // key [del] for delete?
			this.actionQueue.push(new DeleteKeys(this));
		}

		if (inputMap.justPressed(UNDO)) {
			this.actionQueue.undo();
		}

		// Adjust the status bar with the position of the cursor
		StatusBar.pos(snappedPosX, snappedPosY);
	}

	/**
	 * Draws and adds a key to the universe
	 */
	public function drawKey(k: keyson.Keyson.Key): KeyRenderer {
		final key: KeyRenderer = KeyMaker.createKey(this.keyboard, k, unit1U, this.gapX, this.gapY, this.keyboard.keysColor);
		key.pos(unit1U * k.position[Axis.X], unit1U * k.position[Axis.Y]);
		key.onPointerDown(key, (_) -> {
			if (key.border.visible) {
				selected.remove(k.id);
			} else {
				selected[k.id] = key;
			}
			key.select();
		});
		this.universe.add(key.create());

		/**
		 * A ceramic visual does not inherit the size of it's children
		 * Hence we must set it ourselves
		 * We will end up with the biggest value once the loop is over
		 */
		if (key.width + key.x > this.universe.width) {
			this.universe.width = key.width + this.gapX + key.x;
		}

		if (key.height + key.y > this.universe.height) {
			this.universe.height = key.height + this.gapY + key.y;
		}

		return key;
	}
}
