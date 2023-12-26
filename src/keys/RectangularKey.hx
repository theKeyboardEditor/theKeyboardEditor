package keys;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Border;
import ceramic.TouchInfo;
import haxe.ui.backend.ceramic.RoundedRect;

class RectangularKey extends Visual implements KeyRenderer {
	// TODO make one of this two values a shade of the other
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC;
	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 12;
	var topY: Float = 12 * .25; // North top vs E/W ratio
	var topOffset: Float = 12 * 2; // the top island offset
	var roundedCorner: Float = 12;

	override public function new(width: Float, height: Float) {
		super();
		size(width, height);
	}

	public function create(): Visual {
		var top = new RoundedRect(this.topColor, 0, 0, roundedCorner, this.width - this.topOffset, this.height - this.topOffset, 0, 0);

		top.pos(topX, topY);
		this.add(top);

		final bottom = new RoundedRect(this.bodyColor, 0, 0, roundedCorner, this.width, this.height, 0, 0);
		this.add(bottom);

		return this;
	}


    public function select(_: TouchInfo) {
        final border = new Border();
        border.pos(0, 0);
        border.size(this.width, this.height);
        border.borderColor = Color.RED;
        border.borderPosition = OUTSIDE;
        border.borderSize = 2;
        border.depth = 4;
        this.add(border);
    }
}
