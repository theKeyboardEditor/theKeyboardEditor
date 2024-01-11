package viewport;

import ceramic.Mesh;
import ceramic.Arc;
import ceramic.Color;
import ceramic.Visual;

/**
 *
 *    Draw a rectangle with 4 segments rounded corners (16 segments circle)
 * (This is half as nice as 32 segment arc, but much faster to precess and draw)
 *
 */
class RoundedQuad extends Visual {
	public var rr: Float;
	public var ww: Float;
	public var hh: Float;
	public var color: Int = 0x80CCCCCC;
	public var subAlpha = 1.0;

	var roundedCorner: Float = (100 / 8);
	var arcPosX: Array<Float>;
	var arcPosY: Array<Float>;
	var arcRotation: Array<Int>;
	// Math.PI() = 180 degrees
	// Math.PI() / 8 = 22.5 deg
	final s2 = Math.sin(Math.PI * 1 / 8); // =0.38268343;
	final c2 = Math.cos(Math.PI * 1 / 8); // =0.92387953;
	final s4 = Math.sin(Math.PI * 2 / 8); // sin(45) = 0.70710678;
	final c4 = Math.cos(Math.PI * 2 / 8); // =0.70710678;
	final s6 = Math.sin(Math.PI * 3 / 8); // =0.92387953;
	final c6 = Math.cos(Math.PI * 3 / 8); // =0.38268343;

	override public function new(width: Float, height: Float, roundedCorner: Float) {
		super();
		size(width, height);
		this.roundedCorner = roundedCorner;
		trace(this.color);
		this.create();
	}

	public function create() {
		rr = this.roundedCorner;
		ww = this.width;
		hh = this.height;
		final points: Array<Float> = [
			                 0,                 rr,
			     rr * (1 - c2),      rr * (1 - s2),
			     rr * (1 - c4),      rr * (1 - s4),
			     rr * (1 - c4),      rr * (1 - s4),
			     rr * (1 - c6),      rr * (1 - s6),
			                rr,                  0,
			           ww - rr,                  0,
			ww + rr * (c6 - 1),      rr * (1 - s6),
			ww + rr * (c4 - 1),      rr * (1 - s4),
			ww + rr * (c2 - 1),      rr * (1 - s2),
			                ww,                 rr,
			                ww,            hh - rr,
			ww + rr * (c2 - 1), hh + rr * (s2 - 1),
			ww + rr * (c4 - 1), hh + rr * (s4 - 1),
			ww + rr * (c6 - 1), hh + rr * (s6 - 1),
			           ww - rr,                 hh,
			                rr,                 hh,
			     rr * (1 - c6), hh + rr * (s6 - 1),
			     rr * (1 - c4), hh + rr * (s4 - 1),
			     rr * (1 - c2), hh + rr * (s2 - 1),
			                 0,            hh - rr
		];
		final tris: Array<Int> = [
			 1,  2,  3,
			 3,  4,  5,
			 1,  3,  5,
			 1,  5,  6,
			 1,  6, 10,
			 6,  8, 10,
			 6,  7,  8,
			 8,  9, 10,
			 1, 10, 11,
			 1, 11, 20,
			11, 12, 13,
			11, 13, 15,
			13, 14, 15,
			11, 15, 16,
			11, 16, 20,
			16, 17, 18,
			16, 18, 20,
			18, 19, 20
		];

		final shape = new Mesh();
		shape.color = this.color;
		shape.vertices = points;
		shape.indices = tris;
		shape.colorMapping = MESH;
		shape.alpha = 0.95 * this.subAlpha;
		this.add(shape);

		return this;
	}
}
