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
class Gimball extends Visual {
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
		final gimball1 = new Quad();
		gimball1.size(100, 100);
		gimball1.color = color1;
		gimball1.alpha = 0.5 * this.subAlpha;
		gimball1.rotation = 45;
		gimball1.pos(offSet, 0);
		this.add(gimball1);

		final gimball2 = new Quad();
		gimball2.size(100, 100);
		gimball2.color = color1;
		gimball2.alpha = 0.5 * this.subAlpha;
		gimball2.rotation = 45;
		gimball2.pos(0, offSet);
		this.add(gimball2);

		final gimball3 = new Quad();
		gimball3.size(100, 100);
		gimball3.color = color1;
		gimball3.alpha = 0.5 * this.subAlpha;
		gimball3.rotation = 45;
		gimball3.pos(-offSet, 0);
		this.add(gimball3);

		final gimball4 = new Quad();
		gimball4.size(100, 100);
		gimball4.color = color1;
		gimball4.alpha = 0.5 * this.subAlpha;
		gimball4.rotation = 45;
		gimball4.pos(0, -offSet);
		this.add(gimball4);

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

		gimball1.clip = circle;
		gimball2.clip = circle;
		gimball3.clip = circle;
		gimball4.clip = circle;

		final top = new RoundedQuad(100, 100, 12);
		top.pos(-50, 21);
		top.color = color1;
		top.subAlpha = this.subAlpha;
		this.add(top);

		return this;
	}
}
