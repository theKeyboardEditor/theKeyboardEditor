package keys;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Border;
import ceramic.Arc;
import ceramic.Quad;
import viewport.Pivot;

class RectangularKey extends KeyRenderer {
	/**
	 * we are in the 1U = 100 units of scale ratio here:
	 * this is the preset for OEM/Cherry profile keycaps (
	 * TODO: more presets
	 */
	var topX: Float = 100 / 8;

	var topY: Float = (100 / 8) * 0.25;
	var topOffset: Float = (100 / 8) * 2;
	var roundedCorner: Float = (100 / 8);

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
		this.pivot.depth = 999; // ueber alles o/
		this.pivot.visible = false;
		this.add(this.pivot);

		final top = new RoundedQuad(width - this.topOffset, height - this.topOffset, roundedCorner, topColor);
		top.depth = 5; // this is in the sense of layers
		top.pos(topX, topY);
		this.add(top);

		final bottom = new RoundedQuad(width, height, roundedCorner, bottomColor);
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(0, 0);
		this.add(bottom);

		super.computeContent();
	}
}
