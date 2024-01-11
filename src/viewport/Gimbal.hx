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
	//public var container: Arc;
	public var color1: Color;
	public var color2: Color;
	public var w: Float = 100;
	public var h: Float = 100;
	var offSet = 75;
	var radius = 100;
	public var subAlpha = 1.0;
	
	override public function new(w:Float, h:Float) {
		super();
		// we might want to dynamically scale depending of our screen size:
		this.w=w;
		this.h=h;
		this.size(h,w);
		this.depth = 1000; // always soar high above everything
		this.subAlpha = 1; // we start in the middle
		this.color1 = 0x40CCCCCC;
		this.color2 = 0x40FCFCFC;
	}

	public function create(): Visual {

		final gizmo1 = new Quad();
		gizmo1.size(100,100);
		gizmo1.color = color1;
		gizmo1.alpha = 0.5 * this.subAlpha;
		gizmo1.rotation = 45;
		gizmo1.pos(offSet,0);
		this.add(gizmo1);

		final gizmo2 = new Quad();
		gizmo2.size(100,100);
		gizmo2.color = color1;
		gizmo2.alpha = 0.5 * this.subAlpha;
		gizmo2.rotation = 45;
		gizmo2.pos(0,offSet);
		this.add(gizmo2);

		final gizmo3 = new Quad();
		gizmo3.size(100,100);
		gizmo3.color = color1;
		gizmo3.alpha = 0.5 * this.subAlpha;
		gizmo3.rotation = 45;
		gizmo3.pos(-offSet,0);
		this.add(gizmo3);

		final gizmo4 = new Quad();
		gizmo4.size(100,100);
		gizmo4.color = color1;
		gizmo4.alpha = 0.5 * this.subAlpha;
		gizmo4.rotation = 45;
		gizmo4.pos(0,-offSet);
		this.add(gizmo4);

		final circle = new Arc();
		circle.radius = radius;
		circle.sides = 40;
		circle.borderPosition = INSIDE;
		circle.thickness = radius;
		circle.angle= 360;
		circle.color = color2;
		circle.pos(0,offSet*.94);
		circle.alpha = 0.01 * this.subAlpha;
		this.add(circle);

		gizmo1.clip = circle;
		gizmo2.clip = circle;
		gizmo3.clip = circle;
		gizmo4.clip = circle;

		final top = new RoundedQuad(100,100,12);
		top.pos(-50,21);
		top.color = color1;
		top.subAlpha = this.subAlpha;
		this.add(top);

		return this;
	}
}
