package viewport;

import ceramic.Quad;
import ceramic.Scene;

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
	var workSurface: Quad;

	var cursor: Quad;

	// Constants
	public var screenX: Float = 0;
	public var screenY: Float = 0;

	// GLOBAL SCENE

	/**
	 * Dispatches keyboard and mouse inputs to the seperate functions
	 */
	public function inputDispatch() {}

	/**
	 * Initializes the scene
	 */
	override public function create() {
		workSurface = new Quad();
		workSurface.size(100, 100);
		workSurface.color = 0xffffffff;
		workSurface.depth = -1;
		this.add(workSurface);

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

	// CURSOR

	/**
	 * Runs every frame, used to position the cursor
	 */
	public function cursorUpdate() {
		cursor.x = screen.pointerX - screenX;
		cursor.y = screen.pointerY - screenY;
		cursor.pos(cursor.x - cursor.x % 25, cursor.y - cursor.y % 25);
	}
}
