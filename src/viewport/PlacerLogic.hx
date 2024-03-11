package viewport;

import ceramic.Entity;
import ceramic.Component;
import keyson.Axis;

class PlacerLogic extends Entity implements Component {
	@entity var placer: Placer;

	public var viewport: viewport.Viewport;

	public function new(viewport: viewport.Viewport) {
		super();
		this.viewport = viewport;
	}

	function bindAsComponent() {
		app.onUpdate(this, this.update);
	}

	/**
	 * Runs every frame, used to position the placer
	 */
	function update(delta: Float) {
		switch (ui.Index.activeMode) {
			case Place:
				final shape = if (CopyBuffer.designatedKey != null) CopyBuffer.designatedKey else "1U";
				final unit = viewport.keyson.units[0];

				viewport.selectionBox.visible = false;
				placer.visible = true;

				viewport.gapX = Std.int((unit.keyStep[Axis.X]
					- unit.capSize[Axis.X]) / unit.keyStep[Axis.X] * viewport.unit * viewport.viewScale);
				viewport.gapY = Std.int((unit.keyStep[Axis.Y]
					- unit.capSize[Axis.Y]) / unit.keyStep[Axis.Y] * viewport.unit * viewport.viewScale);

				switch shape {
					case "ISO":
						placer.size(1.50 * viewport.unit - viewport.gapX, 2.00 * viewport.unit - viewport.gapY);
					case "ISO Inverted":
						placer.size(1.50 * viewport.unit - viewport.gapX, 2.00 * viewport.unit - viewport.gapY);
					case "BAE":
						viewport.placerMismatchX = 0.75;
						placer.size(2.25 * viewport.unit - viewport.gapX, 2.00 * viewport.unit - viewport.gapY);
					case "BAE Inverted":
						placer.size(2.25 * viewport.unit - viewport.gapX, 2.00 * viewport.unit - viewport.gapY);
					case "XT_2U":
						viewport.placerMismatchX = 1;
						placer.size(2.00 * viewport.unit - viewport.gapX, 2.00 * viewport.unit - viewport.gapY);
					case "AEK":
						viewport.placerMismatchX = 0;
						placer.size(1.25 * viewport.unit - viewport.gapX, 2.00 * viewport.unit - viewport.gapY);
					default:
						if (Math.isNaN(Std.parseFloat(shape)) == false) { // aka it is a number
							if (shape.split(' ').indexOf("Vertical") != -1)
								placer.size(viewport.unit - viewport.gapX, viewport.unit * Std.parseFloat(shape) - viewport.gapY);
							else
								placer.size(viewport.unit * Std.parseFloat(shape) - viewport.gapX, viewport.unit - viewport.gapY);
						}
				}

				placer.x = Viewport.coggify((screen.pointerX
					- viewport.screenX
					- viewport.x
					- viewport.placerMismatchX * viewport.unit) / viewport.viewScale,
					Viewport.placingStep);
				placer.y = Viewport.coggify((screen.pointerY
					- viewport.screenY
					- viewport.y
					- viewport.placerMismatchY * viewport.unit) / viewport.viewScale,
					Viewport.placingStep);
				StatusBar.pos(placer.x / viewport.unit * viewport.viewScale, placer.y / viewport.unit * viewport.viewScale);
			default:
				placer.visible = false;
				viewport.placerMismatchX = Viewport.coggify(placer.width / viewport.unit / 2 * viewport.viewScale, .25);
				viewport.placerMismatchY = Viewport.coggify(placer.height / viewport.unit / 2 * viewport.viewScale, .25);
		}
	}
}
