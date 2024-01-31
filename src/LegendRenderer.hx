package;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Text;

// import haxe.ui.backend.ceramic.RoundedRect;
class LegendRenderer extends Visual {
	public var color: Color = 0xffFF0000; // gray default
	//	public var legendFont: Int;  // TODO custom fonts
	public var fontSize: Float;
	public var legend: String = '|Empty|';

	// we are in the 1U = 100 units of scale ratio here:
	public var topX: Float = (100 / 8);
	public var topY: Float = (100 / 8) * .25; // North top vs E/W ratio

	override public function new(legend: String, color: Color) {
		super();
		size(width, height);
		this.legend = legend;
		this.color = color;
	}

	public function create(): Visual {
		final symbol = new Text();
		symbol.content = this.legend;
		// TODO use font
		symbol.align = LEFT;
		symbol.color = this.color;
		symbol.pointSize = this.fontSize;
		this.add(symbol);

		return this;
	}
}
