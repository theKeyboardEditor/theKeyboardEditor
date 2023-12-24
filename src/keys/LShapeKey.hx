package keys;

import ceramic.Arc;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class LShapeKey extends Visual implements KeyRenderer {
	// TODO make one of this two values a shade of the other
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC;
	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 12;
	var topY: Float = 12 * 0.25;
	var topOffset: Float = 12 * 2;
	var roundedCorner: Float = 12;

	var widthNorth: Int; // North is the further away member of the pair
	var heightNorth: Int;
	var widthSouth: Int; // South is the closer member of the piar
	var heightSouth: Int;
	var arcRotation: Float; // The radius of the inside corner
	var arcPosX: Float;
	var arcPosY: Float;
	var arcPosTopX: Float;
	var arcPosTopY: Float;
	var offsetSouthX: Int; // The closer member's offset
	var offsetSouthY: Int;

	override public function new(widthNorth: Int, heightNorth: Int, widthSouth: Int, heightSouth: Int, offsetSouthX: Int, offsetSouthY: Int) {
		super();
		this.widthNorth = widthNorth;
		this.heightNorth = heightNorth;
		this.widthSouth = widthSouth;
		this.heightSouth = heightSouth;
		this.offsetSouthX = offsetSouthX;
		this.offsetSouthY = offsetSouthY;

		// here we proccess how the inner radius alone is to be oriented and positioned
		if (offsetSouthX < 0) { // is the 2nd member Westward from the top member?
			// Yes, here we assume it's a BAE situation
			size(widthSouth, heightNorth);
			if (offsetSouthY < 100) { // is the member northward in the shape?
				// Yes, inverted BAE
				arcRotation = -90;
				arcPosX = widthSouth + roundedCorner;
				arcPosY = heightNorth + roundedCorner;
				arcPosTopX = topX + widthSouth - roundedCorner;
				arcPosTopY = topY + heightNorth - roundedCorner;
			} else {
				// No, upright BAE
				arcRotation = 90;
				arcPosX = -1 * roundedCorner;
				arcPosY = offsetSouthY - roundedCorner;
				arcPosTopX = topX - roundedCorner;
				arcPosTopY = topY + offsetSouthY - roundedCorner;
			}
		} else { // No, the 2nd member is aligned with or Eastward of the member:
			// we assume it's an ISO situation
			size(widthNorth, heightSouth);
			if (offsetSouthY > 100) { // Is the 2nd member Southward in the shape?
				// Yes, inverted ISO
				arcRotation = 180;
				arcPosX = widthNorth + roundedCorner;
				arcPosY = offsetSouthY - roundedCorner;
				arcPosTopX = topX + roundedCorner + (widthNorth - topOffset);
				arcPosTopY = topY + offsetSouthY - roundedCorner;
			} else {
				// No, upright ISO
				arcRotation = 0;
				arcPosX = offsetSouthX - roundedCorner;
				arcPosY = heightNorth + roundedCorner;
				arcPosTopX = topX + offsetSouthX - roundedCorner;
				arcPosTopY = topY + heightNorth - roundedCorner;
			}
		}
	}

	public function create(): Visual {
		// first draw the North member of the keyshape
		final top = new RoundedRect(this.topColor, 0, 0, roundedCorner, widthNorth - this.topOffset, heightNorth - this.topOffset, 0, 0);
		top.pos(topX, topY);
		top.depth = 2;
		this.add(top);

		// then draw the South member of the keyshape
		final top = new RoundedRect(this.topColor, 0, 0, roundedCorner, widthSouth - this.topOffset, heightSouth - this.topOffset, 0, 0);
		top.pos(topX + offsetSouthX, topY + offsetSouthY);
		top.depth = 2;
		this.add(top);

		final topArc = new Arc();
		topArc.color = topColor;
		topArc.radius = roundedCorner;
		topArc.borderPosition = OUTSIDE; // how the drawn line rides the arc
		topArc.angle = 90;
		topArc.depth = 3; // this is in the sense of layers
		topArc.thickness = roundedCorner; // with this thickness we cover the underlying sharp corner
		topArc.rotation = arcRotation;
		topArc.pos(arcPosTopX, arcPosTopY);
		this.add(topArc);

		final bottom = new RoundedRect(this.bodyColor, 0, 0, roundedCorner, widthNorth, heightNorth, 0, 0);
		bottom.depth = 1;
		this.add(bottom);

		final bottom = new RoundedRect(this.bodyColor, 0, 0, roundedCorner, widthSouth, heightSouth, 0, 0);
		bottom.pos(offsetSouthX, offsetSouthY);
		bottom.depth = 1;
		this.add(bottom);

		final bottomArc = new Arc();
		bottomArc.color = bodyColor;
		bottomArc.radius = roundedCorner;
		bottomArc.borderPosition = OUTSIDE; // how the drawn line rides the arc
		bottomArc.angle = 90;
		bottomArc.depth = 2; // this is in the sense of layers
		bottomArc.thickness = roundedCorner;
		bottomArc.rotation = arcRotation;
		bottomArc.pos(arcPosX, arcPosY);
		this.add(bottomArc);

		return this;
	}
}
