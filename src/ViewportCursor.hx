package;

import ceramic.Quad;
import ceramic.Mesh;
import ceramic.Border;
import ceramic.Color;

class ViewportCursor extends Quad {
	override public function new(width: Float, height: Float) {

		super();
		size(width, height);
		
		this.depth = 2;
		this.color = 0x003C4BC5;
	}

}
