package keys;

import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class RectangularKey extends Visual implements KeyRenderer {
	public var topColor: Int = 0xffFCFCFC;
	public var bodyColor: Int = 0xFFCCCCCC;
	public var xInner: Float = 4;
	public var yInner: Float = 4 / 2;
	public var borderInner: Int = 0x00000000;
	public var thicknessInner: Int = 0;
	public var offsetInner: Float = 4 * 4;
	public var borderOuter: Int = 0xFFAAAAAA;
	public var thicknessOuter: Int = 0;
	public var unitScale: Float = 54 / 100;
	public var roundedCorner: Int = 12;

	override public function new(width: Int, height: Int) {
		super();
		size(width * unitScale, height * unitScale);
	}

	public function create(): Visual {
		final fg = new RoundedRect(this.topColor, xInner, yInner, roundedCorner * unitScale, this.width - this.offsetInner, this.height - this.offsetInner,
				this.borderInner, this.thicknessInner);
		this.add(fg);

		final bg = new RoundedRect(this.bodyColor, 0, 0, roundedCorner * unitScale, this.width, this.height, this.borderOuter, this.thicknessOuter);
		this.add(bg);

		return this;
	}
}
