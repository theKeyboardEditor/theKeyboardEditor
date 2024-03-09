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

	public final queue = new ActionQueue();

	/**
	 * This is where we map all of the different events to specific keys
	 * See Input.hx file for more details
	 */
	final inputMap = new Input();

	/**
	 * Ceramic elements
	 */
	public var keycapSet: Visual;
	public var placer: Placer;
	public var selectionBox: SelectionBox;

	// Movement variables
	inline static final keyboardSpeed: Int = 35;

	public var pointerStartX: Float = 0.0;
	public var pointerStartY: Float = 0.0;

	public var placerMismatchX: Float = 0.0;
	public var placerMismatchY: Float = 0.0;

	/**
	 * Stuff that upsets logo but fire-h0und refuses to remove
	 */
	public var currentUnit: Int = 0;
	public var keyboardUnit: keyson.Keyboard;

	public var selectedKeycaps: Array<KeyRenderer> = [];
	public var threshold: Float = 4;

	var clickIsDrag = false;

	var worksurfaceDrag: Bool = false;
	var worksurfaceLMB: Bool = false;

	// Constants
	// Size of a key
	public var unit: Float = 100;
	// gap around the keycap in U/100
	public var gapX: Int;
	public var gapY: Int;

	// Viewport scale (default is 1.00 for 100%)
	public var viewScale: Float = 1.0; // tracking of the view scale

	public inline static final placingStep: Float = Std.int(100 / 4);

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
			this.y += keyboardSpeed;
		}
		if (inputMap.pressed(PAN_DOWN)) {
			this.y -= keyboardSpeed;
		}
		if (inputMap.pressed(PAN_LEFT)) {
			this.x += keyboardSpeed;
		}
		if (inputMap.pressed(PAN_RIGHT)) {
			this.x -= keyboardSpeed;
		}
		if (inputMap.pressed(ZOOM_IN)) {
			this.scaleX = Math.min(2.0, this.scaleX + keyboardSpeed / 1000);
			this.scaleY = this.scaleX;
			viewScale = this.scaleX;
		}
		if (inputMap.pressed(ZOOM_OUT)) {
			this.scaleX = Math.max(0.25, this.scaleX - keyboardSpeed / 1000);
			this.scaleY = this.scaleX;
			viewScale = this.scaleX;
		}
		if (inputMap.pressed(DELETE_SELECTED)) {
			// TODO determine actually selected keyboard unit:
			if (selectedKeycaps.length > 0) {
				// ignore any faux allarms
				keyboardUnit = keyson.units[currentUnit];
				// they remain selected after deletion and it's eery! D:
				clearSelection(false);
				queue.push(new actions.DeleteKeys(this, keyboardUnit, selectedKeycaps));
				// delayed selection clearing
				selectedKeycaps = [];
			}
			// we'll just pretend there are no rebounces on delete key ;)
			// (but there are 2-3!)
		}
		if (inputMap.pressed(HOME)) {
			reset();
		}
	}

	/**
	 * Initializes the scene
	 */
	override public function create() {
		keycapSet = parseInKeyboard(keyson);
		this.add(keycapSet);

		var grid = new Grid();
		grid.primaryStep(unit * viewScale);
		grid.subStep(placingStep * viewScale);
		this.size(grid.width, grid.height);

		var gridFilter = new ceramic.Filter();
		gridFilter.explicitRender = true;
		gridFilter.autoRender = false;
		gridFilter.size(grid.width, grid.height);
		gridFilter.content.add(grid);
		this.add(gridFilter);
		gridFilter.render();

		placer = new Placer();
		placer.piecesSize = unit * viewScale; // the pieces are not scaled
		placer.size(unit * viewScale, unit * viewScale);
		// anchor has to be aligned to the top left edge or placing is off!
		placer.anchor(0, 0);
		placer.depth = 10;
		this.add(placer);

		selectionBox = new SelectionBox();
		this.selectionBox.depth = 600;
		this.selectionBox.visible = false;
		this.add(selectionBox);

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
	public static inline function coggify(x: Float, cogs: Float): Float {
		return x - x % cogs;
	}

	/**
	 * Runs every frame, used to position the placer
	 */
	function placerUpdate() {
		switch (ui.Index.activeMode) {
			case Place:
				this.selectionBox.visible = false;
				// placerMismatchX = 0;
				// placerMismatchY = 0;
				placer.visible = true;
				final shape = if (CopyBuffer.designatedKey != null) CopyBuffer.designatedKey else "1U";
				gapX = Std.int((keyson.units[0].keyStep[Axis.X]
					- keyson.units[0].capSize[Axis.X]) / keyson.units[0].keyStep[Axis.X] * unit * viewScale);
				gapY = Std.int((keyson.units[0].keyStep[Axis.Y]
					- keyson.units[0].capSize[Axis.Y]) / keyson.units[0].keyStep[Axis.Y] * unit * viewScale);
				switch shape {
					case "ISO":
						placer.size(1.50 * unit - gapX, 2.00 * unit - gapY);
					case "ISO Inverted":
						placer.size(1.50 * unit - gapX, 2.00 * unit - gapY);
					case "BAE":
						placerMismatchX = 0.75;
						placer.size(2.25 * unit - gapX, 2.00 * unit - gapY);
					case "BAE Inverted":
						placer.size(2.25 * unit - gapX, 2.00 * unit - gapY);
					case "XT_2U":
						placerMismatchX = 1;
						placer.size(2.00 * unit - gapX, 2.00 * unit - gapY);
					case "AEK":
						placerMismatchX = 0;
						placer.size(1.25 * unit - gapX, 2.00 * unit - gapY);
					default:
						if (Math.isNaN(Std.parseFloat(shape)) == false) { // aka it is a number
							if (shape.split(' ').indexOf("Vertical") != -1)
								placer.size(unit - gapX, unit * Std.parseFloat(shape) - gapY);
							else
								placer.size(unit * Std.parseFloat(shape) - gapX, unit - gapY);
						}
				}
				placerMismatchX = coggify(placer.width / unit / 2 * viewScale, .25);
				placerMismatchY = coggify(placer.height / unit / 2 * viewScale, .25);
				placer.x = coggify((screen.pointerX - screenX - this.x - placerMismatchX * unit) / viewScale, placingStep);
				placer.y = coggify((screen.pointerY - screenY - this.y - placerMismatchY * unit) / viewScale, placingStep);
				StatusBar.pos(placer.x / unit * viewScale, placer.y / unit * viewScale);
			default:
				placer.visible = false;
		}
		StatusBar.pos(placer.x, placer.y);
	}

	/**
	 * Called only once to parse in the keyboard into the keycapSet
	 */
	function parseInKeyboard(keyboard: Keyson): Visual {
		final workingSet = new Visual();
		for (keyboardUnit in keyboard.units) {
			gapX = Std.int((keyboardUnit.keyStep[Axis.X] - keyboardUnit.capSize[Axis.X]) / keyboardUnit.keyStep[Axis.X] * unit);
			gapY = Std.int((keyboardUnit.keyStep[Axis.Y] - keyboardUnit.capSize[Axis.Y]) / keyboardUnit.keyStep[Axis.Y] * unit);

			for (key in keyboardUnit.keys) {
				final keycap: KeyRenderer = KeyMaker.createKey(keyboardUnit, key, unit, gapX, gapY,
					Std.parseInt(keyboardUnit.defaults.keyColor));
				keycap.pos(unit * key.position[Axis.X], unit * key.position[Axis.Y]);
				// adding all actions to the keycap entity
				keycap.component('logic', new KeyLogic(this));
				workingSet.add(keycap);
			}
		}
		return workingSet;
	}
	// APPLYING DESIGN:
	// SURFACE ACTIONS

	/**
	 * Called from any click or the start of the drag
	 */
	function viewportMouseDown(info: TouchInfo) {
		// Update stored current mouse position
		this.pointerStartX = screen.pointerX;
		this.pointerStartY = screen.pointerY;
		// reset on every click start
		worksurfaceDrag = false;
		if (info.buttonId == 1)
			return; // return on MMB (we ignore wheel press too)
		if (info.buttonId == 2) { // RMB
			// TODO call & process a "right click" menu otherwise ignore it here
			return;
		}
		if (info.buttonId == 0) {
			// true only for the while LMB is pressed
			worksurfaceLMB = true;
		}
		// since we have pressed over the empty space we start drawing a selection rectangle:
		placer.x = coggify((screen.pointerX - screenX - this.x - placerMismatchX * unit) / viewScale, placingStep);
		placer.y = coggify((screen.pointerY - screenY - this.y - placerMismatchY * unit) / viewScale, placingStep);

		// Try move along as we pan the touch
		screen.onPointerMove(this, viewportMouseMove);

		// Stop dragging when pointer is released
		this.oncePointerUp(this, viewportMouseUp);
	}
	/*
	 * update for the duration of the drag
	 */
	function viewportMouseMove(info: TouchInfo) {
		// TODO make drag true only certain threshold is reached (2-4 pixels)
		if (threshold != -1
			&& (Math.abs(screen.pointerX - pointerStartX) > threshold || Math.abs(screen.pointerY - pointerStartY) > threshold))
			worksurfaceDrag = worksurfaceLMB;
		// we start showing on drag
		this.selectionBox.visible = worksurfaceDrag;
		// update the drag rectangle
		this.selectionBox.pos((this.pointerStartX - screenX - this.x) / viewScale, (this.pointerStartY - screenY - this.y) / viewScale);
		// for the rounded rectangles to render right we can't have negative size - so we change from where we draw it here
		if (screen.pointerX - this.pointerStartX > 0) {
			this.selectionBox.x = (this.pointerStartX - screenX - this.x) / viewScale;
			this.selectionBox.width = (screen.pointerX - this.pointerStartX) / viewScale;
		} else {
			this.selectionBox.x = (screen.pointerX - screenX - this.x) / viewScale;
			this.selectionBox.width = (this.pointerStartX - screen.pointerX) / viewScale;
		}
		if (screen.pointerY - this.pointerStartY > 0) {
			this.selectionBox.y = (this.pointerStartY - screenY - this.y) / viewScale;
			this.selectionBox.height = (screen.pointerY - this.pointerStartY) / viewScale;
		} else {
			this.selectionBox.y = (screen.pointerY - screenY - this.y) / viewScale;
			this.selectionBox.height = (this.pointerStartY - screen.pointerY) / viewScale;
		}

		// only during a selection drag: update selected keys (replace selection)
		if (this.selectionBox.visible == true && worksurfaceDrag && ui.Index.activeMode != Place && ui.Index.activeMode != Present) {
			if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
				clearSelection(true);
			}
			final boxX = this.selectionBox.x;
			final boxY = this.selectionBox.y;
			final boxWidth = this.selectionBox.width;
			final boxHeight = this.selectionBox.height;

			// TODO implement CTRL deselection processing
			for (k in keyson.units[currentUnit].keys) {
				// calculate position and size of a body:
				final body = keyBody(k);
				final keyX = body.x;
				final keyY = body.y;
				final keyWidth = body.width;
				final keyHeight = body.height;
				if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
					final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(keycapSet, 'children');
					for (key in keysOnUnit) {
						if (key.sourceKey == k) {
							key.select();
							selectedKeycaps.unshift(key);
						}
					}
				}
			}
		}
	}

	/**
	 * react only once the button press is over
	 */
	function viewportMouseUp(info: TouchInfo) {
		// the drag is now finished:
		worksurfaceDrag = false;
		// hide the selection box (always share the fate of a drag event)
		this.selectionBox.visible = worksurfaceDrag;
		switch (ui.Index.activeMode) {
			case Place:
				// place action
				// TODO determine actually selected keyboard unit:
				keyboardUnit = keyson.units[currentUnit];
				final shape = if (CopyBuffer.designatedKey != null) CopyBuffer.designatedKey else "1U";
				// TODO calculate proper shaper size and offset:
				var y = placer.y / unit;
				var x = placer.x / unit;
				gapX = Std.int((keyboardUnit.keyStep[Axis.X] - keyboardUnit.capSize[Axis.X]) / keyboardUnit.keyStep[Axis.X] * unit * viewScale);
				gapY = Std.int((keyboardUnit.keyStep[Axis.Y] - keyboardUnit.capSize[Axis.Y]) / keyboardUnit.keyStep[Axis.Y] * unit * viewScale);
				// action to place the key
				queue.push(new actions.PlaceKey(this, keyboardUnit, shape, x, y));
			case Edit | Unit | Color | Present:
				if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
					clearSelection(true);
				}
				// this.selectionBox.visible = false;
				final boxX = this.selectionBox.x;
				final boxY = this.selectionBox.y;
				final boxWidth = this.selectionBox.width;
				final boxHeight = this.selectionBox.height;

				// TODO implement CTRL deselection processing here
				for (k in keyson.units[currentUnit].keys) {
					// calculate position and size of a body:
					final body = keyBody(k);
					final keyX = body.x;
					final keyY = body.y;
					final keyWidth = body.width;
					final keyHeight = body.height;

					if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
						final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(keycapSet, 'children');
						for (key in keysOnUnit) {
							if (key.sourceKey == k) {
								key.select();
								selectedKeycaps.unshift(key);
							}
						}
					}
				}
			default:
		}
		// finish the press
		worksurfaceLMB = false;
	}
	public function clearSelection(deep: Bool) {
		// deep clear clears the selectedKeycaps too
		// sometimes this is undesirable hence the switch
		for (i in 0...selectedKeycaps.length)
			selectedKeycaps[i].deselect();
		if (deep)
			selectedKeycaps = [];
	}

	// Select all
	public function selectEverything() {
		selectedKeycaps = [];
		final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(keycapSet, 'children');
		for (keycap in keysOnUnit) {
			selectedKeycaps.unshift(keycap);
			keycap.select();
		}
		// the result is stored in selectedKeycaps
	}

	// Reset scale and viewport position
	public function reset() {
		this.x = 0;
		this.y = 0;
		this.scaleX = 1;
		this.scaleY = this.scaleX;
		viewScale = this.scaleX;
	}

	public function refreshKeycapSet() {
		clearSelection(true);
		// refresh from keyson
		this.keycapSet.clear();
		keycapSet = parseInKeyboard(keyson);
		this.add(keycapSet);
	}

	public function copy() {
		if (selectedKeycaps.length > 0) {
			CopyBuffer.selectedObjects = new Keyboard();
			// TODO initialize said keyboard with current unit's data
			// copy into a clean buffer
			keyboardUnit = keyson.units[currentUnit];
			queue.push(new actions.EditCopy(this, keyboardUnit, selectedKeycaps));
		}
		StatusBar.inform('Copy action.');
	}

	public function cut() {
		if (selectedKeycaps.length > 0) {
			CopyBuffer.selectedObjects = new Keyboard();
			keyboardUnit = keyson.units[currentUnit];
			clearSelection(false);
			queue.push(new actions.EditCut(this, keyboardUnit, selectedKeycaps));
			selectedKeycaps = [];
		}
		StatusBar.inform('Cut action.');
	}

	public function paste() {
		if (CopyBuffer.selectedObjects.keys.length > 0) {
			// TODO make a offset from the stored data somehow
			var y = placer.y / unit;
			var x = placer.x / unit;
			keyboardUnit = keyson.units[currentUnit];
			queue.push(new actions.EditPaste(this, keyboardUnit, x, y));
		}
		StatusBar.inform('Paste action.');
	}

	// TODO make actions for the actions undo queue
	public function colorSelectedKeys(color: ceramic.Color) {
		if (selectedKeycaps.length > 0) {
			queue.push(new actions.ColorBody(this, selectedKeycaps, color));
		}
		StatusBar.inform('Colored ${selectedKeycaps.length} keycaps into [${color}].');
	}

	public function colorSelectedKeyLegends(color: ceramic.Color) {
		if (selectedKeycaps.length > 0) {
			queue.push(new actions.ColorLegends(this, selectedKeycaps, color));
		}
		StatusBar.inform('Colored ${selectedKeycaps.length} keycaps into [${color}].');
	}

	// TODO color single appointed legend on a single key

	/**
	 * Return the size of selected units in U/100 (for zooming)
	 */
	public function selectedBodies(set: Array<keyson.Key>) {
		var extremeX: Float = 0;
		var extremeY: Float = 0;
		var extremeW: Float = 0;
		var extremeH: Float = 0;

		for (member in set) {
			final body = keyBody(member);
			// extreme left most coodrinate:
			extremeX = Math.min(extremeX, body.x);
			// extreme top most
			extremeY = Math.min(extremeY, body.y);
			// extremem right most
			extremeW = Math.max(extremeW, body.x + body.width);
			// extreme bottom most
			extremeH = Math.max(extremeH, body.y + body.height);
		}
		return new ceramic.Rect(extremeX, extremeY, extremeX - extremeW, extremeY - extremeH);
	}

	/**
	 * Return a key's position and size in units of U/100
	 */
	public function keyBody(k: keyson.Key): ceramic.Rect {
		var x: Float = k.position[Axis.X] * this.unit;
		var y: Float = k.position[Axis.Y] * this.unit;
		var width: Float = 1.0 * this.unit;
		var height: Float = 1.0 * this.unit;

		x -= switch k.shape {
			case "BAE":
				0.75 * this.unit;
			case "XT_2U":
				1 * this.unit;
			default:
				0;
		}

		switch k.shape {
			case "ISO":
				width = 1.50 * this.unit * viewScale - gapX;
				height = 2.00 * this.unit * viewScale - gapY;
			case "ISO Inverted":
				width = 1.50 * this.unit * viewScale - gapX;
				height = 2.00 * this.unit * viewScale - gapY;
			case "BAE":
				// special J shaped key offset
				x -= 0.75 * this.unit;
				width = 2.25 * this.unit * viewScale - gapX;
				height = 2.00 * this.unit * viewScale - gapY;
			case "BAE Inverted":
				width = 2.25 * this.unit * viewScale - gapX;
				height = 2.00 * this.unit * viewScale - gapY;
			case "XT_2U":
				width = 2.00 * this.unit * viewScale - gapX;
				height = 2.00 * this.unit * viewScale - gapY;
				// special J shaped key offset
				x -= 1 * this.unit;
			case "AEK":
				width = 1.25 * this.unit * viewScale - gapX;
				height = 2.00 * this.unit * viewScale - gapY;
			default:
				if (Math.isNaN(Std.parseFloat(k.shape)) == false) {
					if (k.shape.split(' ').indexOf("Vertical") != -1) {
						width = this.unit - gapX;
						height = this.unit * Std.parseFloat(k.shape) - gapY;
					} else {
						width = this.unit * Std.parseFloat(k.shape) - gapX;
						height = this.unit - gapY;
					}
				}
		}
		return new ceramic.Rect(x, y, width, height);
	}
}
