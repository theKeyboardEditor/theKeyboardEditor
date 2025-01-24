package keys;

import ceramic.Border;
import ceramic.RoundedRect;
import viewport.visuals.Pivot;

class SteppedKey extends Keycap {
	/**
	 * we are in the 1U = 100 units of scale ratio here:
	 */
	@content public var stepWidth: Float;
	@content public var stepHeight: Float;
	@content public var stepOffsetX: Float;
	@content public var stepOffsetY: Float;
	@content public var stepped: Float;

	@content var topX: Float = 100 / 8; // TODO make this be actual units of 1U!
	@content var topY: Float = (100 / 8) * 0.25;
	var topOffset: Float = (100 / 8) * 2;
	var roundedCorner: Float = 100 / 8;
	var top: RoundedRect;
	var sides: RoundedRect;
	var stepTop: RoundedRect;
	var bottom: RoundedRect;
	var selected: Bool = false;

	override public function computeContent() {
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
		this.top = new RoundedRect();
		this.top.size(Std.int(this.stepWidth - this.topOffset), Std.int(this.stepHeight - this.topOffset));
		this.top.radius(roundedCorner);
		this.top.color = topColor;
		this.top.depth = 5;
		this.top.pos(this.stepOffsetX + topX, this.stepOffsetY + topY);
		this.add(this.top);

		if (this.sides != null)
			this.sides.destroy();
		this.sides = new RoundedRect();
		this.sides.size(Std.int(this.stepWidth - topX / 4), Std.int(this.stepHeight - topX / 4));
		this.sides.radius(roundedCorner);
		this.sides.color = bottomColor;
		this.sides.depth = 4;
		this.sides.pos(this.stepOffsetX + topX / 4, this.stepOffsetY + topY / 4);
		this.add(this.sides);

		if (this.stepTop != null)
			this.stepTop.destroy();
		this.stepTop = new RoundedRect();
		this.stepTop.size(Std.int(width - this.topOffset / 4), Std.int(height - this.topOffset / 4));
		this.stepTop.radius(roundedCorner);
		this.stepTop.color = topColor;
		this.stepTop.depth = 1;
		this.stepTop.pos(this.topX / 4, this.topY / 4);
		this.add(this.stepTop);

		// same as rectangular key
		if (this.bottom != null)
			this.bottom.destroy();
		this.bottom = new RoundedRect();
		this.bottom.size(Std.int(width), Std.int(height));
		this.bottom.radius(roundedCorner);
		this.bottom.color = bottomColor;
		this.bottom.depth = 0;
		this.bottom.pos(0, 0);
		this.add(this.bottom);

		super.computeContent();
	}
}
