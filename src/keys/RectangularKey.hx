package keys;

import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class RectangularKey extends Visual implements KeyRenderer {
	public var unitScale: Float = 54 / 100;

	// TODO make one of this two values a shade of the other
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC;

	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 12;
	var topY: Float = 12 * .25; // North top vs E/W ratio
	var topOffset: Float = 12 * 2; // the top island offset
	var roundedCorner: Int = 12;

	override public function new(width: Int, height: Int) {
		super();
		size(width, height);
	}

	public function create(): Visual {
		final top = new RoundedRect(this.topColor, 0, 0, roundedCorner, this.width - this.topOffset, this.height - this.topOffset, 0, 0);
		top.pos(topX, topY);
		this.add(top);

		final bottom = new RoundedRect(this.bodyColor, 0, 0, roundedCorner, this.width, this.height, 0, 0);
		this.add(bottom);

		this.scale(this.unitScale, this.unitScale);
		return this;
	}
}
