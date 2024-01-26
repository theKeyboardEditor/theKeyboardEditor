package viewport;

import ceramic.Quad;
import ceramic.Visual;
import ceramic.Scene;
import keyson.Axis;
import keyson.Keyson;
import keyson.Keyson.Keyboard;
import keyson.Keyson.Key;

class Viewport extends Scene {
	/**
	 * The keyson being renderered
	 */
	public var keyson: keyson.Keyson;

	/**
	 * This is where we map all of the different events to specific keys
	 * See Input.hx file for more details
	 */
	final inputMap = new Input();

	/**
	 * Ceramic elements
	 */
	var workSurface: Visual;
	var placer: Placer;

	// Constants
	public var screenX: Float = 0;
	public var screenY: Float = 0;

	inline static final unit: Float = 100;
	inline static final quarterUnit: Float = Std.int(unit / 4);
	inline static final skipFrames: Float = 10; // how many frames to skip

	var framesSkipped: Float = 0; // current count (kept between skips)

	// GLOBAL SCENE

	/**
	 * Dispatches keyboard and mouse inputs to the seperate functions
	 */
	public function inputDispatch() {}

	/**
	 * Initializes the scene
	 */
	override public function create() {
		var grid = new Grid();
		grid.primaryStep(unit);
		grid.subStep(quarterUnit);
		grid.depth = -1;
		this.add(grid);

		var random = new ceramic.SeedRandom(Date.now().getTime());

		workSurface = parseInKeyboard(keyson);
		this.add(workSurface);

		placer = new Placer();
		placer.size(100, 100);
		placer.anchor(.5, .5);
		placer.depth = 10;
		this.add(placer);
	}

	/**
	 * Runs every frame
	 */
	override public function update(delta: Float) {
		placerUpdate();
		/*   run a task every ${skipFrames} only:
		 *
		 * (this is primarly intended for odd cases like zooming)
		 */
		if (framesSkipped < skipFrames) {
			framesSkipped++;
		} else {
			framesSkipped = 0;

			// 0.5 is accounting for the middle of the 1U sized placer
			StatusBar.pos(placer.x / unit - .5, placer.y / unit - .5);
		}
	}

	// PLACER

	/**
	 * Runs every frame, used to position the placer
	 */
	public function placerUpdate() {
		placer.x = screen.pointerX - screenX;
		placer.y = screen.pointerY - screenY;
		placer.pos(placer.x - placer.x % 25, placer.y - placer.y % 25);
	}

	/**
	 *  Called only once to parse in the keyboard into the workSurface
	 */
	public function parseInKeyboard(keyboard: Keyson): Visual {
		final workKeyboard = new Visual(); // initialize what we draw onto
		for (keyboardUnit in keyboard.units) { // parse all units (usually just one)
			// Set unit's gap values
			final gapX = Std.int((keyboardUnit.keyStep[Axis.X] - keyboardUnit.capSize[Axis.X]) / keyboardUnit.keyStep[Axis.X] * unit);
			final gapY = Std.int((keyboardUnit.keyStep[Axis.Y] - keyboardUnit.capSize[Axis.Y]) / keyboardUnit.keyStep[Axis.Y] * unit);
			for (key in keyboardUnit.keys) { // parse all keycaps/elements
				if (keyboardUnit.keys.contains(key) == false) {
					throw "Key does not exist inside the Keyson keyboard"; // @Logo is this sanity check actually sane?
				}
				final keycap: KeyRenderer = KeyMaker.createKey(keyboardUnit, key, unit, gapX, gapY, keyboardUnit.keysColor);
				keycap.pos(unit * key.position[Axis.X], unit * key.position[Axis.Y]); // position the unit
				final createdKey = keycap.create(); // execute the drawing
				workKeyboard.add(createdKey);
			}
		}
		return workKeyboard;
	}
}
