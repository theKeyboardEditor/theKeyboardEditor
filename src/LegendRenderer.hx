package;

import ceramic.Border;
import ceramic.Color;
import ceramic.Visual;
import ceramic.Text;
import viewport.Pivot;

class LegendRenderer extends Visual {
	@content public var color: Int = 0xffFF0000; // gray default
	//	public var legendFont: String;  // TODO custom fonts
	@content public var fontSize: Float;
	@content public var content: String = '|Empty|';

	public var border: ceramic.Border;
	@content public var pivot: viewport.Pivot;

	var selected: Bool = false;

	// we are in the 1U = 100 units of scale ratio here:
	public var topX: Float = (100 / 8);
	public var topY: Float = (100 / 8) * .25; // North top vs E/W ratio

	public function select() {
		border.visible = true;
		pivot.visible = true;
	}

	// explicit deselection is sometimes unavoidable
	public function deselect() {
		border.visible = false;
		pivot.visible = false;
	}

	override public function computeContent() {
		this.clear();
		// on recompute we clear old obsolete shapes
		if (this.border != null) {
			if (this.selected != null)
				this.selected = this.border.visible;
			this.border.destroy();
		}
		this.border = new Border();
		this.border.pos(0, 0);
		this.border.size(this.width, this.height);
		this.border.borderColor = 0xFFB13E53; // sweetie-16 red (UI theme 2ndary accent color!)
		this.border.borderPosition = MIDDLE;
		this.border.borderSize = 2;
		this.border.depth = 10;
		this.border.visible = this.selected;
		this.add(this.border);

		if (this.pivot != null)
			this.pivot.destroy();
		this.pivot = new Pivot();
		this.pivot.pos(0, 0);
		this.pivot.depth = 500; // ueber alles o/
		this.pivot.visible = this.selected;
		this.add(this.pivot);

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
