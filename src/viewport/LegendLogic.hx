package viewport;

import ceramic.Entity;
import ceramic.Component;
import ceramic.TouchInfo;

class LegendLogic extends Entity implements Component {
	@entity var legend: LegendRenderer;

	public var keycap: KeyRenderer;
	public var viewport: viewport.Viewport;
	// drag threshold in pixels
	public var threshold: Float = 2;

	var legendIsDragged = false;
	// legend position before the drag
	var legendPosStartX: Float = 0.0;
	var legendPosStartY: Float = 0.0;

	public function new(viewport: viewport.Viewport, keycap: KeyRenderer) {
		super();
		this.viewport = viewport;
		// TODO see this keycap does belong to the actual legned that brought us here!
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
		viewport.placer.visible = (ui.Index.activeMode == Place);

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
		trace('Click on Legend.');
	}

	/**
	 * Called during key movement (mouse key down)
	 */
	function legendMouseMove(info: TouchInfo) {
		if (viewport.threshold != -1
			&& (Math.abs(screen.pointerX - viewport.pointerStartX) > viewport.threshold
				|| Math.abs(screen.pointerY - viewport.pointerStartY) > viewport.threshold))
			legendIsDragged = true;
		switch (ui.Index.activeMode) {
			case Legend:
				// react only on drag event
				if (legendIsDragged) {
					// clicked on a selected keycap?
					// TODO find out the right keycap!
					if ((viewport.selectedKeycaps.contains(keycap)) && (viewport.selectedKeycapLegends.contains(legend))) {
						// only ever try drag if any selection exists
						if ((viewport.selectedKeycaps.length > 0) && (viewport.selectedKeycapLegends.length > 0)) {
							// note we reference the Array member [0] for move vector!
							final xStep = (legendPosStartX + (screen.pointerX - viewport.pointerStartX) / viewport.viewScale)
								- viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].legends[viewport.selectedKeycapLegends.indexOf(legend)].x;
							final yStep = (legendPosStartY + (screen.pointerY - viewport.pointerStartY) / viewport.viewScale)
								- viewport.selectedKeycaps[viewport.selectedKeycaps.indexOf(keycap)].legends[viewport.selectedKeycapLegends.indexOf(legend)].y;
							for (key in viewport.selectedKeycaps) {
								for (label in viewport.selectedKeycapLegends) {
									label.x += xStep;
									label.y += yStep;
								}
							}
						}
					} else {
						viewport.selectionBox.visible = legendIsDragged;
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							// We don't intentionally deselect keycaps in Legend mode
							viewport.clearSelectedLegends(true);
						}
						final boxX = viewport.selectionBox.x;
						final boxY = viewport.selectionBox.y;
						final boxWidth = viewport.selectionBox.width;
						final boxHeight = viewport.selectionBox.height;

						// TODO implement CTRL deselection processing
						for (k in viewport.keyson.units[viewport.currentUnit].keys) {
							// calculate position and size of a body:
							// TODO make this work for legends!
							final body = viewport.keyBody(k);
							final keyX = body.x;
							final keyY = body.y;
							final keyWidth = body.width;
							final keyHeight = body.height;
							if (keyX > boxX && keyX + keyWidth < boxX + boxWidth && keyY > boxY && keyY + keyHeight < boxY + boxHeight) {
								final keysOnUnit: Array<KeyRenderer> = Reflect.getProperty(viewport.keycapSet, 'children');
								for (key in keysOnUnit) {
									if (key.sourceKey == k) {
										for (label in key.legends) {
											label.select();
											viewport.selectedKeycapLegends.unshift(label);
										}
										//key.select();
										//viewport.selectedKeycaps.unshift(key);
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
	function legendMouseUp(info: TouchInfo, legend: LegendRenderer) {
		switch (ui.Index.activeMode) {
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
						viewport.selectedKeycapLegends.remove(legend);
						legend.deselect();
					} else {
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							// CLEAR if no SHIFT key is pressed
							viewport.clearSelectedLegends(true);
						}
						// put last selected legend to position [0] in keycaps
						viewport.selectedKeycapLegends.unshift(legend);
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
							viewport.queue.push(new actions.MoveLabels(viewport, viewport.selectedKeycapLegends, x / viewport.viewScale,
								y / viewport.viewScale));
						}
					} else {
						// DRAGGING outside a selected legend results in a rectangle selection
						viewport.selectionBox.visible = false;
						if (!app.input.keyPressed(LSHIFT) && !app.input.keyPressed(RSHIFT)) {
							viewport.clearSelectedLegends(true);
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
										for (label in key.legends) {
											label.select();
											viewport.selectedKeycapLegends.unshift(label);
										}
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
		trace('Doubleclick on legend (!) processed.');
		viewport.indexGui.switchMode(Legend);
	}
}
