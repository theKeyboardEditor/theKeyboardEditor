package;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Text;

class LegendRenderer extends Visual {
	@content public var color: Int = 0xffFF0000; // gray default
	//	public var legendFont: String;  // TODO custom fonts
	@content public var fontSize: Float;
	@content public var content: String = '|Empty|';

	// we are in the 1U = 100 units of scale ratio here:
	public var topX: Float = (100 / 8);
	public var topY: Float = (100 / 8) * .25; // North top vs E/W ratio

	override public function computeContent() {
		this.clear();
		final legend = new Text();
		legend.content = this.content;
		// TODO use custom font
		legend.align = LEFT;
		legend.color = this.color;
		legend.pointSize = this.fontSize;
		legend.depth = 50;
		this.add(legend);

		super.computeContent();
	}
}
