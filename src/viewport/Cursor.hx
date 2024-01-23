package viewport;

import ceramic.Mesh;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

/*
 * The cursor is the shape that points where the next object will be placed
 *
 */
class Cursor extends Visual {
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
		// this.depth = 800; // only pivots and gimbals higher than us
		this.color = 0x6D3C4BC5; // UI theme accent color!

		// @formatter:off
		this.vertices = [
			width * 0.04, 0.0,            //  0____ 1
			width * 0.20, 0.0,            //  /    |
			width * 0.20, height * 0.04,  // 5|   / 2
			width * 0.04, height * 0.20,  //  |  /
			0.0, height * 0.20,           //  |_/
			0.0, height * 0.04,           // 4  3
		];
		this.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
		];
		// @formatter:on
	}

	public function create(): Visual { // TODO make cursor's size dynamic
		// TOP LEFT
		this.topLeft = new Mesh();
		this.topLeft.color = this.color;
		this.topLeft.vertices = this.vertices;
		this.topLeft.indices = this.indices;
		this.topLeft.pos(0, 0);
		this.topLeft.depth = 800;
		this.add(this.topLeft);

		// BOTTOM LEFT
		this.bottomLeft = new Mesh();
		this.bottomLeft.color = this.color;
		this.bottomLeft.vertices = this.vertices;
		this.bottomLeft.indices = this.indices;
		this.bottomLeft.pos(this.width, 0);
		this.bottomLeft.depth = 800;
		this.bottomLeft.rotation = 90;
		this.add(this.bottomLeft);

		// TOP RIGHT
		this.topRight = new Mesh();
		this.topRight.color = this.color;
		this.topRight.vertices = this.vertices;
		this.topRight.indices = this.indices;
		this.topRight.pos(0, this.height);
		this.topRight.depth = 800;
		this.topRight.rotation = -90;
		this.add(this.topRight);

		// BOTTOM RIGHT
		this.bottomRight = new Mesh();
		this.bottomRight.color = this.color;
		this.bottomRight.vertices = this.vertices;
		this.bottomRight.indices = this.indices;
		this.bottomRight.pos(this.width, this.height);
		this.bottomRight.depth = 800;
		this.bottomRight.rotation = 180;
		this.add(this.bottomRight);

		return this;
	}
}
