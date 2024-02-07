package keys;

import ceramic.Border;
import ceramic.RoundedRect;
import viewport.Pivot;

class SteppedKey extends KeyRenderer {
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
		top.size(Std.int(this.stepWidth - this.topOffset), Std.int(this.stepHeight - this.topOffset));
		top.radius(roundedCorner);
		top.color = topColor;
		top.depth = 5;
		top.pos(this.stepOffsetX + topX, this.stepOffsetY + topY);
		this.add(top);

		final sides = new RoundedRect();
		sides.size(Std.int(this.stepWidth - topX / 4), Std.int(this.stepHeight - topX / 4));
		sides.radius(roundedCorner);
		sides.color = bottomColor;
		sides.depth = 4;
		sides.pos(this.stepOffsetX + topX / 4, this.stepOffsetY + topY / 4);
		this.add(sides);

		final stepTop = new RoundedRect();
		stepTop.size(Std.int(width - this.topOffset / 4), Std.int(height - this.topOffset / 4));
		stepTop.radius(roundedCorner);
		stepTop.color = topColor;
		stepTop.depth = 1;
		stepTop.pos(this.topX / 4, this.topY / 4);
		this.add(stepTop);

		// same as rectangular key
		final bottom = new RoundedRect();
		bottom.size(Std.int(width), Std.int(height));
		bottom.radius(roundedCorner);
		bottom.color = bottomColor;
		bottom.depth = 0;
		bottom.pos(0, 0);
		this.add(bottom);

		super.computeContent();
	}
}
