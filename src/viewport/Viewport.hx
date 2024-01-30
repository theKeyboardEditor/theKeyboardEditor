package viewport;

import ceramic.Visual;
import ceramic.Scene;
import ceramic.TouchInfo;
import ceramic.KeyBindings;
import ceramic.KeyCode;
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
	final queue = new ActionQueue();

	/**
	 * Ceramic elements
	 */
	var workSurface: Visual;
	var placer: Placer;

	// Movement variables

	/**
	 * For dragging of the viewport
	 */
	var viewportStartX: Float = 0.0;
	var viewportStartY: Float = 0.0;

	var pointerStartX: Float = 0.0;
	var pointerStartY: Float = 0.0;

	/**
	 * For dragging keys around
	 */
	var keyPosStartX: Float = 0.0;
	var keyPosStartY: Float = 0.0;

	// there exists certain placer mismatch...
	var placerMismatchX: Float = 0.0;
	var placerMismatchY: Float = 0.0;

	/**
	 * Stuff that upsets logo but fire-h0und refuses to remove
	 */
	var activeProject: Keyson;
	var selectedKey: KeyRenderer;
	var touchType: String = "";

	// Constants
	public var screenX: Float = 0;
	public var screenY: Float = 0;

	// Size of a key
	inline static final unit: Float = 100;
	inline static final placingStep: Float = Std.int(unit / 4);
	// How many frames to skip
	inline static final skipFrames: Float = 10;
	public var framesSkipped: Float = 0; // current count (kept between skips)

	// GLOBAL SCENE

	/**
	 * Dispatches keyboard and mouse inputs to the seperate functions
	 */
	public function inputDispatch() {
		var keyBindings = new KeyBindings();

		// When the keyboard has the mouse clicked down
		this.onPointerDown(workSurface, viewportMouseDown);

		// Undo
		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_Z)], () -> {
			queue.undo();
		});
	}

	/**
	 * Initializes the scene
	 */
	override public function create() {
		var grid = new Grid();
		grid.primaryStep(unit);
		grid.subStep(placingStep);
		grid.depth = -1;
		this.add(grid);

		workSurface = parseInKeyboard(keyson);
		this.add(workSurface);

		placer = new Placer();
		placer.piecesSize = unit; // the pieces are not scaled
		placer.size(unit, unit);
		placer.anchor(.5, .5);
		placer.depth = 10;
		this.add(placer);

		inputDispatch();
	}

	/**
	 * Runs every frame
	 */
	override public function update(delta: Float) {
		placerUpdate();

		if (framesSkipped < skipFrames) {
			framesSkipped++;
		} else {
			framesSkipped = 0;
			this.onPointerDown(workSurface, (info) -> {
				if (info.buttonId == 0) {
					// StatusBar.inform('Placer at: ${placer.x / unit - .5}, ${placer.y / unit - .5}');
				}
			});
			// 0.5 is accounting for the middle of the 1U sized placer
			StatusBar.pos(placer.x / unit - .5, placer.y / unit - .5);
			//StatusBar.pos(viewportStartX, viewportStartY);
		}

		queue.act();
	}
	// PLACER

	/**
	 * Runs every frame, used to position the placer
	 */
	function placerUpdate() {
		placer.x = screen.pointerX - screenX - this.x + placerMismatchX;
		placer.y = screen.pointerY - screenY - this.y + placerMismatchY;
		placer.pos(placer.x - placer.x % placingStep, placer.y - placer.y % placingStep);
	}

	/**
	 * Called only once to parse in the keyboard into the workSurface
	 */
	function parseInKeyboard(keyboard: Keyson): Visual {
		final workKeyboard = new Visual();
		for (keyboardUnit in keyboard.units) {
			// Set unit's gap values
			final gapX = Std.int((keyboardUnit.keyStep[Axis.X] - keyboardUnit.capSize[Axis.X]) / keyboardUnit.keyStep[Axis.X] * unit);
			final gapY = Std.int((keyboardUnit.keyStep[Axis.Y] - keyboardUnit.capSize[Axis.Y]) / keyboardUnit.keyStep[Axis.Y] * unit);
			// Parse all keycaps/elements
			for (key in keyboardUnit.keys) {
				final keycap: KeyRenderer = KeyMaker.createKey(keyboardUnit, key, unit, gapX, gapY, keyboardUnit.keysColor);
				keycap.pos(unit * key.position[Axis.X], unit * key.position[Axis.Y]);
				keycap.onPointerDown(keycap, (t: TouchInfo) -> {
					keyMouseDown(t, keycap);
				});
				workKeyboard.add(keycap);
			}
		}
		return workKeyboard;
	}
	// This gets called only if clicked on a key on the worksurface!
	function keyMouseDown(info: TouchInfo, keycap: KeyRenderer) {
		activeProject = this.keyson;
		touchType = "Element";
		// TODO: store current key position into ViewportStart
		keyPosStartX = keycap.x;
		keyPosStartY = keycap.y;
		selectedKey = keycap;
		selectedKey.select();

		// TODO infer the selection size and apply it to the placer:
		placer.size(selectedKey.width, selectedKey.height);

		// store current mouse position
		this.pointerStartX = screen.pointerX;
		this.pointerStartY = screen.pointerY;

		// placer is usually referenced to mouse cursor, but while we move that's off
		placerMismatchX = keyPosStartX - this.pointerStartX + screenX + this.x + selectedKey.width / 2;
		placerMismatchY = keyPosStartY - this.pointerStartY + screenY + this.y + selectedKey.height / 2;
		if (selectedKey.sourceKey.shape == "BAE" ) placerMismatchX -= 75;
		if (selectedKey.sourceKey.shape == "XT_2U" ) placerMismatchX -= 100;

		// Try move along as we pan the touch
		screen.onPointerMove(this, keyMouseMove);

		// Stop dragging when releasing pointer
		screen.oncePointerUp(this, keyMouseUp);
	}

	// MOVEMENT

	/**
	 * Called from any viewport and any click on the start of the drag
	 */
	function viewportMouseDown(info: TouchInfo) {
		// TODO: Check for maximum amount of movement before dragging
		this.viewportStartX = this.x;
		this.viewportStartY = this.y;

		// Store current mouse position
		this.pointerStartX = screen.pointerX;
		this.pointerStartY = screen.pointerY;
		trace('touched:<none> on [${this.keyson.name}]');

		placerMismatchX = 0;
		placerMismatchY = 0;

		// Try move along as we pan the touch
		screen.onPointerMove(this, viewportMouseMove);

		// Stop dragging when releasing pointer
		screen.oncePointerUp(this, viewportMouseUp);
	}

	/**
	 * Ran during and at the very end of the pan of the viewport
	 */
	function viewportMouseMove(info: TouchInfo) {
		this.pos(this.viewportStartX + screen.pointerX - this.pointerStartX, this.viewportStartY + screen.pointerY - this.pointerStartY);
		StatusBar.inform('Pan view:[${screen.pointerX - this.pointerStartX}x${screen.pointerY - this.pointerStartY}]');
	}

	/**
	 * Called after the pan of the viewport
	 */
	function viewportMouseUp(info: TouchInfo) {
		touchType = "";
		screen.offPointerMove(viewportMouseMove);
	}

	/**
	 * Called during key movement
	 */
	function keyMouseMove(info: TouchInfo) {
		selectedKey.pos(keyPosStartX + screen.pointerX - pointerStartX, keyPosStartY + screen.pointerY - pointerStartY);
		selectedKey.pos(selectedKey.x - selectedKey.x % placingStep, selectedKey.y - selectedKey.y % placingStep);
		//StatusBar.inform('Moved key to:[${selectedKey.x}x${selectedKey.y}]');
		StatusBar.inform('Move:[${placerMismatchX}x${placerMismatchY}]');
	}

	/**
	 * Called after the drag
	 */
	function keyMouseUp(info: TouchInfo) {
		placer.size(unit, unit); // restore placer to default
		placerMismatchX=0;
		placerMismatchY=0;
		selectedKey.select(); // remove selection by toggle
		queue.push(new actions.MoveKeys(this, [selectedKey], [selectedKey.x, selectedKey.y]));
		screen.offPointerMove(keyMouseMove);
	}
}
