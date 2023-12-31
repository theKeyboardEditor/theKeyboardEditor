package;

import ceramic.Mesh;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

class ViewportCursor extends Visual {
	// Corners
	public var topLeft: Mesh;
	public var bottomLeft: Mesh;
	public var bottomRight: Mesh;
	public var topRight: Mesh;
	public var color: Color;

	// For corners
	final vertices: Array<Float>;
	final indices: Array<Int>;

	override public function new(width: Float, height: Float) {
		super();
		size(width, height);
		this.depth = 2;
		this.color = 0x003C4BC5; // UI theme accent color!

		// Set the indices and vertices for the corners
		// @formatter:off	
		this.vertices = [
			width * 0.04, 0.0,            //   ____
			width * 0.20, 0.0,            //  /    |
			width * 0.20, height * 0.04,  //  |   /
			width * 0.04, height * 0.20,  //  |  /
			0.0, height * 0.20,           //  |_/
			0.0, height * 0.04,
		]; 
		this.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
		];
		// @formatter:on
	}

	public function create(): Visual {
		// FIRST CORNER
		this.topLeft = new Mesh();
		this.topLeft.color = this.color;
		this.topLeft.vertices = this.vertices;
		this.topLeft.indices = this.indices;
		this.topLeft.pos(0, 0);
		this.topLeft.depth = 4;
		this.add(this.topLeft);

		// THIRD CORNER
		this.bottomRight = new Mesh();
		this.bottomRight.color = this.color;
		this.bottomRight.vertices = this.vertices;
		this.bottomRight.indices = this.indices;
		this.bottomRight.pos(this.width, this.height);
		this.bottomRight.depth = 4;
		this.bottomRight.rotation = 180;
		this.add(this.bottomRight);

		// SECOND CORNER
		this.bottomLeft = new Mesh();
		this.bottomLeft.color = this.color;
		this.bottomLeft.vertices = this.vertices;
		this.bottomLeft.indices = this.indices;
		this.bottomLeft.pos(this.width,0);
		this.bottomLeft.depth = 4;
		this.bottomLeft.rotation = 90;
		this.add(this.bottomLeft);

		// FOURTH CORNER
		this.topRight = new Mesh();
		this.topRight.color = this.color;
		this.topRight.vertices = this.vertices;
		this.topRight.indices = this.indices;
		this.topRight.pos(0, this.height);
		this.topRight.depth = 4;
		this.topRight.rotation = -90;
		this.add(this.topRight);

		return this;
	}
}