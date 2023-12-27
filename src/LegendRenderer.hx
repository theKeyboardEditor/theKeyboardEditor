package;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Text;

// import haxe.ui.backend.ceramic.RoundedRect;
class LegendRenderer extends Visual {
	// TODO make one of this two values a shade of the other
	public var color: Int = 0xff0C0C0C;
	//	public var labelFont: Int;
	public var fontSize: Float;
	public var symbol: String = '|Empty|';

	// we are in the 1U = 100 units of scale ratio here:
	public var topX: Float = 12;
	public var topY: Float = 12 * .25; // North top vs E/W ratio
	public var topOffset: Float = 12 * 2; // the top island offset

	override public function new(symbol: String) {
		super();
		size(width, height);
		this.symbol = symbol;
	}

	public function create(): Visual {
		final label = new Text();
		label.content = this.symbol;
		label.align = LEFT;
		label.color = this.color;
		label.pointSize = this.fontSize;
		this.add(label);

		return this;
	}
}
