package viewport;

import ceramic.Scene;
import ceramic.Visual;
import ceramic.TouchInfo;
import keyson.Axis;
import keyson.Keyson;
import keyson.Keyson.Keyboard;
import keyson.Keyson.Key;

class Viewport extends Scene {
	// TODO: Replace instances of keyboard with just keyson
	public var keyson: Keyson;
	public var keyboard: Keyboard;
	public var selected: Map<Key, KeyRenderer> = [];

	// Everything inside the viewport is stored here
	public var workSurface: Visual = new Visual();

	public var inputMap: Input;
	// Scroll direction (inverse for Mac)
	public var wheelFactor = 1;
	public var wheelZoomFactor = 8;

	// TODO: Yell at fire-hound about what the fuck this variable does
	var i: Int = 0;

	// This queue goes through all of the actions every frame
	var actionQueue: ActionQueue = new ActionQueue();
	var actionEvent: String = "";

	// The square that shows where the placed key is going to be located
	public var cursor: Cursor = new Cursor(unit1U, unit1U);
	public var grid: Grid = new Grid(unit1U, unit1U);

	/**
	 * Constants
	 */
	inline static final unit1U: Float = 100;

	// This is the keyson placement step size
	inline static final unitFractionU: Float = Std.int(unit1U / 4);

	inline static final movementSpeed: Int = 1000;

	inline static final zoom = 2;
	inline static final maxZoom = 2.0;
	inline static final minZoom = 0.25;
	inline static final zoomUnit = 1 / 16;

	public var distance: Float;

	inline static final originX: Float = 0;
	inline static final originY: Float = 0;

	// Gap between the different keys
	final gapX: Int;
	final gapY: Int;

	override public function new(keyson: Keyson) {
		super();

		// Initialize variables
		this.keyson = keyson;
		this.keyboard = keyson.unit[0];
		this.workSurface.pos(originX, originY);

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
		this.grid.x = originX;
		this.grid.y = originY;
		this.grid.create();
		this.add(grid);

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
		this.add(workSurface);
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
			this.workSurface.y += unitFractionU * this.workSurface.scaleY;
			this.grid.y += unitFractionU * this.workSurface.scaleY;
		}
		if (inputMap.pressed(PAN_LEFT)) {
			this.workSurface.x += unitFractionU * this.workSurface.scaleX;
			this.grid.x += unitFractionU * this.workSurface.scaleX;
		}
		if (inputMap.pressed(PAN_DOWN)) {
			this.workSurface.y -= unitFractionU * this.workSurface.scaleY;
			this.grid.y -= unitFractionU * this.workSurface.scaleY;
		}
		if (inputMap.pressed(PAN_RIGHT)) {
			this.workSurface.x -= unitFractionU * this.workSurface.scaleX;
			this.grid.x -= unitFractionU * this.workSurface.scaleX;
		}
		// ZOOMING!
		if (inputMap.pressed(ZOOM_IN)) {
			// nothing like nice predictable results
			this.workSurface.scaleX = if (this.workSurface.scaleX < maxZoom) this.workSurface.scaleX + zoomUnit else maxZoom;
			this.workSurface.scaleY = if (this.workSurface.scaleY < maxZoom) this.workSurface.scaleY + zoomUnit else maxZoom;
			this.cursor.scaleX = this.workSurface.scaleX;
			this.cursor.scaleY = this.workSurface.scaleY;
			this.grid.scaleX = this.workSurface.scaleX;
			this.grid.scaleY = this.workSurface.scaleY;
			StatusBar.inform('Zoom at: ${this.workSurface.scaleX}');
		} else if (inputMap.pressed(ZOOM_OUT)) {
			this.workSurface.scaleX = if (this.workSurface.scaleX > minZoom) this.workSurface.scaleX - zoomUnit else minZoom;
			this.workSurface.scaleY = if (this.workSurface.scaleY > minZoom) this.workSurface.scaleY - zoomUnit else minZoom;
			this.cursor.scaleX = this.workSurface.scaleX;
			this.cursor.scaleY = this.workSurface.scaleY;
			this.grid.scaleX = this.workSurface.scaleX;
			this.grid.scaleY = this.workSurface.scaleY;
			StatusBar.inform('Zoom at: ${this.workSurface.scaleX}');
		}
	}

	/**
	 * Handles the position of the cursor and key placing, removing, and other manipulations
	 */
	public function cursorUpdate() {
		// presuming both our axes are scaled uniformly and in accord:
		final scale = this.workSurface.scaleX;
		final scaledUnitFractionU = unitFractionU * scale;
		final scaledUnit1U = unit1U * scale;

		// Difference between Int and Float division by unitFractionU in pixels
		final moduloX = (((this.workSurface.x / scaledUnitFractionU)
			- Std.int(this.workSurface.x / scaledUnitFractionU)) * scaledUnitFractionU);
		final moduloY = (((this.workSurface.y / scaledUnitFractionU)
			- Std.int(this.workSurface.y / scaledUnitFractionU)) * scaledUnitFractionU);

		// The real screen coordinates we should draw our placing cursor on
		final screenPosX = (Std.int((screen.pointerX - scaledUnit1U / 2) / scaledUnitFractionU) * scaledUnitFractionU + moduloX);
		final screenPosY = (Std.int((screen.pointerY - scaledUnit1U / 2) / scaledUnitFractionU) * scaledUnitFractionU + moduloY);

		// The keyson space (1U) coordinates we would draw the key to be placed on
		final snappedPosX = (Std.int((screenPosX - this.workSurface.x) / scaledUnitFractionU) * scaledUnitFractionU / scaledUnit1U);
		final snappedPosY = (Std.int((screenPosY - this.workSurface.y) / scaledUnitFractionU) * scaledUnitFractionU / scaledUnit1U);

		// Position the cursor right on top of the keycaps
		this.cursor.pos(screenPosX - gapX / 2 * scale, screenPosY - gapY / 2 * scale);

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

		var oldX: Float = 0;
		var oldY: Float = 0;
		var olderX: Float = 0;
		var olderY: Float = 0;
		if (inputMap.pressed(PAN)) {
			// At this point we have last position (oldX) and the position before that (olderX)
			if (olderX == snappedPosX && oldX != olderX)
				oldX = olderX;
			if (olderY == snappedPosY && oldY != olderY)
				oldY = olderY;
			// Add the difference of (old position to current position) to the workSurface and grid
			final diffX = snappedPosX - oldX;
			final diffY = snappedPosY - oldY;
			olderX = oldX;
			olderY = oldY;
			oldX = snappedPosX;
			oldY = snappedPosY;
			// StatusBar.inform('pan action: $diffX, $diffY');
			this.workSurface.y += diffY * unitFractionU * this.workSurface.scaleY;
			this.grid.y += diffY * unitFractionU * this.workSurface.scaleY;
			this.workSurface.x += diffX * unitFractionU * this.workSurface.scaleX;
			this.grid.x += diffX * unitFractionU * this.workSurface.scaleX;
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
		this.workSurface.add(createdKey);

		/**
		 * A ceramic visual does not inherit the size of it's children
		 * Hence we must set it ourselves
		 * We will end up with the biggest value once the loop is over
		 */
		if (key.width + key.x > this.workSurface.width) {
			this.workSurface.width = key.width + this.gapX + key.x;
		}

		if (key.height + key.y > this.workSurface.height) {
			this.workSurface.height = key.height + this.gapY + key.y;
		}

		return createdKey;
	}

	/**
	 * Used to process wheel zooming
	 */
	function mouseWheel(x: Float, y: Float): Void {
		x *= wheelFactor #if mac * -1.0 #end;
		y *= wheelFactor;

		// TODO somehow make the wheel zoom way slower than 1:1
		i = if (i < wheelZoomFactor) i + 1 else 0;

		// Dampen the wheel zoom by skipping events
		if (i >= wheelZoomFactor) { // Now do the zooming!
			// ZOOM IN
			if (y < 0) {
				this.workSurface.scaleX = if (this.workSurface.scaleX < maxZoom) this.workSurface.scaleX + zoomUnit / 4 else maxZoom;
				this.workSurface.scaleY = if (this.workSurface.scaleY < maxZoom) this.workSurface.scaleY + zoomUnit / 4 else maxZoom;
				this.cursor.scaleX = this.workSurface.scaleX;
				this.cursor.scaleY = this.workSurface.scaleY;
				this.grid.scaleX = this.workSurface.scaleX;
				this.grid.scaleY = this.workSurface.scaleY;
				StatusBar.inform('Zoom wheel: ${this.workSurface.scaleX} ($distance)');
				// ZOOM OUT
			} else if (y > 0) {
				this.workSurface.scaleX = if (this.workSurface.scaleX > minZoom) this.workSurface.scaleX - zoomUnit / 4 else minZoom;
				this.workSurface.scaleY = if (this.workSurface.scaleY > minZoom) this.workSurface.scaleY - zoomUnit / 4 else minZoom;
				this.cursor.scaleX = this.workSurface.scaleX;
				this.cursor.scaleY = this.workSurface.scaleY;
				this.grid.scaleX = this.workSurface.scaleX;
				this.grid.scaleY = this.workSurface.scaleY;
				StatusBar.inform('Zoom wheel: ${this.workSurface.scaleX} ($distance)');
			}
		}
	}
}
