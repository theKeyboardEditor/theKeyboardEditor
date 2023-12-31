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
	var selectedIDs: Array<Int> = [];

	// Constants
	inline static final unit = 100;
	inline static final quarterUnit = unit / 4;
	inline static final movementSpeed: Int = 1000;
	inline static final zoom = 2;
	inline static final originX: Float = 510;
	inline static final originY: Float = 60;

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
		// Handle keyboard input.
		if (inputMap.pressed(UP)) {
			this.universe.y += 25; //movementSpeed * delta;
		}
		if (inputMap.pressed(LEFT)) {
			this.universe.x += 25; //movementSpeed * delta;
		}
		if (inputMap.pressed(DOWN)) {
			this.universe.y -= 25; //movementSpeed * delta;
		}
		if (inputMap.pressed(RIGHT)) {
			this.universe.x -= 25; //movementSpeed * delta;
		}

// Zoming disabled until it works again
/*		// ZOOMING!
		if (inputMap.pressed(ZOOM_IN)) {
			this.universe.scaleX += zoom * delta;
			this.universe.scaleY += zoom * delta;
		} else if (inputMap.pressed(ZOOM_OUT)) {
			this.universe.scaleX -= zoom * delta;
			this.universe.scaleY -= zoom * delta;
		}
*/

		var moduloX= (
									(
									          (this.universe.x / 25)
									- (Std.int(this.universe.x / 25))
									)
									* 25
									);

		var moduloY= (
									(
									          (this.universe.y / 25)
									- (Std.int(this.universe.y / 25))
									)
									* 25
									);

		var screenPosX = (
											(
											(Std.int((screen.pointerX / this.universe.scaleX  - unit/2) / 25))
											+ (			   this.universe.x / 25) 
											- (Std.int(this.universe.x / 25))
											)
											* 25
											);
		var screenPosY = (
											(
											(Std.int((screen.pointerY / this.universe.scaleY - unit/2) / 25))
											+         (this.universe.y / 25)
											- (Std.int(this.universe.y / 25))
											)
											* 25
											);

		var snappedPosX = (
											Std.int((screenPosX + unit / 2 - moduloX - this.universe.x) / 25) * .25
											);
		var snappedPosY = (
											Std.int((screenPosY + unit / 2 - moduloY - this.universe.y) / 25) * .25
											);

		var carryX =((((screenPosX + unit * .5 - moduloX - this.universe.x) / 25) * .25) - snappedPosX) * 100;

		if (inputMap.justPressed(PLACE_1U)) {
			drawKey(this.keyboard.addKey("1U", [
				(snappedPosX),
				(snappedPosY)
			], "1U"));
		}

		this.cursor.pos(screenPosX,screenPosY);
		this.statusBar.findComponent("status").text = 'Keyson: ${snappedPosX} x ${snappedPosY} \n Screen:${screenPosX} x ${screenPosY}  Carry: ${carryX}';
	}

	// Draws and adds a key to the universe
	public function drawKey(k: keyson.Keyson.Key) {
		final key: KeyRenderer = KeyMaker.createKey(k, unit, this.gapX, this.gapY, this.keyboard.keysColor);
		this.universe.add(key.create());

		final keyLegends: Array<LegendRenderer> = KeyMaker.createLegend(this.keyboard, k, unit);
		for (l in keyLegends) {
			this.universe.add(l.create());
		}

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
				selectedIDs.remove(k.keyId); // just in case
				selectedIDs.push(k.keyId);
			} else {
				selectedIDs.remove(k.keyId);
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
}
