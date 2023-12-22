package;

import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

var color1:Int;
var color2:Int;
var xInner:Float;
var yInner:Float;
var rInner:Float;
var borderInner:Int;
var thicknessInner:Int;
var offsetInner:Float;
var xOuter:Float;
var yOuter:Float;
var rOuter:Float;
var borderOuter:Int;
var thicknessOuter:Int;
var scaleTo:Float;
var sizeX:Int;
var SizeY:Int;

class KeyRenderer extends Visual {
	override public function new() {
		super();
		
		color1= 0xffFCFCFC;
		color2= 0xffCCCCCC;
		xInner= 3;
		yInner= xInner/2;
		rInner= 7;
		borderInner= 0x00000000;
		thicknessInner =1;
		offsetInner=xInner*4;
		xOuter= 0;
		yOuter= 0;
		rOuter= 7;
		borderOuter= 0x00000000;
		thicknessOuter= 1;
		
		scaleTo= 54/100;
		sizeX=100;
		SizeY=200;
		
		size(sizeX*scaleTo,SizeY*scaleTo);
		
		
// public function new(color:Color, x:Float, y:Float, radius:Float, w:Float, h:Float, border:Color = Color.NONE, thickness:Int = 1)
		final fg = new RoundedRect(color1, xInner, yInner, rInner, this.width - offsetInner, this.height - offsetInner, borderInner, thicknessInner);
		this.add(fg);

		final bg = new RoundedRect(color2, xOuter, yOuter, rOuter, this.width, this.height, borderOuter, thicknessOuter);
		this.add(bg);
	}
}
