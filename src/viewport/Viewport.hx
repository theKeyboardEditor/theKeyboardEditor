package viewport;

import ceramic.Visual;
import ceramic.Scene;
import ceramic.TouchInfo;
import keyson.Axis;
import keyson.Keyson;

class Viewport extends Scene {
	/**
	 * The keyson being renderered
	 */
	public var keyson: keyson.Keyson;
	public var screenX: Float = 0;
	public var screenY: Float = 0;
	//	public var mainScene: MainScene;
	public var guiScene: UI;
	public var barMode: String; // acces to active mode from gui.modeSelector.barMode
	public final queue = new ActionQueue();

	// TODO make cout, copy & paste actions for this

	/**
	 * This is where we map all of the different events to specific keys
	 * See Input.hx file for more details
	 */
	final inputMap = new Input();

	/**
	 * Ceramic elements
	 */
	public var workSurface: Visual;
	var placer: Placer;

	// Movement variables
	inline static final keyboardSpeed: Int = 35;

	var pointerStartX: Float = 0.0;
	var pointerStartY: Float = 0.0;

	/**
	 * For dragging keys around
	 */
	var keyPosStartX: Float = 0.0;
	var keyPosStartY: Float = 0.0;

	var placerMismatchX: Float = 0.0;
	var placerMismatchY: Float = 0.0;

	/**
	 * Stuff that upsets logo but fire-h0und refuses to remove
	 */
	public var workDevice: Int = 0; // this will be set externally
	var keyboardUnit: keyson.Keyboard;
	var selectedKey: KeyRenderer; // still needed across few functions -.-'
	var selectedKeys: Array<KeyRenderer> = []; // still needed across few functions -.-'
	var deselection: Bool = false; // is a deselect event resulting in a drag

	// Constants
	// Size of a key
	public var unit: Float = 100;
	// gap around the keycap in U/100
	public var gapX: Int;
	public var gapY: Int;

	// Viewport scale (default is 1.00 for 100%)
	public var viewScale: Float = 1.0;

	inline static final placingStep: Float = Std.int(100 / 4);

	// GLOBAL SCENE

	/**
	 * Dispatches keyboard and mouse inputs to the seperate functions
	 */
	public function inputCreate() {
		// Here we account only for events that happen over this Viewport
		this.onPointerDown(this, viewportMouseDown);
	}
	public function inputUpdate(delta: Float) {
		if (!active)
			return;

		if (inputMap.pressed(PAN_UP)) {
			workSurface.y += keyboardSpeed;
		}
		if (inputMap.pressed(PAN_DOWN)) {
			workSurface.y -= keyboardSpeed;
		}
		if (inputMap.pressed(PAN_LEFT)) {
			workSurface.x += keyboardSpeed;
		}
		if (inputMap.pressed(PAN_RIGHT)) {
			workSurface.x -= keyboardSpeed;
		}
		if (inputMap.pressed(DELETE_SELECTED)) {
			// TODO determine actually selected keyboard unit:
			if (selectedKeys.length > 0) {
				// ignore any faux allarms
				keyboardUnit = keyson.units[workDevice];
				// they remain selected after deletion and it's eery! D:
				clearSelection(false);
				queue.push(new actions.DeleteKeys(this, keyboardUnit, selectedKeys));
				// delayed selection clearing
				selectedKeys = [];
			}
			// we'll just pretend there are no rebounces on delete key ;)
			// (but there are 2-3!)
		}
	}

	/**
	 * Initializes the scene
	 */
	override public function create() {
		workSurface = parseInKeyboard(keyson);
		this.add(workSurface);

		var grid = new Grid();
		grid.primaryStep(unit * viewScale);
		grid.subStep(placingStep * viewScale);
		this.size(grid.width, grid.height);

		var gridFilter = new ceramic.Filter();
		gridFilter.explicitRender = true;
		gridFilter.autoRender = false;
		gridFilter.size(grid.width, grid.height);
		gridFilter.content.add(grid);
		workSurface.add(gridFilter);
		gridFilter.render();

		placer = new Placer();
		placer.piecesSize = unit * viewScale; // the pieces are not scaled
		placer.size(unit * viewScale, unit * viewScale);
		// anchor has to be aligned to the top left edge or placing is off!
		placer.anchor(0, 0);
		placer.depth = 10;
		this.add(placer);

		inputCreate();
	}

	/**
	 * Runs every frame
	 */
	override public function update(delta: Float) {
		// TODO: make this.pasue effective again
		placerUpdate();
		inputUpdate(delta);
		queue.act();
	}
	// PLACER

	/**
	 * Cogify the movement to step edges
	 */
	final inline function coggify(x: Float, cogs: Float): Float {
		return x - x % cogs;
	}

	/**
	 * Runs every frame, used to position the placer
	 */
	function placerUpdate() {
		switch (guiScene.modeSelector.barMode) {
			case "place":
				placerMismatchX = 0;
				placerMismatchY = 0;
				placer.visible = true;
				final shape = if (CopyBuffer.selectedKey != null) CopyBuffer.selectedKey else "1U";
				gapX = Std.int((keyson.units[0].keyStep[Axis.X]
					- keyson.units[0].capSize[Axis.X]) / keyson.units[0].keyStep[Axis.X] * unit * viewScale);
				gapY = Std.int((keyson.units[0].keyStep[Axis.Y]
					- keyson.units[0].capSize[Axis.Y]) / keyson.units[0].keyStep[Axis.Y] * unit * viewScale);
				switch shape {
					case "ISO":
						placer.size(1.50 * unit * viewScale - gapX, 2.00 * unit * viewScale - gapY);
					case "ISO Inverted":
						placer.size(1.50 * unit * viewScale - gapX, 2.00 * unit * viewScale - gapY);
					case "BAE":
						placerMismatchX = 0.75;
						placer.size(2.25 * unit * viewScale - gapX, 2.00 * unit * viewScale - gapY);
					case "BAE Inverted":
						placer.size(2.25 * unit * viewScale - gapX, 2.00 * unit * viewScale - gapY);
					case "XT_2U":
						placerMismatchX = 1;
						placer.size(2.00 * unit * viewScale - gapX, 2.00 * unit * viewScale - gapY);
					case "AEK":
						placerMismatchX = 0;
						placer.size(1.25 * unit * viewScale - gapX, 2.00 * unit * viewScale - gapY);
					default:
						if (Math.isNaN(Std.parseFloat(shape)) == false) { // aka it is a number
							if (shape.split(' ').indexOf("Vertical") != -1)
								placer.size(unit * viewScale - gapX, unit * viewScale * Std.parseFloat(shape) - gapY);
							else
								placer.size(unit * viewScale * Std.parseFloat(shape) - gapX, unit * viewScale - gapY);
						}
				}
				placerMismatchX = coggify(placer.width / unit / viewScale / 2, .25);
				placerMismatchY = coggify(placer.height / unit / viewScale / 2, .25);
				placer.x = coggify(screen.pointerX - screenX - placerMismatchX * unit * viewScale, placingStep);
				placer.y = coggify(screen.pointerY - screenY - placerMismatchY * unit * viewScale, placingStep);
				StatusBar.pos(placer.x / unit * viewScale, placer.y / unit * viewScale);
			default:
				placer.visible = false;
		}
	}

	/**
	 * Called only once to parse in the keyboard into the workSurface
	 */
	function parseInKeyboard(keyboard: Keyson): Visual {
		final workKeyboard = new Visual();
		for (keyboardUnit in keyboard.units) {
			gapX = Std.int((keyboardUnit.keyStep[Axis.X] - keyboardUnit.capSize[Axis.X]) / keyboardUnit.keyStep[Axis.X] * unit * viewScale);
			gapY = Std.int((keyboardUnit.keyStep[Axis.Y] - keyboardUnit.capSize[Axis.Y]) / keyboardUnit.keyStep[Axis.Y] * unit * viewScale);

			for (key in keyboardUnit.keys) {
				final keycap: KeyRenderer = KeyMaker.createKey(keyboardUnit, key, unit * viewScale, gapX, gapY, keyboardUnit.keysColor);
				keycap.pos(unit * viewScale * key.position[Axis.X], unit * viewScale * key.position[Axis.Y]);
				keycap.onPointerDown(keycap, (t: TouchInfo) -> {
					keyMouseDown(t, keycap);
				});
				workKeyboard.add(keycap);
			}
		}
		return workKeyboard;
	}
	// APPLYING DESIGN
	// SURFACE ACTIONS

	/**
	 * Called from any viewport and any click on the start of the drag
	 */
	function viewportMouseDown(info: TouchInfo) {
		// Store current mouse position
		this.pointerStartX = screen.pointerX;
		this.pointerStartY = screen.pointerY;

		// Stop dragging when pointer is released
		this.oncePointerUp(this, viewportMouseUp);
	}

	/**
	 * react only once the button press is over
	 */
	function viewportMouseUp(info: TouchInfo) {
		switch (guiScene.modeSelector.barMode) {
			case "place":
				// place action
				// TODO determine actually selected keyboard unit:
				keyboardUnit = keyson.units[workDevice];
				final shape = if (CopyBuffer.selectedKey != null) CopyBuffer.selectedKey else "1U";
				// TODO if there is a way to have a saner default legend?
				final legend = shape;
				// TODO calculate proper shaper size and offset:
				var y = placer.y / unit * viewScale;
				var x = placer.x / unit * viewScale;
				switch shape {
					case "BAE":
						x += 0.75;
					case "XT_2U":
						x += 1;
				}
				gapX = Std.int((keyboardUnit.keyStep[Axis.X] - keyboardUnit.capSize[Axis.X]) / keyboardUnit.keyStep[Axis.X] * unit * viewScale);
				gapY = Std.int((keyboardUnit.keyStep[Axis.Y] - keyboardUnit.capSize[Axis.Y]) / keyboardUnit.keyStep[Axis.Y] * unit * viewScale);
				// action to place the key
				queue.push(new actions.PlaceKey(this, keyboardUnit, shape, x, y));
			//				final key = keyboardUnit.createKey(shape, [x, y], legend);
			//				final keycap: KeyRenderer = KeyMaker.createKey(keyboardUnit, key, unit * viewScale, gapX, gapY, keyboardUnit.keysColor);
			//				keycap.pos(unit * key.position[Axis.X], unit * viewScale * key.position[Axis.Y]);
			//				keycap.onPointerDown(keycap, (t: TouchInfo) -> {
			//					keyMouseDown(t, keycap);
			//				});
			//				this.workSurface.add(keycap);
			case "edit":
				// click on empty should toggle select (thus deselect) everything
				// and dump the selection
				clearSelection(true);
			case _:
				// TODO either pan or start selection RoundedRectangle();
				StatusBar.error('Panning available only in edit mode.');
		}
	}
	// KEY ACTIONS

	/**
	 * This gets called only if clicked on a key on the worksurface!
	 */
	// because we create keys in actions we need this accesible (thus public) from there
	public function keyMouseDown(info: TouchInfo, keycap: KeyRenderer) {
		keyPosStartX = keycap.x;
		keyPosStartY = keycap.y;
		this.selectedKey = keycap;

		// store current mouse position
		this.pointerStartX = screen.pointerX;
		this.pointerStartY = screen.pointerY;
		switch (guiScene.modeSelector.barMode) {
			case "edit":
				// move and select keys
				if (selectedKey.border.visible) {
					// is selected: (by using select we take care of pivot too!)
					selectedKey.deselect();
					selectedKeys.remove(selectedKey);
					// we just had a deselect, allowing drag leads to problems.
					deselection = true;
				} else {
					// wasn't selected:
					selectedKey.select();
					// by using .unshift() instead of .push() the last added member is on index 0
					selectedKeys.unshift(selectedKey);
					deselection = false;
				}

				// TODO infer the selection size and apply it to the placer:
				if (selectedKeys.length > 0) {
					placer.visible = false;
				} else {
					placer.visible = true;
				}
			case _:
				// just ignore undefined actions for now
		}

		// Try move along as we pan the touch
		screen.onPointerMove(this, keyMouseMove);

		// Finish the drag along when the pointer is released
		screen.oncePointerUp(this, keyMouseUp);
	}

	/**
	 * Called during key movement
	 */
	function keyMouseMove(info: TouchInfo) {
		switch (guiScene.modeSelector.barMode) {
			case "place":
			case _:
				// there is a special case where the last selected element gets deselected and dragged
				if (selectedKeys.length > 0 && !deselection && selectedKeys.length > 0) {
					final xStep = coggify(keyPosStartX + screen.pointerX - pointerStartX, placingStep) - selectedKeys[0].x;
					final yStep = coggify(keyPosStartY + screen.pointerY - pointerStartY, placingStep) - selectedKeys[0].y;
					for (key in selectedKeys) {
						key.x += xStep;
						key.y += yStep;
					}
				}
		}
	}

	/**
	 * Called after the drag (touch/press is released)
	 */
	function keyMouseUp(info: TouchInfo) {
		switch (guiScene.modeSelector.barMode) {
			case "place":
				placer.visible = true;
			case "edit":
				// Restore placer to default size
				placer.size(unit * viewScale, unit * viewScale);
				placerMismatchX = 0;
				placerMismatchY = 0;

				// Actually execute the move of the selection
				if (selectedKeys.length > 0) {
					/**
					 * If the previous first member gets deselected the array will change pos()
					 * TODO: how can we know which remaining key will not move the array's position?
					 */
					final x = (selectedKeys[0].x - keyPosStartX) / unit * viewScale;
					final y = (selectedKeys[0].y - keyPosStartY) / unit * viewScale;
					// only if at least x or y is non zero
					// that didn't result in deselection
					// and we have actual keys to move at all
					if (x != 0 || y != 0 && !deselection && selectedKeys.length > 0) {
						queue.push(new actions.MoveKeys(this, selectedKeys, x, y));
						if (selectedKeys.length == 1) {
							// deselect if single element was just dragged
							selectedKey.select();
							selectedKeys.remove(selectedKey);
						}
					}
				}
			default:
				// undefined gets ignored
		}

		// The touch is already over, now cleanup and retur from there
		screen.offPointerMove(keyMouseMove);
	}

	public function clearSelection(deep: Bool) {
		for (i in 0...selectedKeys.length)
			selectedKeys[i].deselect();
		if (deep)
			selectedKeys = [];
	}
}
