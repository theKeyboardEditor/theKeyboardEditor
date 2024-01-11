package viewport;

import ceramic.Mesh;
import ceramic.Quad;
import ceramic.Arc;
import ceramic.Color;
import ceramic.Visual;

/*
 * The gimbal is the shape that when dragged transfers actions to other objects
 *
 */
class Gimbal extends Visual {
	// Elements
	public var squareUp: Quad;
	public var squareDown: Quad;
	public var squareLeft: Quad;
	public var squareRight: Quad;
	public var top: Mesh;
	// public var container: Arc;
	public var color1: Color;
	public var color2: Color;
	public var w: Float = 100;
	public var h: Float = 100;

	var offSet = 75;
	var radius = 100;

	public var subAlpha = 1.0;

	override public function new(w: Float, h: Float) {
		super();
		// we might want to dynamically scale depending of our screen size:
		this.w = w;
		this.h = h;
		this.size(h, w);
		this.depth = 1000; // always soar high above everything
		this.subAlpha = 1; // we start in the middle
		this.color1 = 0x40CCCCCC;
		this.color2 = 0x40FCFCFC;
	}

	public function create(): Visual {
		final gimbal1 = new Quad();
		gimbal1.size(100, 100);
		gimbal1.color = color1;
		gimbal1.alpha = 0.5 * this.subAlpha;
		gimbal1.rotation = 45;
		gimbal1.pos(offSet, 0);
		this.add(gimbal1);

		final gimbal2 = new Quad();
		gimbal2.size(100, 100);
		gimbal2.color = color1;
		gimbal2.alpha = 0.5 * this.subAlpha;
		gimbal2.rotation = 45;
		gimbal2.pos(0, offSet);
		this.add(gimbal2);

		final gimbal3 = new Quad();
		gimbal3.size(100, 100);
		gimbal3.color = color1;
		gimbal3.alpha = 0.5 * this.subAlpha;
		gimbal3.rotation = 45;
		gimbal3.pos(-offSet, 0);
		this.add(gimbal3);

		final gimbal4 = new Quad();
		gimbal4.size(100, 100);
		gimbal4.color = color1;
		gimbal4.alpha = 0.5 * this.subAlpha;
		gimbal4.rotation = 45;
		gimbal4.pos(0, -offSet);
		this.add(gimbal4);

		final circle = new Arc();
		circle.radius = radius;
		circle.sides = 40;
		circle.borderPosition = INSIDE;
		circle.thickness = radius;
		circle.angle = 360;
		circle.color = color2;
		circle.pos(0, offSet * .94);
		circle.alpha = 0.01 * this.subAlpha;
		this.add(circle);

		gimbal1.clip = circle;
		gimbal2.clip = circle;
		gimbal3.clip = circle;
		gimbal4.clip = circle;

		final top = new RoundedQuad(100, 100, 12);
		top.pos(-50, 21);
		top.color = color1;
		top.subAlpha = this.subAlpha;
		this.add(top);

		return this;
	}
}
