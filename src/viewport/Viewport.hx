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

	public var inputMap: Input;
	public var wheelFactor = 1; // scroll direction (inverse for Mac)
	public var wheelZoomFactor = 8;

	var i: Int = 0;

	public var selected: Map<Key, KeyRenderer> = [];

	// renders our keyson elements into a compound ceramic entity
	public var keyboardUnit: Visual = new Visual();

	// This queue goes through all of the actions every frame
	// Eventually we can use this to "rewind" and undo
	var actionQueue: ActionQueue = new ActionQueue();
	var actionEvent: String = "";

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

		// Define the inputs
		this.inputMap = new Input();

		var gimbal = new Gimbal(100, 100);
		gimbal.create();
		gimbal.x = 1550;
		gimbal.y = 800;
		this.add(gimbal);

		gimbal.onPointerOver(gimbal, (_) -> {
			StatusBar.inform('Gimbal under mouse! ${screen.pointerX} ${screen.pointerY}');
		});
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
		moveViewportCamera(delta);
		distance = Std.int(delta * 100); // results in 2-5 values
		cursorUpdate();
		this.actionQueue.act();
	}

	/**
	 * Handles the movement of the viewport camera/work surface
	 */
	public inline function moveViewportCamera(delta: Float) {
		if (input.keyPressed(LCTRL) || input.keyPressed(RCTRL) || input.keyPressed(LMETA) || input.keyPressed(RMETA)) {
			return; // ignore all modified key presses (for now)
		}

		// temporary 1/4 unit aligned fixed stepping for good grid alignment:
		if (inputMap.pressed(PAN_UP)) {
			this.keyboardUnit.y += unitFractionU * this.keyboardUnit.scaleY;
			this.grid.y += unitFractionU * this.keyboardUnit.scaleY;
		}
		if (inputMap.pressed(PAN_LEFT)) {
			this.keyboardUnit.x += unitFractionU * this.keyboardUnit.scaleX;
			this.grid.x += unitFractionU * this.keyboardUnit.scaleX;
		}
		if (inputMap.pressed(PAN_DOWN)) {
			this.keyboardUnit.y -= unitFractionU * this.keyboardUnit.scaleY;
			this.grid.y -= unitFractionU * this.keyboardUnit.scaleY;
		}
		if (inputMap.pressed(PAN_RIGHT)) {
			this.keyboardUnit.x -= unitFractionU * this.keyboardUnit.scaleX;
			this.grid.x -= unitFractionU * this.keyboardUnit.scaleX;
		}
		// ZOOMING!
		if (inputMap.pressed(ZOOM_IN)) {
			// nothing like nice predictable results
			this.keyboardUnit.scaleX = if (this.keyboardUnit.scaleX < maxZoom) this.keyboardUnit.scaleX + zoomUnit else maxZoom;
			this.keyboardUnit.scaleY = if (this.keyboardUnit.scaleY < maxZoom) this.keyboardUnit.scaleY + zoomUnit else maxZoom;
			this.cursor.scaleX = this.keyboardUnit.scaleX;
			this.cursor.scaleY = this.keyboardUnit.scaleY;
			this.grid.scaleX = this.keyboardUnit.scaleX;
			this.grid.scaleY = this.keyboardUnit.scaleY;
			StatusBar.inform('Zoom at: ${this.keyboardUnit.scaleX}');
		} else if (inputMap.pressed(ZOOM_OUT)) {
			this.keyboardUnit.scaleX = if (this.keyboardUnit.scaleX > minZoom) this.keyboardUnit.scaleX - zoomUnit else minZoom;
			this.keyboardUnit.scaleY = if (this.keyboardUnit.scaleY > minZoom) this.keyboardUnit.scaleY - zoomUnit else minZoom;
			this.cursor.scaleX = this.keyboardUnit.scaleX;
			this.cursor.scaleY = this.keyboardUnit.scaleY;
			this.grid.scaleX = this.keyboardUnit.scaleX;
			this.grid.scaleY = this.keyboardUnit.scaleY;
			StatusBar.inform('Zoom at: ${this.keyboardUnit.scaleX}');
		}
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

		// TODO make sure the action goes to the proper keyson and keyboardUnit
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
		if (inputMap.pressed(PAN)) {
			// at this point we have last position (oldX) and the position before that (olderX)
			// beside the new position (snappedPosX)
			if (olderX == snappedPosX && oldX != olderX)
				oldX = olderX;
			if (olderY == snappedPosY && oldY != olderY)
				oldY = olderY;
			// add the difference of (old position to current position) to the keyboardUnit and grid
			final diffX = snappedPosX - oldX;
			final diffY = snappedPosY - oldY;
			olderX = oldX;
			olderY = oldY;
			oldX = snappedPosX;
			oldY = snappedPosY;
			// StatusBar.inform('pan action: $diffX, $diffY');
			this.keyboardUnit.y += diffY * unitFractionU * this.keyboardUnit.scaleY;
			this.grid.y += diffY * unitFractionU * this.keyboardUnit.scaleY;
			this.keyboardUnit.x += diffX * unitFractionU * this.keyboardUnit.scaleX;
			this.grid.x += diffX * unitFractionU * this.keyboardUnit.scaleX;
		} else {
			olderX = oldX;
			olderY = oldY;
			oldY = snappedPosY;
			oldX = snappedPosX;
		}

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

		// Wheel Zooming:
		screen.onMouseWheel(screen, mouseWheel);
		// TODO check for proper project reciving actions of seelection
		key.onPointerDown(key, (info) -> {
			if (this.paused)
				return;
			if (info.buttonId != 2) // now on we select with right mouse button (temporary)
				return;
			if (key.border.visible) {
				selected.remove(k);
				StatusBar.inform('Deselected key: "${k.legends[0].symbol}" at: ${k.position}');
			} else {
				selected[k] = key;
				StatusBar.inform('Selected key: "${k.legends[0].symbol}" at: ${k.position}');
			}
			key.select();
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

	function mouseWheel(x: Float, y: Float): Void { // porcess scrolling with vertical mouse wheel
		x *= wheelFactor #if mac * -1.0 #end;
		y *= wheelFactor;
		// TODO somehow make the wheel zoom way slower than 1:1
		i = if (i < wheelZoomFactor) i + 1 else 0;
		if (i >= wheelZoomFactor) { // dampen the wheel zoom by skipping events
			// now do the zooming!
			if (y < 0) { // zoom_in seems to be with negative values
				this.keyboardUnit.scaleX = if (this.keyboardUnit.scaleX < maxZoom) this.keyboardUnit.scaleX + zoomUnit / 4 else maxZoom;
				this.keyboardUnit.scaleY = if (this.keyboardUnit.scaleY < maxZoom) this.keyboardUnit.scaleY + zoomUnit / 4 else maxZoom;
				this.cursor.scaleX = this.keyboardUnit.scaleX;
				this.cursor.scaleY = this.keyboardUnit.scaleY;
				this.grid.scaleX = this.keyboardUnit.scaleX;
				this.grid.scaleY = this.keyboardUnit.scaleY;
				StatusBar.inform('Zoom wheel: ${this.keyboardUnit.scaleX} (${distance})');
			} else if (y > 0) { // zoom_out is when positive values are present
				this.keyboardUnit.scaleX = if (this.keyboardUnit.scaleX > minZoom) this.keyboardUnit.scaleX - zoomUnit / 4 else minZoom;
				this.keyboardUnit.scaleY = if (this.keyboardUnit.scaleY > minZoom) this.keyboardUnit.scaleY - zoomUnit / 4 else minZoom;
				this.cursor.scaleX = this.keyboardUnit.scaleX;
				this.cursor.scaleY = this.keyboardUnit.scaleY;
				this.grid.scaleX = this.keyboardUnit.scaleX;
				this.grid.scaleY = this.keyboardUnit.scaleY;
				StatusBar.inform('Zoom wheel: ${this.keyboardUnit.scaleX} (${distance})');
			}
		}
	}
}
