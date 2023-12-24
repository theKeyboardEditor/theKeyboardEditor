package;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Text;

// import haxe.ui.backend.ceramic.RoundedRect;
class LabelRenderer extends Visual {
	// TODO make one of this two values a shade of the other
	public var labelColor: Int = 0xff0C0C0C;
	public var sublabelColor: Int = 0xff0C0C0C;
	//	public var labelFont: Int;
	public var labelFontSize: Float;
	public var labelPositionX: Float = 0;
	public var labelPositionY: Float = 0;
	public var labelGlyph: String = '|Empty|';

	// we are in the 1U = 100 units of scale ratio here:
	public var topX: Float = 12;
	public var topY: Float = 12 * .25; // North top vs E/W ratio
	public var topOffset: Float = 12 * 2; // the top island offset

	override public function new(glyph: String) {
		super();
		size(width, height);
		this.labelGlyph = glyph;
	}

	public function create(): Visual {
		final label = new Text();
		label.content = this.labelGlyph;
		label.align = LEFT;
		label.color = this.labelColor;
		label.pointSize = this.labelFontSize;
		label.pos(this.labelPositionX, this.labelPositionY);
		this.add(label);

		return this;
	}
}
