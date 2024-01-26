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

	var placer: Placer;

	// Constants
	public var screenX: Float = 0;
	public var screenY: Float = 0;

	inline static final unit: Float = 100;
	inline static final quarterUnit: Float = Std.int(unit / 4);

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

		workSurface = new Quad();
		workSurface.size(100, 100);
		workSurface.color = random.between(100000000, 999999999);
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
}
