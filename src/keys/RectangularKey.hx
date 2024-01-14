package keys;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Border;
import ceramic.Arc;
import ceramic.Quad;
import RoundedQuad;

class RectangularKey extends KeyRenderer {
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC;

	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 100 / 8;
	var topY: Float = (100 / 8) * 0.25;
	var topOffset: Float = (100 / 8) * 2;
	var roundedCorner: Float = (100 / 8);
	var arcPosX: Array<Float>;
	var arcPosY: Array<Float>;
	var arcRotation: Array<Int>;

	override public function new(width: Float, height: Float, topColor: Int, bodyColor: Int) {
		super();
		size(width, height);
		this.topColor = topColor;
		this.bodyColor = bodyColor;
	}

	override public function create(): Visual {
		this.border = new Border();
		this.border.pos(0, 0);
		this.border.size(this.width, this.height);
		this.border.borderColor = Color.RED; // UI theme 2ndary accent color!
		this.border.borderPosition = MIDDLE;
		this.border.borderSize = 2;
		this.border.depth = 4;
		this.border.visible = false;
		this.add(this.border);


		final top = new RoundedQuad(width - this.topOffset,height - this.topOffset,roundedCorner,topColor);
		top.depth = 0; // this is in the sense of layers
		top.pos(topX, topY);
		this.add(top);

		final bottom = new RoundedQuad(width,height,roundedCorner,bodyColor);
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(0,0);
		this.add(bottom);
		return this;
	}
}
