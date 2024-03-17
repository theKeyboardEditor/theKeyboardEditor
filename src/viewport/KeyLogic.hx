package viewport;

import ceramic.Entity;
import ceramic.Component;
import ceramic.TouchInfo;

class KeyLogic extends Entity implements Component {
	@entity var keycap: KeyRenderer;

	public var viewport: viewport.Viewport;
	// drag threshold in pixels
	public var threshold: Float = 2;

	var keycapIsDragged = false;
	// keycap position before the drag
	var keycapPosStartX: Float = 0.0;
	var keycapPosStartY: Float = 0.0;

	public function new(viewport: viewport.Viewport) {
		super();
		this.viewport = viewport;
	}

	function bindAsComponent() {
		final doubleClick = new ceramic.DoubleClick();

		doubleClick.onDoubleClick(keycap, handleDoubleClick);

		keycap.onPointerDown(keycap, keyMouseDown);
	}

	/**
	 * This gets called only if clicked over a key on the worksurface!
	 * because we create keys in actions we need this accesible (thus public) from there
	 */
	public function keyMouseDown(info: TouchInfo) {
		// Reset on each begin
		keycapIsDragged = false;
		viewport.placer.visible = (ui.Index.activeMode == Place);

		// Set where the keycap is before the drag
		keycapPosStartX = keycap.x;
		keycapPosStartY = keycap.y;

		// Set where the pointer is
		viewport.pointerStartX = screen.pointerX;
		viewport.pointerStartY = screen.pointerY;

		// Move along as we pan the touch
		screen.onPointerMove(this, keyMouseMove);

		// Finish the drag when the pointer is released
		screen.oncePointerUp(this, (info) -> {
			keyMouseUp(info, keycap);
		});
	}

	/**
	 * Called during key movement (mouse key down)
	 */
	function keyMouseMove(info: TouchInfo) {
		if (viewport.threshold != -1
			&& (Math.abs(screen.pointerX - viewport.pointerStartX) > viewport.threshold
				|| Math.abs(screen.pointerY - viewport.pointerStartY) > viewport.threshold))
			keycapIsDragged = true;
		switch (ui.Index.activeMode) {
			case Edit | Unit | Color | Legend:
				// react only on drag event
				if (keycapIsDragged) {
					// clicked on a selected keycap?
					if (viewport.selectedKeycaps.contains(keycap)) {
						// only ever try drag if any selection exists
						if (viewport.selectedKeycaps.length > 0) {
							// note we reference the Array member [0] for move vector!
							final xStep = Viewport.coggify(keycapPosStartX + (screen.pointerX - viewport.pointerStartX) / viewport.viewScale,
								Viewport.placingStep)
								- viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].x;
							final yStep = Viewport.coggify(keycapPosStartY + (screen.pointerY - viewport.pointerStartY) / viewport.viewScale,
								Viewport.placingStep)
								- viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].y;
							for (key in viewport.selectedKeycaps) {
								key.x += xStep;
								key.y += yStep;
							}
						}
					} else {
						viewport.selectionBox.visible = keycapIsDragged;
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							viewport.clearSelection(true);
						}
						final boxX = viewport.selectionBox.x;
						final boxY = viewport.selectionBox.y;
						final boxWidth = viewport.selectionBox.width;
						final boxHeight = viewport.selectionBox.height;

						// TODO implement CTRL deselection processing
						for (k in viewport.keyson.units[viewport.currentUnit].keys) {
							// calculate position and size of a body:
							final body = viewport.keyBody(k);
							final keyX = body.x;
							final keyY = body.y;
							final keyWidth = body.width;
							final keyHeight = body.height;
							if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
								final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(viewport.keycapSet, 'children');
								for (key in keysOnUnit) {
									if (key.sourceKey == k) {
										key.select();
										viewport.selectedKeycaps.unshift(key);
									}
								}
							}
						}
					}
				}
			default:
		}
	}

	/**
	 * Called after the drag (touch/press is released)
	 */
	function keyMouseUp(info: TouchInfo, keycap: KeyRenderer) {
		switch (ui.Index.activeMode) {
			case Place:
				viewport.placer.visible = true;
			case Edit | Unit | Color | Legend:
				viewport.selectionBox.visible = false;
				viewport.placer.size(viewport.unit * viewport.viewScale, viewport.unit * viewport.viewScale);
				viewport.placerMismatchX = 0;
				viewport.placerMismatchY = 0;
				// SELECTING
				//  - by click only when not dragging
				if (!keycapIsDragged) {
					if (app.input.keyPressed(LCTRL) || app.input.keyPressed(RCTRL)) {
						// ctrl for deselect
						viewport.selectedKeycaps.remove(keycap);
						keycap.deselect();
					} else {
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							// CLEAR if no SHIFT key is pressed
							viewport.clearSelection(true);
						}
						// put last selected keycap to position [0] in keycaps
						viewport.selectedKeycaps.unshift(keycap);
						keycap.select();
					}
				} else {
					// DRAGGING
					//  the selected (if any) keys and the dragg event happened on a selected key
					if (viewport.selectedKeycaps.length > 0 && viewport.selectedKeycaps.contains(keycap)) {
						var x = (viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].x
							- keycapPosStartX) / viewport.unit * viewport.viewScale;
						var y = (viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].y
							- keycapPosStartY) / viewport.unit * viewport.viewScale;
						// only try to move if  x and y is not zero and we have any selected keys to move at all
						// if (x != 0 || y != 0 && viewport.selectedKeycaps.length > 0) {
						if (viewport.selectedKeycaps.length > 0) {
							viewport.queue.push(new actions.MoveKeys(viewport, viewport.selectedKeycaps, x / viewport.viewScale,
								y / viewport.viewScale));
						}
					} else {
						// DRAGGING outside a selected keycap results in a rectangle selection
						viewport.selectionBox.visible = false;
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							viewport.clearSelection(true);
						}
						final boxX = viewport.selectionBox.x;
						final boxY = viewport.selectionBox.y;
						final boxWidth = viewport.selectionBox.width;
						final boxHeight = viewport.selectionBox.height;

						// TODO implement CTRL deselection processing
						for (k in viewport.keyson.units[viewport.currentUnit].keys) {
							// calculate position and size of a body:
							final body = viewport.keyBody(k);
							final keyX = body.x;
							final keyY = body.y;
							final keyWidth = body.width;
							final keyHeight = body.height;
							if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
								final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(viewport.keycapSet, 'children');
								for (key in keysOnUnit) {
									if (key.sourceKey == k) {
										key.select();
										viewport.selectedKeycaps.unshift(key);
									}
								}
							}
						}
					}
				}
			default:
				viewport.placer.size(viewport.unit * viewport.viewScale, viewport.unit * viewport.viewScale);
				viewport.placerMismatchX = 0;
				viewport.placerMismatchY = 0;
				viewport.placer.visible = false;
		}

		// The touch is already over, now cleanup and return from there
		screen.offPointerMove(keyMouseMove);
	}
	public function handleDoubleClick(): Void {
		// TODO immediately switch ui to Legend-mode
		// igonre if already in Legend-mode
		// TODO initiate text entry filed for the keycap that received the click:
		trace('Doubleclick processed.');
	}
}
