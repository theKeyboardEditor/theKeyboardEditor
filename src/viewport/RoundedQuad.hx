package viewport;

import ceramic.Shape;
import ceramic.Color;
import ceramic.Visual;

/**
 *    Draw a rectangle with 4 segments rounded corners (16 segments circle)
 * (This is half as nice as 32 segment arc, but much faster to precess and draw)
 *
 */
class RoundedQuad extends Visual {
	public var color: Int = 0x80CCCCCC; // if alpha is equal 0xFF opacity does not work?
	public var subAlpha = 1.0; // externaly regulate opacity
	public var segments: Int = 10; // 1...many

	var roundedCorner: Float; // undefined since mandatory parameter
	var localRadius: Float;
	var localWidth: Float;
	var localHeigth: Float;
	var sine: Array<Float>;
	var cosine: Array<Float>;
	var points: Array<Float>;

	override public function new(width: Float, height: Float, roundedCorner: Float) {
		super();

		size(width, height);

		this.localWidth = width;
		this.localHeigth = height;
		this.localRadius = roundedCorner;
		this.create();
	}

	public function create() {
		// define the realitve coordinates for the radius
		var sine = [for (angle in 0...segments + 1) Math.sin(Math.PI / 2 * angle / segments)];
		var cosine = [for (angle in 0...segments + 1) Math.cos(Math.PI / 2 * angle / segments)];

		points = []; // re-clear the array since we are pushing only
		for (pointPairs in 0...segments) {
			points.push(localRadius * (1 - cosine[pointPairs]));
			points.push(localRadius * (1 - sine[pointPairs]));
		}
		for (pointPairs in 0...segments) {
			points.push(localWidth + localRadius * (cosine[segments - pointPairs] - 1));
			points.push(localRadius * (1 - sine[segments - pointPairs]));
		}
		for (pointPairs in 0...segments) {
			points.push(localWidth + localRadius * (cosine[pointPairs] - 1));
			points.push(localHeigth + localRadius * (sine[pointPairs] - 1));
		}
		for (pointPairs in 0...segments) {
			points.push(localRadius * (1 - cosine[segments - pointPairs]));
			points.push(localHeigth + localRadius * (sine[segments - pointPairs] - 1));
		}

		final shape = new Shape();
		shape.color = this.color;
		shape.points = points;
		// shape.triangulation = EARCUT;
		// shape.triangulation = POLY2TRI;
		shape.alpha = 0.95 * this.subAlpha; // we draw slightly opaque
		this.add(shape);

		return this;
	}
}
