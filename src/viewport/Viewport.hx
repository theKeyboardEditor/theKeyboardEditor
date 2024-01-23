package viewport;

import ceramic.Quad;
import ceramic.Scene;

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

	// How can wheelCycles keep the count in succesive invocations of function mouseWheel(); without this?
	// repeat it must not clear when the function finishes.
	var wheelCycles: Int = 0;

	// This queue goes through all of the actions every frame
	var actionQueue: ActionQueue = new ActionQueue();
	var actionEvent: String = "";

	var oldX: Float = 0;
	var oldY: Float = 0;
	var olderX: Float = 0;
	var olderY: Float = 0;

	// The square that shows where the placed key is going to be located
	public var cursor: Cursor = new Cursor(unit1U, unit1U); // here we define it's size
	public var grid: Grid = new Grid(unit1U, unit1U);
	public var screenX: Float = 224; // where Viewport resides on the screen
	public var screenY: Float = 32;  // TODO this should NOT be set here!

	inline static final unit1U: Float = 100;

	// This is the keyson placement step size
	inline static final unitFractionU: Float = Std.int(unit1U / 4);

	inline static final movementSpeed: Int = 1000;

	inline static final zoom = 2;
	inline static final maxZoom = 2.0;
	inline static final minZoom = 0.25;
	inline static final zoomUnit = 1 / 16;

	// Gap between the different keys
	final gapX: Int;
	final gapY: Int;

	override public function new(keyson: Keyson) {
		super();

		// Initialize variables
		this.keyson = keyson;
		this.keyboard = keyson.unit[0];
		this.workSurface.depth = -12;
		trace ('worksurface: ${this.workSurface.depth}');

		// Set the gap between the keys based on the keyson file
		gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit1U);
		gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit1U);

		// Create cursor object
		this.cursor.create();
		 // if we don't add it (again) it renders beneat grid and workSurface regardless what
		this.add(cursor);
		trace ('Cursor: ${this.cursor.depth}');

		// Define grid
		this.grid.offsetX = -gapX / 2;
		this.grid.offsetY = -gapY / 2;
		this.grid.subStepX = unitFractionU;
		this.grid.subStepY = unitFractionU;
		this.grid.create();
		this.grid.depth = -12;
		this.add(grid);

		// Define the inputs
		this.inputMap = new Input();

		var gimbal = new Gimbal(100, 100);
		gimbal.create();
		gimbal.x = 1250;
		gimbal.y = 800;
		this.add(gimbal);
	}

	override function create() {
		for (key in this.keyboard.keys) {
			drawKey(key); // add a key to worksurface
		}
		this.add(workSurface);
	}

	override function update(delta: Float) {
		// Wheel Zooming:
		screen.onMouseWheel(screen, mouseWheel);
		moveViewportCamera(delta);
		cursorUpdate();
		this.actionQueue.act();
	}

	public function cursorUpdate() {
		// presuming both our axes are scaled uniformly and in accord:
		final scale = this.workSurface.scaleX;
		final scaledUnitFractionU = unitFractionU * scale;
		final scaledUnit1U = unit1U * scale;
		final placerArrowX = scaledUnit1U / 2; // make placer centered to mouse arrow
		final placerArrowY = scaledUnit1U / 2;
		screenX = if ( screenX != null) screenX else 224; // TODO fallback
		screenY = if ( screenX != null) screenY else 32;

		// The real screen coordinates we should draw our placing cursor on
		final screenPosX = (Std.int((screen.pointerX - screenX - placerArrowX) / scaledUnitFractionU) * scaledUnitFractionU);
		final screenPosY = (Std.int((screen.pointerY - screenY - placerArrowY) / scaledUnitFractionU) * scaledUnitFractionU);

		// The keyson space (1U) coordinates we would draw the key to be placed on
		final snappedPosX = (Std.int((screenPosX) / scaledUnitFractionU) * scaledUnitFractionU / scaledUnit1U);
		final snappedPosY = (Std.int((screenPosY) / scaledUnitFractionU) * scaledUnitFractionU / scaledUnit1U);

		// Position the cursor right on top of the keycaps
		this.cursor.pos(screenPosX, screenPosY);

		// Adjust the status bar with the position of the cursor
		StatusBar.pos(snappedPosX, snappedPosY); // can only have 2 args
		//StatusBar.pos(screenPosX, screenPosY); // can only have 2 args
		//StatusBar.pos(screen.pointerX, screen.pointerY); // can only have 2 args

		// Check for key presses and queue appropriate action
		if (inputMap.justPressed(PLACE_1U)) { // key [p] for 1U?
			this.actionQueue.push(new PlaceKey(this, snappedPosX, snappedPosY, "1U"));
		} else if (inputMap.justPressed(PLACE_ISO)) { // key [wheelCycles] for ISO?
			this.actionQueue.push(new PlaceKey(this, snappedPosX, snappedPosY, "2U"));
		} else if (inputMap.justPressed(DELETE_SELECTED)) { // key [del] for delete?
			this.actionQueue.push(new DeleteKeys(this));
		}

		if (inputMap.justPressed(UNDO)) {
			this.actionQueue.undo();
		}

		if (inputMap.pressed(PAN)) { // this can be middle mouse button!
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
			this.workSurface.y += 2 * diffY * unitFractionU * this.workSurface.scaleY;
			this.grid.y += 2 * diffY * unitFractionU * this.workSurface.scaleY;
			this.workSurface.x += 2 * diffX * unitFractionU * this.workSurface.scaleX;
			this.grid.x += 2 * diffX * unitFractionU * this.workSurface.scaleX;
		} else {
			olderX = oldX;
			olderY = oldY;
			oldY = snappedPosY;
			oldX = snappedPosX;
		}
	}

	/**
	 * Initializes the scene
	 */
	public function drawKey(k: Key): Visual {
		if (this.keyboard.keys.contains(k) == false) {
			throw "Key does not exist inside the Keyson keyboard";
		}

		final key: KeyRenderer = KeyMaker.createKey(this.keyboard, k, unit1U, this.gapX, this.gapY, this.keyboard.keysColor);
		key.pos(unit1U * k.position[Axis.X], unit1U * k.position[Axis.Y]);
		key.onPointerOver(key, (_) -> {
			//			StatusBar.inform('Mouse hovering at: ${k.position}');
			StatusBar.inform('Viewport offset: ${screenX}, ${screenY}');
		});

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
		cursor = new Quad();
		cursor.size(50, 50);
		cursor.anchor(.5, .5);
		cursor.color = 0xff0000ff;
		cursor.depth = 10;
		this.add(cursor);
	}

	/**
	 * Runs every frame
	 */
	override public function update(delta: Float) {
		cursorUpdate();
	}
		// TODO somehow make the wheel zoom way slower than 1:1
		wheelCycles = if (wheelCycles < 60) {
			wheelCycles + 1
			} else 0;

		// Dampen the wheel zoom by skipping events
		if (wheelCycles >= 60) { // Now do the zooming!
			// ZOOM IN
			if (y < 0) {
				this.workSurface.scaleX = if (this.workSurface.scaleX < maxZoom) this.workSurface.scaleX + zoomUnit / 4 else maxZoom;
				this.workSurface.scaleY = if (this.workSurface.scaleY < maxZoom) this.workSurface.scaleY + zoomUnit / 4 else maxZoom;
				this.cursor.scaleX = this.workSurface.scaleX;
				this.cursor.scaleY = this.workSurface.scaleY;
				this.grid.scaleX = this.workSurface.scaleX;
				this.grid.scaleY = this.workSurface.scaleY;
				StatusBar.inform('Zoom wheel: ${this.workSurface.scaleX}');
				// ZOOM OUT
			} else if (y > 0) {
				this.workSurface.scaleX = if (this.workSurface.scaleX > minZoom) this.workSurface.scaleX - zoomUnit / 4 else minZoom;
				this.workSurface.scaleY = if (this.workSurface.scaleY > minZoom) this.workSurface.scaleY - zoomUnit / 4 else minZoom;
				this.cursor.scaleX = this.workSurface.scaleX;
				this.cursor.scaleY = this.workSurface.scaleY;
				this.grid.scaleX = this.workSurface.scaleX;
				this.grid.scaleY = this.workSurface.scaleY;
				StatusBar.inform('Zoom wheel: ${this.workSurface.scaleX}');
			}
		}
	}
}
