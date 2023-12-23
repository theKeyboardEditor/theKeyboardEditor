package;

import ceramic.Arc;
import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class HookedKeyRenderer extends Visual {
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
	var arcRotation: Float;
	var arcPosX: Float;
	var arcPosY: Float;
	var arcPosXinner: Float;
	var arcPosYinner: Float;
	var overalX = Float;
	var overalY = Float;
	var offsetX2 = Int;
	var offsetY2 = Int;

	override public function new(width1: Int, height1: Int, width2: Int, height2: Int, offsetX2: Int, offsetY2: Int) {
		super();
		
		switch (offsetX2 < 0) {
			case true:
			trace("BAE");
			//here we assume the BAE situation (negative X offset)
			size(width2 * scaleTo, height1 * scaleTo);
			if ( offsetY2 < 100 ) {
				trace("inverted BAE!");
				arcRotation =-90;
				arcPosX=(width2 + roundedCorner) * scaleTo;
				arcPosY=(height1 + roundedCorner) * scaleTo;
				arcPosXinner=xInner + width2 * scaleTo - roundedCorner * scaleTo;
				arcPosYinner=yInner/2 + height1 * scaleTo - roundedCorner * scaleTo;
			} else {
				trace("upright BAE!");
				arcRotation =90;
				arcPosX=-1 * roundedCorner * scaleTo;
				arcPosY=(offsetY2 - roundedCorner ) * scaleTo;
				arcPosXinner=2*xInner - roundedCorner * scaleTo;
				arcPosYinner=2*yInner + offsetY2 * scaleTo - roundedCorner * scaleTo;
			}
		case other:
		trace ("ISO");
			//here we assume the ISO situation (positive X offset)
			size(width1 * scaleTo, height2 * scaleTo);
			if ( offsetY2 > 100 ) {
				trace("inverted ISO!");
				arcRotation =180;
				arcPosX=(width1 + roundedCorner) * scaleTo;
				arcPosY=(offsetY2 - roundedCorner) * scaleTo;
				arcPosXinner=2*xInner + roundedCorner * scaleTo + (width1 * scaleTo - offsetInner);
				arcPosYinner=2*yInner + offsetY2 * scaleTo - roundedCorner * scaleTo;
			} else {
				trace("upright ISO!");
				arcRotation =0;
				arcPosX=(offsetX2 - roundedCorner) * scaleTo;
				arcPosY=(height1 + roundedCorner) * scaleTo;
				arcPosXinner=2*xInner + offsetX2 * scaleTo - roundedCorner * scaleTo;
				arcPosYinner=yInner/2 + height1 * scaleTo - roundedCorner * scaleTo;
			}
		}

		// first draw the North portion of the keyshape
		final fg = new RoundedRect(this.topColor, xInner, yInner, roundedCorner * scaleTo, width1 * scaleTo - this.offsetInner, height1 * scaleTo - this.offsetInner, this.borderInner, this.thicknessInner);
		fg.depth=2;
		this.add(fg);
		// then draw the South portion of the keyshape
		final fg = new RoundedRect(this.topColor, xInner + (offsetX2 /2 * scaleTo) , yInner + offsetY2 /2 * scaleTo, roundedCorner * scaleTo, width2 * scaleTo - this.offsetInner, height2 * scaleTo - this.offsetInner, this.borderInner, this.thicknessInner);
		fg.depth=2;
		this.add(fg);

		final arc2 = new Arc ();
		arc2.color= topColor;
		arc2.radius=roundedCorner * scaleTo;
		arc2.borderPosition=OUTSIDE; //how the drawn line rides the arc
		arc2.angle=90;
		arc2.depth=3; // this is in the sense of layers?
		arc2.thickness= roundedCorner;
		arc2.rotation= arcRotation;
		arc2.pos (arcPosXinner,arcPosYinner);
		this.add(arc2);

		final bd = new RoundedRect(this.bodyColor, 0, 0, roundedCorner * scaleTo, width1 * scaleTo, height1 * scaleTo, this.borderOuter, this.thicknessOuter);
		bd.depth=1;
		this.add(bd);
		final bd = new RoundedRect(this.bodyColor, offsetX2 /2 * scaleTo, offsetY2 /2 * scaleTo, roundedCorner * scaleTo, width2 * scaleTo, height2 * scaleTo, this.borderOuter, this.thicknessOuter);
		bd.depth=1;
		this.add(bd);

		final arc2 = new Arc ();
		arc2.color= bodyColor;
		arc2.radius=roundedCorner * scaleTo;
		arc2.borderPosition=OUTSIDE; //how the drawn line rides the arc
		arc2.angle=90;
		arc2.depth=2; // this is in the sense of layers?
		arc2.thickness= roundedCorner;
		arc2.rotation= arcRotation;
		arc2.pos (arcPosX,arcPosY);
		this.add(arc2);

	}
}
