package;

import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class KeyRenderer extends Visual {
	public var fgColor: Int = 0xffFCFCFC;
	public var bgColor: Int = 0xFFCCCCCC;
	public var xInner: Float = 3;
	public var yInner: Float = 3 / 2;
	public var borderInner: Int = 0x00000000;
	public var thicknessInner: Int = 1;
	public var offsetInner: Float = 3 * 4;
	public var borderOuter: Int = 0xFFAAAAAA;
	public var thicknessOuter: Int = 1;
	public var scaleTo: Float = 54 / 100;

	override public function new(width: Int, height: Int) {
		super();
		size(width * scaleTo, height * scaleTo);

		// public function new(color:Color, x:Float, y:Float, radius:Float, w:Float, h:Float, border:Color = Color.NONE, thickness:Int = 1)
		final fg = new RoundedRect(this.fgColor, xInner, yInner, 7, this.width - this.offsetInner,
			this.height - this.offsetInner, this.borderInner, this.thicknessInner);
		this.add(fg);

		final bg = new RoundedRect(this.bgColor, 0, 0, 7, this.width, this.height, this.borderOuter, this.thicknessOuter);
		this.add(bg);
	}
}
