package viewport;

import ceramic.Mesh;
import ceramic.Arc;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

/**
 *
 *    Draw a pivot marker on the given coordinates on the screen
 * (a hollow circle with what would be a croos if it extended thru it's center)
 *
 */
class Pivot extends Visual {
	// var color:Int = 0xF0ef7d57; // default orange (clockwork?)
	var color: Int = Color.YELLOW;
	var thickness: Float = 1.25;
	var dimension: Float = 32.0;
	var posX: Float;
	var posY: Float;

	//	var visible:Bool = false; // we are created invisible

	public function new(posX: Float, posY: Float) {
		super();
		this.pos(posX, posY);
		this.visible = false; // we are created invisible per default
		this.create();
	}

	public function create() {
		final radius = (dimension - 4) / 2;
		final round = new Arc();
		round.radius = radius;
		round.pos(posX, posY);
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
			dash.pos(posX + dimension * 0, posY);
			dash.anchorX = 1.25;
			dash.anchorY = 0.5; // thickness / 2;
			dash.rotation = i * 90;
			this.add(dash);
		}
		this.depth = 999;

		return this;
	}
}
