package viewport;

import ceramic.Mesh;
import ceramic.Shape;
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
	public var color: Int = 0x80CCCCCC; // if alpha is equal 0xFF opacity does not work?
	public var subAlpha = 1.0;  // externaly regulate opacity
	public var segments:Int = 10; // 1...many

	var roundedCorner: Float; // undefined since mandatory parameter
	var rr: Float;
	var ww: Float;
	var hh: Float;
	var s: Array<Float>;
	var c: Array<Float>;
	var pts: Array<Float>;

	override public function new(width: Float, height: Float, roundedCorner: Float) {
		super();
		size(width, height);
		this.ww = width;
		this.hh = height;
		this.rr = roundedCorner;
		this.create();
	}

	public function create() {

		// define the realitve coordinates for the radius
		var s = [ for ( a in 0...segments+1 ) Math.sin(Math.PI / 2 * a / segments)];
		var c = [ for ( a in 0...segments+1 ) Math.cos(Math.PI / 2 * a / segments)];

		pts = []; // re-clear the array since we are pushing only
		for (p in 0...segments) {
			pts.push(rr * (1 - c[p]));
			pts.push(rr * (1 - s[p]));
		}
		for (p in 0...segments) {
			pts.push(ww + rr * (c[segments-p] - 1));
			pts.push(rr * (1 - s[segments-p]));
		}
		for (p in 0...segments) {
			pts.push(ww + rr * (c[p] - 1));
			pts.push(hh + rr * (s[p] - 1));
		}
		for (p in 0...segments) {
			pts.push(rr * (1 - c[segments-p]));
			pts.push(hh + rr * (s[segments-p] - 1));
		}

		final shape = new Shape();
		shape.color = this.color;
		shape.points = pts;
		//shape.triangulation = EARCUT;
		//shape.triangulation = POLY2TRI;
		shape.alpha = 0.95 * this.subAlpha;
		this.add(shape);

		return this;
	}
}
