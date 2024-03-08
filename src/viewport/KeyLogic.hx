package viewport;

import ceramic.Entity;
import ceramic.Component;
import ceramic.TouchInfo;

class KeyLogic extends Entity implements Component {
	@entity var keycap: KeyRenderer;

	public var viewport: viewport.Viewport;

	var keycapIsDragged = false;
	var keycapPosStartX: Float = 0.0;
	var keycapPosStartY: Float = 0.0;

	public function new(?viewport: viewport.Viewport) {
		super();
		if (viewport != null) {
			this.viewport = viewport;
		}
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
	 * Called after the drag (touch/press is released)
	 */
	function keyMouseUp(info: TouchInfo, keycap: KeyRenderer) {
		switch (ui.Index.activeMode) {
			case Place:
				viewport.placer.visible = true;
			case Edit | Unit | Color | Legend | Present:
				final keycaps = viewport.selectedKeycaps;
				viewport.selectionBox.visible = false;

				if (!app.input.keyPressed(LCTRL) || !app.input.keyPressed(RCTRL)) {
					if (!(app.input.keyPressed(LSHIFT) || app.input.keyPressed(RSHIFT))) {
						viewport.clearSelection(true);
					}
					// this toggling prevents destruction on drag!
					keycaps.remove(keycap);
					// make so the clicked on keycap is the last selected
					keycaps.unshift(keycap);
					keycap.select();
				} else {
					// ctrl for deselect
					keycaps.remove(keycap);
					keycap.deselect();
				}

				// If no Placing then restore placer to default size
				viewport.inhibitDrag = false;
				viewport.placer.size(viewport.unit * viewport.viewScale, viewport.unit * viewport.viewScale);
				viewport.placerMismatchX = 0;
				viewport.placerMismatchY = 0;

				// Actually begin to execute the move of the selection
				if (keycaps.length > 0) {
					var x = (keycaps[0].x - keycapPosStartX) / viewport.unit * viewport.viewScale;
					var y = (keycaps[0].y - keycapPosStartY) / viewport.unit * viewport.viewScale;
					// only try to move if  x and y is not zero and there was no inhibitDrag and we have any selected keys to move at all
					if (x != 0 || y != 0 && !viewport.inhibitDrag && keycaps.length > 0) {
						viewport.queue.push(new actions.MoveKeys(viewport, keycaps, x, y));
						// deselect only if single element was just dragged
						if (keycaps.length == 1) {
							keycaps[0].deselect();
							keycaps.remove(keycaps[0]);
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

	/**
	 * Called during key movement (mouse key down)
	 */
	function keyMouseMove(info: TouchInfo) {
		if (ui.Index.activeMode != Place && ui.Index.activeMode != Present) {
			// there is a special case where the last selected element gets deselected and then dragged
			final keycaps = viewport.selectedKeycaps;
			if (keycaps.length > 0 && !viewport.inhibitDrag) {
				final xStep = Viewport.coggify(keycapPosStartX + (screen.pointerX - viewport.pointerStartX) / viewport.viewScale,
					Viewport.placingStep)
					- keycaps[0].x;
				final yStep = Viewport.coggify(keycapPosStartY + (screen.pointerY - viewport.pointerStartY) / viewport.viewScale,
					Viewport.placingStep)
					- keycaps[0].y;
				for (key in keycaps) {
					key.x += xStep;
					key.y += yStep;
				}
			}
		}
	}

	public function handleDoubleClick(): Void {
		if (viewport.selectedKeycaps.length > 0) {
			viewport.clearSelection(true);
			viewport.selectionBox.visible = false;
		}
		keycap.select();
		viewport.selectedKeycaps.unshift(keycap);
	}
}
