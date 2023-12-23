package keys;

import ceramic.Arc;
import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class LShapeKey extends Visual implements KeyRenderer {
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC;
	var xInner: Float = 4;
	var yInner: Float = 4 / 2;
	var borderInner: Int = 0x00000000;
	var thicknessInner: Int = 0;
	var offsetInner: Float = 4 * 4;
	var borderOuter: Int = 0xFFAAAAAA;
	var thicknessOuter: Int = 0;
	var unitScale: Float = 54 / 100;
	var roundedCorner: Int = 12;

	var widthNorth: Int;
	var heightNorth: Int;
	var widthSouth: Int;
	var heightSouth: Int;
	var arcRotation: Float;
	var arcPosX: Float;
	var arcPosY: Float;
	var arcPosXInner: Float;
	var arcPosYInner: Float;
	var offsetSouthX: Int;
	var offsetSouthY: Int;

	override public function new(widthNorth: Int, heightNorth: Int, widthSouth: Int, heightSouth: Int, offsetSouthX: Int, offsetSouthY: Int) {
		super();
		this.widthNorth = widthNorth;
		this.heightNorth = heightNorth;
		this.widthSouth = widthSouth;
		this.heightSouth = heightSouth;
		this.offsetSouthX = offsetSouthX;
		this.offsetSouthY = offsetSouthY;

		if (offsetSouthX < 0) {
			// here we assume the BAE situation (negative X offset)
			size(widthSouth * unitScale, heightNorth * unitScale);
			if (offsetSouthY < 100) {
				// Inverted BAE
				arcRotation = -90;
				arcPosX = (widthSouth + roundedCorner) * unitScale;
				arcPosY = (heightNorth + roundedCorner) * unitScale;
				arcPosXInner = xInner + widthSouth * unitScale - roundedCorner * unitScale;
				arcPosYInner = yInner / 2 + heightNorth * unitScale - roundedCorner * unitScale;
			} else {
				// Upright BAE
				arcRotation = 90;
				arcPosX = -1 * roundedCorner * unitScale;
				arcPosY = (offsetSouthY - roundedCorner) * unitScale;
				arcPosXInner = 2 * xInner - roundedCorner * unitScale;
				arcPosYInner = 2 * yInner + offsetSouthY * unitScale - roundedCorner * unitScale;
			}
		} else {
			// here we assume the ISO situation (positive X offset)
			size(widthNorth * unitScale, heightSouth * unitScale);
			if (offsetSouthY > 100) {
				// Inverted ISO
				arcRotation = 180;
				arcPosX = (widthNorth + roundedCorner) * unitScale;
				arcPosY = (offsetSouthY - roundedCorner) * unitScale;
				arcPosXInner = 2 * xInner + roundedCorner * unitScale + (widthNorth * unitScale - offsetInner);
				arcPosYInner = 2 * yInner + offsetSouthY * unitScale - roundedCorner * unitScale;
			} else {
				// Upright ISO
				arcRotation = 0;
				arcPosX = (offsetSouthX - roundedCorner) * unitScale;
				arcPosY = (heightNorth + roundedCorner) * unitScale;
				arcPosXInner = 2 * xInner + offsetSouthX * unitScale - roundedCorner * unitScale;
				arcPosYInner = yInner / 2 + heightNorth * unitScale - roundedCorner * unitScale;
			}
		}
	}

	public function create(): Visual {
		// first draw the North portion of the keyshape
		final fg = new RoundedRect(this.topColor, xInner, yInner, roundedCorner * unitScale, widthNorth * unitScale - this.offsetInner,
			heightNorth * unitScale - this.offsetInner, this.borderInner, this.thicknessInner);
		fg.depth = 2;
		this.add(fg);

		// then draw the South portion of the keyshape
		final fg = new RoundedRect(this.topColor, xInner
			+ (offsetSouthX / 2 * unitScale), yInner
			+ offsetSouthY / 2 * unitScale, roundedCorner * unitScale,
			widthSouth * unitScale
			- this.offsetInner, heightSouth * unitScale
			- this.offsetInner, this.borderInner, this.thicknessInner);
		fg.depth = 2;
		this.add(fg);

		final arc2 = new Arc();
		arc2.color = topColor;
		arc2.radius = roundedCorner * unitScale;
		arc2.borderPosition = OUTSIDE; // how the drawn line rides the arc
		arc2.angle = 90;
		arc2.depth = 3; // this is in the sense of layers?
		arc2.thickness = roundedCorner;
		arc2.rotation = arcRotation;
		arc2.pos(arcPosXInner, arcPosYInner);
		this.add(arc2);

		final bd = new RoundedRect(this.bodyColor, 0, 0, roundedCorner * unitScale, widthNorth * unitScale, heightNorth * unitScale, this.borderOuter,
			this.thicknessOuter);
		bd.depth = 1;
		this.add(bd);
		final bd = new RoundedRect(this.bodyColor, offsetSouthX / 2 * unitScale, offsetSouthY / 2 * unitScale, roundedCorner * unitScale,
			widthSouth * unitScale, heightSouth * unitScale, this.borderOuter, this.thicknessOuter);
		bd.depth = 1;
		this.add(bd);

		final arc2 = new Arc();
		arc2.color = bodyColor;
		arc2.radius = roundedCorner * unitScale;
		arc2.borderPosition = OUTSIDE; // how the drawn line rides the arc
		arc2.angle = 90;
		arc2.depth = 2; // this is in the sense of layers?
		arc2.thickness = roundedCorner;
		arc2.rotation = arcRotation;
		arc2.pos(arcPosX, arcPosY);
		this.add(arc2);

		return this;
	}
}
