package viewport;

import ceramic.Mesh;
import ceramic.Color;
import ceramic.Visual;

/**
 * The placer is the shape that points where the next object will be placed
 */
class Placer extends Visual {
	@content public var color: Color;
	@content public var piecesSize: Float; // is 100 (same as unit) for 1:1 scale

	// Corners
	var topLeft: Mesh;
	var bottomLeft: Mesh;
	var bottomRight: Mesh;
	var topRight: Mesh;

	// For corners
	var vertices: Array<Float>;
	var indices: Array<Int>;

	override public function set_width(width: Float): Float {
		if (this.width == width)
			return width;
		super.set_width(width);
		contentDirty = true;
		return width;
	}

	override public function set_height(height: Float): Float {
		if (this.height == height)
			return height;
		super.set_height(height);
		contentDirty = true;
		return height;
	}

	override public function new() {
		this.color = 0x6D3C4BC5; // UI theme accent color!
		contentDirty = true;
		super();
	}

	override public function computeContent() {
		// @formatter:off
		this.vertices = [
			piecesSize * 0.04, 0.0,               //  0____ 1
			piecesSize * 0.20, 0.0,               //  /    |
			piecesSize * 0.20, piecesSize * 0.04, // 5|   / 2
			piecesSize * 0.04, piecesSize * 0.20, //  |  /
			0.0, piecesSize * 0.20,               //  |_/
			0.0, piecesSize * 0.04,               // 4  3
		];
		this.indices = [
			0, 1, 2,  // No way I draw this
			0, 2, 5,  // in ASCII :-)
			2, 3, 5,
			3, 4, 5
		];
		// @formatter:on
		// Corners
		// TOP LEFT
		this.clear(); // destroy all children
		this.topLeft = new Mesh();
		this.topLeft.color = this.color;
		this.topLeft.vertices = this.vertices;
		this.topLeft.indices = this.indices;
		this.topLeft.pos(0, 0);
		this.add(this.topLeft);

		// BOTTOM LEFT
		this.bottomLeft = new Mesh();
		this.bottomLeft.color = this.color;
		this.bottomLeft.vertices = this.vertices;
		this.bottomLeft.indices = this.indices;
		this.bottomLeft.pos(this.width, 0);
		this.bottomLeft.rotation = 90;
		this.add(this.bottomLeft);

		// TOP RIGHT
		this.topRight = new Mesh();
		this.topRight.color = this.color;
		this.topRight.vertices = this.vertices;
		this.topRight.indices = this.indices;
		this.topRight.pos(0, this.height);
		this.topRight.rotation = -90;
		this.add(this.topRight);

		// BOTTOM RIGHT
		this.bottomRight = new Mesh();
		this.bottomRight.color = this.color;
		this.bottomRight.vertices = this.vertices;
		this.bottomRight.indices = this.indices;
		this.bottomRight.pos(this.width, this.height);
		this.bottomRight.rotation = 180;
		this.add(this.bottomRight);

		super.computeContent();
	}
}
