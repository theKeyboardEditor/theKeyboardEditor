package keys;

import ceramic.Border;
import ceramic.RoundedRect;
import viewport.Pivot;

class RectangularKey extends KeyRenderer {
	/**
	 * we are in the 1U = 100 units of scale ratio here:
	 * this is the preset for OEM/Cherry profile keycaps (
	 * TODO: more presets
	 */
	var topX: Float = 100 / 8;
	var topY: Float = (100 / 8) * 0.25;
	final topOffset: Float = (100 / 8) * 2;
	final roundedCorner: Float = 100 / 8;

	override public function computeContent() {
		this.border = new Border();
		this.border.pos(0, 0);
		this.border.size(this.width, this.height);
		this.border.borderColor = 0xFFB13E53; // sweetie-16 red (UI theme 2ndary accent color!)
		this.border.borderPosition = MIDDLE;
		this.border.borderSize = 2;
		this.border.depth = 4;
		this.border.visible = false;
		this.add(this.border);

		this.pivot = new Pivot();
		this.pivot.pos(0, 0);
		this.pivot.depth = 500; // ueber alles o/
		this.pivot.visible = false;
		this.add(this.pivot);

		final top = new RoundedRect();
		top.size(width - this.topOffset, height - this.topOffset);
		top.radius(roundedCorner);
		top.color = topColor;
		top.depth = 5;
		top.pos(topX, topY);
		this.add(top);

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
