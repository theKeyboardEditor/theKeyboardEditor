package viewport.components;

import ceramic.Entity;
import ceramic.Component;
import ceramic.TouchInfo;

class LegendLogic extends Entity implements Component {
	@entity var legend: Legend;

	public var keycap: Keycap;
	public var viewport: viewport.Viewport;
	// drag threshold in pixels
	public var dragThreshold: Float = 2;

	var legendIsDragged = false;
	// legend position before the drag
	var legendPosStartX: Float = 0.0;
	var legendPosStartY: Float = 0.0;

	public function new(viewport: viewport.Viewport, keycap: Keycap) {
		super();
		this.viewport = viewport;
		this.keycap = keycap;
	}

	function bindAsComponent() {
		final doubleClick = new ceramic.DoubleClick();
		doubleClick.onDoubleClick(legend, handleDoubleClick);
		legend.component('doubleClick', doubleClick);

		legend.onPointerDown(legend, legendMouseDown);
	}

	/**
	 * This gets called only if clicked over a key on the worksurface!
	 * because we create keys in actions we need this accesible (thus public) from there
	 */
	public function legendMouseDown(info: TouchInfo) {
		// Reset on each begin
		legendIsDragged = false;
		viewport.placer.visible = (viewport.activeMode.state == Place);

		// Set where the legend is before the drag
		legendPosStartX = legend.x;
		legendPosStartY = legend.y;

		// Set where the pointer is
		viewport.pointerStartX = screen.pointerX;
		viewport.pointerStartY = screen.pointerY;

		// Move along as we pan the touch
		screen.onPointerMove(this, legendMouseMove);

		// Finish the drag when the pointer is released
		screen.oncePointerUp(this, (info) -> {
			legendMouseUp(info, legend);
		});
	}

	/**
	 * Called during key movement (mouse key down)
	 */
	function legendMouseMove(info: TouchInfo) {
		if (viewport.dragThreshold != -1
			&& (Math.abs(screen.pointerX - viewport.pointerStartX) > viewport.dragThreshold
				|| Math.abs(screen.pointerY - viewport.pointerStartY) > viewport.dragThreshold))
			legendIsDragged = true;
		switch (viewport.activeMode.state) {
			case Legend:
				// react only on drag event
				if (legendIsDragged) {
					// clicked on a selected keycap?
					// TODO find out the right keycap!
					if (viewport.selectedKeycaps.contains(keycap)) {
						// only ever try drag if any selection exists
						// TODO make this work for legends!
						if (viewport.selectedKeycaps.length > 0) {
							// note we reference the Array member [0] for move vector!
							final xStep = Viewport.snap(legendPosStartX + (screen.pointerX - viewport.pointerStartX) / viewport.viewScale,
								Viewport.placingStep)
								- viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].x;
							final yStep = Viewport.snap(legendPosStartY + (screen.pointerY - viewport.pointerStartY) / viewport.viewScale,
								Viewport.placingStep)
								- viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].y;
							for (key in viewport.selectedKeycaps) {
								key.x += xStep;
								key.y += yStep;
							}
						}
					} else {
						viewport.selectionBox.visible = legendIsDragged;
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							viewport.clearSelection();
						}
						final boxX = viewport.selectionBox.x;
						final boxY = viewport.selectionBox.y;
						final boxWidth = viewport.selectionBox.width;
						final boxHeight = viewport.selectionBox.height;

						// TODO implement CTRL deselection processing
						for (k in viewport.keyson.units[viewport.focusedUnit].keys) {
							// calculate position and size of a body:
							final body = viewport.keyGeometry(k);
							final keyX = body.x;
							final keyY = body.y;
							final keyWidth = body.width;
							final keyHeight = body.height;
							if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
								final keysOnUnit: Array<Keycap> = cast viewport.keyboard.children;
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
	function legendMouseUp(info: TouchInfo, legend: Legend) {
		switch (viewport.activeMode.state) {
			case Legend:
				viewport.selectionBox.visible = false;
				viewport.placer.size(viewport.unit * viewport.viewScale, viewport.unit * viewport.viewScale);
				viewport.placerMismatchX = 0;
				viewport.placerMismatchY = 0;
				// SELECTING
				//  - by click only when not dragging
				if (!legendIsDragged) {
					if (app.input.keyPressed(LCTRL) || app.input.keyPressed(RCTRL)) {
						// ctrl for deselect
						viewport.selectedKeycaps.remove(keycap);
						legend.deselect();
					} else {
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							// CLEAR if no SHIFT key is pressed
							viewport.clearSelection();
						}
						// put last selected legend to position [0] in keycaps
						viewport.selectedKeycaps.unshift(keycap);
						legend.select();
					}
				} else {
					// DRAGGING
					//  the selected (if any) keys and the dragg event happened on a selected key
					if (viewport.selectedKeycaps.length > 0 && viewport.selectedKeycaps.contains(keycap)) {
						var x = (viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].x
							- legendPosStartX) / viewport.unit * viewport.viewScale;
						var y = (viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].y
							- legendPosStartY) / viewport.unit * viewport.viewScale;
						// only try to move if  x and y is not zero and we have any selected keys to move at all
						// if (x != 0 || y != 0 && viewport.selectedKeycaps.length > 0) {
						if (viewport.selectedKeycaps.length > 0) {
							viewport.queue.push(new actions.MoveKeys(viewport, viewport.selectedKeycaps, x / viewport.viewScale,
								y / viewport.viewScale));
						}
					} else {
						// DRAGGING outside a selected legend results in a rectangle selection
						viewport.selectionBox.visible = false;
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							viewport.clearSelection();
						}
						final boxX = viewport.selectionBox.x;
						final boxY = viewport.selectionBox.y;
						final boxWidth = viewport.selectionBox.width;
						final boxHeight = viewport.selectionBox.height;

						// TODO implement CTRL deselection processing
						for (k in viewport.keyson.units[viewport.focusedUnit].keys) {
							// calculate position and size of a body:
							final body = viewport.keyGeometry(k);
							final keyX = body.x;
							final keyY = body.y;
							final keyWidth = body.width;
							final keyHeight = body.height;
							if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
								final keysOnUnit: Array<Keycap> = cast viewport.keyboard.children;
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
		screen.offPointerMove(legendMouseMove);
	}
	public function handleDoubleClick(): Void {
		// TODO initiate text entry filed for the legend that received the click:
		viewport.indexGui.switchMode(Legend);
	}
}
