package viewport;

import ceramic.Visual;
import ceramic.Scene;
import ceramic.TouchInfo;
import ceramic.DoubleClick;
import keyson.Axis;
import keyson.Keyson;

class Viewport extends Scene {
	/**
	 * The keyson being renderered
	 */
	public var keyson: keyson.Keyson;
	public var screenX: Float = 0; // position on screen
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
	var placer: Placer;
	var selectionBox: SelectionBox;

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
	public var currentUnit: Int = 0;
	public var keyboardUnit: keyson.Keyboard;

	var selectedKeycaps: Array<KeyRenderer> = [];
	var deselection: Bool = false; // is a deselect event resulting in a drag

	// Constants
	// Size of a key
	public var unit: Float = 100;
	// gap around the keycap in U/100
	public var gapX: Int;
	public var gapY: Int;

	// Viewport scale (default is 1.00 for 100%)
	public var viewScale: Float = 1.0; // tracking of the view scale

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
	final inline function coggify(x: Float, cogs: Float): Float {
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
				final keycap: KeyRenderer = KeyMaker.createKey(keyboardUnit, key, unit * viewScale, gapX, gapY,
					Std.parseInt(keyboardUnit.defaults.keyColor));
				keycap.pos(unit * key.position[Axis.X], unit * key.position[Axis.Y]);
				keycap.onPointerDown(keycap, (t: TouchInfo) -> {
					keyMouseDown(t, keycap);
				});
				// I have no idea what i'm doing here >:^]
				final doubleClick = new DoubleClick();
				doubleClick.onDoubleClick(keycap, handleDoubleClick);
				keycap.component('doubleClick', doubleClick);
				workingSet.add(keycap);
			}
		}
		return workingSet;
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
		if (info.buttonId == 1)
			return; // return on MMB (we ignore wheel press too)
		if (info.buttonId == 2) { // RMB
			// TODO call & process a "right click" menu otherwise ignore it here
			return;
		}

		// since we have pressed empty space we start drawing a selection rectangle:
		placer.x = coggify((screen.pointerX - screenX - this.x - placerMismatchX * unit) / viewScale, placingStep);
		placer.y = coggify((screen.pointerY - screenY - this.y - placerMismatchY * unit) / viewScale, placingStep);

		// draw a rectangle:
		this.selectionBox.visible = true;
		this.selectionBox.pos(screen.pointerX - screenX - this.x, screen.pointerY - screenY - this.y);

		// Try move along as we pan the touch
		screen.onPointerMove(this, viewportMouseMove);

		// Stop dragging when pointer is released
		this.oncePointerUp(this, viewportMouseUp);
	}
	/*
	 * update for the duration of the drag
	 */
	function viewportMouseMove(info: TouchInfo) {
		// update the drag rectangle
		this.selectionBox.pos(this.pointerStartX - screenX - this.x, this.pointerStartY - screenY - this.y);
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
		if (this.selectionBox.visible == true) {
			clearSelection(true);
			final boxX = this.selectionBox.x;
			final boxY = this.selectionBox.y;
			final boxWidth = this.selectionBox.width;
			final boxHeight = this.selectionBox.height;

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
							deselection = false;
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
		this.selectionBox.visible = false;
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
				// just any click on empty should clear selection of everything
				// and dump the selection ((true) means deep clear)
				clearSelection(true);
				this.selectionBox.visible = false;

				final boxX = this.selectionBox.x;
				final boxY = this.selectionBox.y;
				final boxWidth = this.selectionBox.width;
				final boxHeight = this.selectionBox.height;

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
								deselection = false;
							}
						}
					}
				}
			default:
		}
	}
	// KEY ACTIONS

	public function handleDoubleClick(): Void {
		trace('Doubleclick!');
	}

	/**
	 * This gets called only if clicked on a key on the worksurface!
	 * because we create keys in actions we need this accesible (thus public) from there
	 */
	public function keyMouseDown(info: TouchInfo, keycap: KeyRenderer) {
		keyPosStartX = keycap.x;
		keyPosStartY = keycap.y;

		this.pointerStartX = screen.pointerX;
		this.pointerStartY = screen.pointerY;

		switch (ui.Index.activeMode) {
			case Edit | Unit | Color | Present:
				// show placer only if -1 (non existent?)
				// placer.visible = selectedKeycaps.length < 0;
				placer.visible = false;
				// move and select keys
				// TODO stop toggling selection and move to shit add/ctrl remove from selection
				if (keycap.border.visible) {
					keycap.deselect();
					selectedKeycaps.remove(keycap);
					deselection = true;
				} else {
					keycap.select();
					// push to the opposite end than .push();
					selectedKeycaps.unshift(keycap);
					deselection = false;
				}
			default:
		}

		// Try move along as we pan the touch
		screen.onPointerMove(this, keyMouseMove);

		// Finish the drag along when the pointer is released
		screen.oncePointerUp(this, keyMouseUp);
	}

	/**
	 * Called during key movement (mouse key down)
	 */
	function keyMouseMove(info: TouchInfo) {
		switch (ui.Index.activeMode) {
			case Place:
			default:
				// there is a special case where the last selected element gets deselected and then dragged
				if (selectedKeycaps.length > 0 && !deselection) {
					final xStep = coggify(keyPosStartX + (screen.pointerX - pointerStartX) / viewScale, placingStep) - selectedKeycaps[0].x;
					final yStep = coggify(keyPosStartY + (screen.pointerY - pointerStartY) / viewScale, placingStep) - selectedKeycaps[0].y;
					for (key in selectedKeycaps) {
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
		switch (ui.Index.activeMode) {
			case Place:
				placer.visible = true;
			case Edit | Unit | Color | Present:
				// If no Placing then restore placer to default size
				placer.size(unit * viewScale, unit * viewScale);
				placerMismatchX = 0;
				placerMismatchY = 0;

				// Actually begin to execute the move of the selection
				if (selectedKeycaps.length > 0) {
					var x = (selectedKeycaps[0].x - keyPosStartX) / unit * viewScale;
					var y = (selectedKeycaps[0].y - keyPosStartY) / unit * viewScale;
					// only try to move if  x and y is not zero and there was no deselection and we have any selected keys to move at all
					if (x != 0 || y != 0 && !deselection && selectedKeycaps.length > 0) {
						queue.push(new actions.MoveKeys(this, selectedKeycaps, x, y));
						// deselect only if single element was just dragged
						if (selectedKeycaps.length == 1) {
							selectedKeycaps[0].deselect();
							selectedKeycaps.remove(selectedKeycaps[0]);
						}
					}
				}
			default:
				placer.size(unit * viewScale, unit * viewScale);
				placerMismatchX = 0;
				placerMismatchY = 0;
				placer.visible = false;
		}

		// The touch is already over, now cleanup and return from there
		screen.offPointerMove(keyMouseMove);
	}
	public function clearSelection(deep: Bool) {
		// deep clear clears the selectedKeycaps too
		// sometimes this is undesirable hence the switch
		for (i in 0...selectedKeycaps.length)
			selectedKeycaps[i].deselect();
		if (deep)
			selectedKeycaps = [];
	}

	// select all
	public function selectEverything() {
		selectedKeycaps = [];
		final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(keycapSet, 'children');
		for (keycap in keysOnUnit) {
			selectedKeycaps.unshift(keycap);
			keycap.select();
		}
		// the result is stored in selectedKeycaps
	}

	public function refreshKeycapSet() {
		clearSelection(true);
		// refresh from keyson
		this.remove(keycapSet);
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
			var y = placer.y / unit * viewScale;
			var x = placer.x / unit * viewScale;
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
	function selectedBodies(set: Array<keyson.Key>) {
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
	function keyBody(k: keyson.Key): ceramic.Rect {
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
