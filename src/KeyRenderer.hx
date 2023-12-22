package;

import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class KeyRenderer extends Visual {
	public var color1: Int;
	public var color2: Int;
	public var xInner: Float;
	public var yInner: Float;
	public var rInner: Float;
	public var borderInner: Int;
	public var thicknessInner: Int;
	public var offsetInner: Float;
	public var xOuter: Float;
	public var yOuter: Float;
	public var rOuter: Float;
	public var borderOuter: Int;
	public var thicknessOuter: Int;
	public var scaleTo: Float;
	public var sizeX: Float;
	public var sizeY: Float;
	var scaledX: Float;
	var scaledY: Float;
	
	override public function new() {
		super();


		color1 = 0xffFCFCFC;
		color2 = 0xffCCCCCC;
		xInner = 3;
		yInner = xInner / 2;
		rInner = 7;
		borderInner = 0x00000000;
		thicknessInner = 1;
		offsetInner = xInner * 4;
		xOuter = 0;
		yOuter = 0;
		rOuter = 7;
		borderOuter = 0xFFAAAAAA;
		thicknessOuter = 1;
//		scaleTo = 54 / 100;
//		sizeX = 100;
//		sizeY = 100;
scaledX= this.sizeX * this.scaleTo;
scaledY= this.sizeY * this.scaleTo;
		size(scaledX, scaledY);

		trace("Renderer>>>h/w:",height,width,"sizes",this.sizeX,this.sizeY,"scale",this.scaledX,this.scaledY);

		// public function new(color:Color, x:Float, y:Float, radius:Float, w:Float, h:Float, border:Color = Color.NONE, thickness:Int = 1)
		final fg = new RoundedRect(this.color1, this.xInner, this.yInner, this.rInner, this.sizeX * this.scaleTo - this.offsetInner, this.sizeY * this.scaleTo - this.offsetInner, this.borderInner, this.thicknessInner);
		this.add(fg);
		
		final bg = new RoundedRect(this.color2, this.xOuter, this.yOuter, this.rOuter, this.sizeX * this.scaleTo, this.sizeY * this.scaleTo, this.borderOuter, this.thicknessOuter);
		this.add(bg);
	}
}
