package;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Text;

// import haxe.ui.backend.ceramic.RoundedRect;
class LegendRenderer extends Visual {
	// TODO make one of this two values a shade of the other
	public var color: Int = 0xffFF0000;
	//	public var legendFont: Int;
	public var fontSize: Float;
	public var symbol: String = '|Empty|';

	// we are in the 1U = 100 units of scale ratio here:
	public var topX: Float = 12;
	public var topY: Float = 12 * .25; // North top vs E/W ratio

	override public function new(symbol: String, color: Int) {
		super();
		size(width, height);
		this.symbol = symbol;
		this.color = color;
	}

	public function create(): Visual {
		final legend = new Text();
		legend.content = this.symbol;
		legend.align = LEFT;
		legend.color = this.color;
		legend.pointSize = this.fontSize;
		this.add(legend);

		return this;
	}
}
