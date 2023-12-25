package keys;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Border;
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
	var selected: Bool = false;

	override public function new(width: Float, height: Float, selected: Bool) {
		super();
		size(width, height);
		this.selected = selected;
	}

	public function create(): Visual {

		var top = new RoundedRect(this.topColor, 0, 0, roundedCorner, this.width - this.topOffset, this.height - this.topOffset, 0, 0);


		top.pos(topX, topY);
		this.add(top);

		final bottom = new RoundedRect(this.bodyColor, 0, 0, roundedCorner, this.width, this.height, 0, 0);
		this.add(bottom);

		
		if (this.selected) {
			final select = new Border();
			select.pos (0,0);
			select.size(this.width,this.height);
			select.borderColor = Color.RED;
			select.borderPosition = OUTSIDE;
			select.borderSize = 2;
			select.depth = 4;
			this.add(select);
		}

		return this;
	}
}
