package;

import ceramic.Mesh;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;


class ViewportCursor extends Visual {
	public var corner1: Mesh;
	public var corner2: Mesh;
	public var corner3: Mesh;
	public var corner4: Mesh;
	public var quad: Quad;
	public var color: Color;

	override public function new(width: Float, height: Float) {

		super();
		size(width, height);
		this.depth = 2;
		this.color = 0x003C4BC5; // UI theme accent color!
		this.create();
	}

	public function create(): Visual {

		this.quad = new Quad();
		this.quad.pos(0, 0);
		this.quad.size(this.width,this.height);
		this.quad.color = this.color;
		this.quad.depth = 2;
//		this.add(this.quad);

		this.corner1 = new Mesh();
		this.corner1.color = this.color;
//		this.corner1.colorMapping = MESH;
				this.corner1.vertices = [
			width * 0.04,          0.0,  //   ____
			width * 0.20,          0.0,  //  /    |
			width * 0.20, width * 0.04,  //  |   /
			width * 0.04, width * 0.20,  //  |  /
			         0.0, width * 0.20,  //  |_/
			         0.0, width * 0.04,
			];
		this.corner1.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
			];
  	this.corner1.pos(0, 0);
		this.corner1.depth = 4;
		this.add(this.corner1);

		this.corner3 = new Mesh();
		this.corner3.color = this.color;
//		this.corner3.colorMapping = MESH;
		this.corner3.vertices = [
			width * 0.04,          0.0,  //   ____
			width * 0.20,          0.0,  //  /    |
			width * 0.20, width * 0.04,  //  |   /
			width * 0.04, width * 0.20,  //  |  /
			         0.0, width * 0.20,  //  |_/
			         0.0, width * 0.04,
			];
		this.corner3.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
			];
		this.corner3.pos(this.width,this.height);
		this.corner3.depth = 4;
		this.corner3.rotation = 180;
		this.add(this.corner3);

		this.corner2 = new Mesh();
		this.corner2.color = this.color;
//		this.corner2.colorMapping = MESH;
		this.corner2.vertices = [
			width * 0.04,          0.0,  //   ____
			width * 0.20,          0.0,  //  /    |
			width * 0.20, width * 0.04,  //  |   /
			width * 0.04, width * 0.20,  //  |  /
			         0.0, width * 0.20,  //  |_/
			         0.0, width * 0.04,
			];
		this.corner2.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
			];
  	this.corner2.pos(0, 0);
		this.corner2.pos(this.width,0);
		this.corner2.depth = 4;
		this.corner2.rotation = 90;
		this.add(this.corner2);

		this.corner4 = new Mesh();
		this.corner4.color = this.color;
//		this.corner4.colorMapping = MESH;
		this.corner4.vertices = [
			width * 0.04,          0.0,  //   ____
			width * 0.20,          0.0,  //  /    |
			width * 0.20, width * 0.04,  //  |   /
			width * 0.04, width * 0.20,  //  |  /
			         0.0, width * 0.20,  //  |_/
			         0.0, width * 0.04,
			];
		this.corner4.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
			];
		this.corner4.pos(0,this.height);
		this.corner4.depth = 4;
		this.corner4.rotation = -90;
		this.add(this.corner4);

		return this;
	}
}
