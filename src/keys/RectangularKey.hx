package keys;

import ceramic.Border;
import ceramic.RoundedRect;
import viewport.visuals.Pivot;

class RectangularKey extends Keycap {
	/**
	 * we are in the 1U = 100 units of scale ratio here:
	 * this is the preset for OEM/Cherry profile keycaps (
	 * TODO: more presets
	 */
	var topX: Float = 100 / 8;
	var topY: Float = (100 / 8) * 0.25;

	static inline var topOffset: Float = (100 / 8) * 2;
	static inline var roundedCorner: Float = 100 / 8;

	var top: RoundedRect;
	var bottom: RoundedRect;
	var selected: Bool = false;

	override public function computeContent() {
		// on recompute we clear old obsolete shapes
		if (this.border != null) {
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

		if (this.top != null)
			this.top.destroy();
		final top = new RoundedRect();
		top.size(width - topOffset, height - topOffset);
		top.radius(roundedCorner);
		top.color = topColor;
		top.depth = 5;
		top.pos(topX, topY);
		this.add(top);

		if (this.bottom != null)
			this.bottom.destroy();
		final bottom = new RoundedRect();
		bottom.size(width, height);
		bottom.radius(roundedCorner);
		bottom.color = bottomColor;
		bottom.depth = 0;
		bottom.pos(0, 0);
		this.add(bottom);

		super.computeContent();
	}
}
