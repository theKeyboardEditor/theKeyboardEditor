package viewport;

import ceramic.Mesh;
import ceramic.Arc;
import ceramic.Color;
import ceramic.Visual;

/**
 *
 *    Draw a pivot marker on the given coordinates on the screen
 * (a hollow circle with what would be a croos if it extended thru it's center)
 *
 */
class Pivot extends Visual {
	var color:Int = 0xF0ef7d57; // default orange (clockwork?)
	var thickness:Float = 1.0;
	var size:Float = 12.0;
	
	override public function new(posX:Float, posY:Float) {
		super();
		this.pos(posX,posY);
		this.create();
		w = width;
		h = height;
		
	}
	
	override public function create() {
		final radius = (size - 4) / 2;
		final round = new Arc();
		round.radius = radius;
		round.pos(-radius, -radius);
		round.sides = 18;
		round.borderPosition = MIDDLE;
		round.thickness = thickness;
		round.angle = 360;
		round.color = this.color;
		this.add(round);

		final dash = new Quad();
		dash.color = this.color;
		dash.size(size, thickness);
		dash.pos(-size / 2, -thickness / 2);
		this.add(dash);
		
		return this;
	}
	}
