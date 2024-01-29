package viewport;

import ceramic.Arc;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

/**
 * Draws a pivot marker
 * A hollow circle with what would be a cross if it extended thru it's center
 */
class Pivot extends Visual {
	@content var color: Int = 0xFFFFCD75; // sweetie-16 yellow (3rd accent color)
	@content var thickness: Float = 1.25;
	@content var dimension: Float = 32.0;

	override public function computeContent() {
		final radius = (dimension - 4) / 2;

		var round = new Arc();
		round.radius = radius;
		round.sides = 18;
		round.borderPosition = MIDDLE;
		round.thickness = thickness;
		round.angle = 360;
		round.color = this.color;
		this.add(round);

		for (i in 0...4) {
			final dash = new Quad();
			dash.color = this.color;
			dash.size(dimension / 2, thickness);
			dash.pos(x, y);
			dash.anchorX = 1.25;
			dash.anchorY = 0.5;
			dash.rotation = i * 90;
			this.add(dash);
		}

		super.computeContent();
	}
}
