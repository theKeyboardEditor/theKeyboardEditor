package;

import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class SquareKeyRenderer extends Visual {
	public var topColor: Int = 0xffFCFCFC;
	public var bodyColor: Int = 0xFFCCCCCC;
	public var xInner: Float = 4;
	public var yInner: Float = 4 / 2;
	public var borderInner: Int = 0x00000000;
	public var thicknessInner: Int = 0;
	public var offsetInner: Float = 4 * 4;
	public var borderOuter: Int = 0xFFAAAAAA;
	public var thicknessOuter: Int = 0;
	public var scaleTo: Float = 54 / 100;
	public var roundedCorner: Int = 12;

	override public function new(width: Int, height: Int) {
		super();
		size(width * scaleTo, height * scaleTo);

		// public function new(color:Color, x:Float, y:Float, radius:Float, w:Float, h:Float, border:Color = Color.NONE, thickness:Int = 1)
		final fg = new RoundedRect(this.topColor, xInner, yInner, roundedCorner * scaleTo, this.width - this.offsetInner, this.height - this.offsetInner, this.borderInner,
			this.thicknessInner);
		this.add(fg);

		final bg = new RoundedRect(this.bodyColor, 0, 0, roundedCorner * scaleTo, this.width, this.height, this.borderOuter, this.thicknessOuter);
		this.add(bg);
	}
}
