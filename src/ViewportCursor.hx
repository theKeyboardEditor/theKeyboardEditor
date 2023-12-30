package;

import ceramic.Quad;

class ViewportCursor extends Quad {
	override public function new(width: Float, height: Float) {
		super();
		size(width, height);
		this.depth = 3;
		this.color = 0xF83C4BC5;
	}
}
