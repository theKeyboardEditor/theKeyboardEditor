package keys;

import ceramic.Arc;
import ceramic.Quad;
import ceramic.Border;
import ceramic.Color;
import ceramic.Visual;
import ceramic.TouchInfo;
import haxe.ui.backend.ceramic.RoundedRect;

class LShapeKey extends KeyRenderer {
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC; //defaults

	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 100 / 8;
	var topY: Float = (100 / 8) * 0.25;
	var topOffset: Float = (100 / 8) * 2;
	var roundedCorner: Float = (100 / 8);

	var widthNorth: Float; // North is the further away member of the pair
	var heightNorth: Float;
	var widthSouth: Float; // South is the closer member of the piar
	var heightSouth: Float;

	var arcPosTopX: Float;
	var arcPosTopY: Float;
	var offsetSouthX: Float; // The closer member's offset
	var offsetSouthY: Float;

	var arcPosX: Array<Float>;
	var arcPosY: Array<Float>;
	var arcTopPosX: Array<Float>;
	var arcTopPosY: Array<Float>;
	var arcRotation: Array<Int>;
	var arcBorderPosition: Array<Bool>;

	override public function new(widthNorth: Float, heightNorth: Float, topColor: Int, bodyColor: Int,
			widthSouth: Float, heightSouth: Float, offsetSouthX: Float, offsetSouthY: Float) {
		super();
		this.widthNorth = widthNorth;
		this.heightNorth = heightNorth;
		this.widthSouth = widthSouth;
		this.heightSouth = heightSouth;
		this.offsetSouthX = offsetSouthX;
		this.offsetSouthY = offsetSouthY;
		this.topColor = topColor;
		this.bodyColor = bodyColor;

		// here we proccess how the inner radius alone is to be oriented and positioned
		if (offsetSouthX < 0) { // is the 2nd member Westward from the top member?
			// Yes, here we assume it's a BAE situation
			size(widthSouth, heightNorth);
			if (offsetSouthY < 99) { // is the member northward in the shape?
				// Yes, inverted BAE
				this.arcPosX = [
					offsetSouthX + roundedCorner,
					widthNorth - roundedCorner,
					widthNorth - roundedCorner,
					widthSouth + roundedCorner,
					widthSouth + offsetSouthX - roundedCorner,
					offsetSouthX + roundedCorner
				];
				this.arcPosY = [
					roundedCorner,
					roundedCorner,
					heightNorth - roundedCorner,
					heightNorth + roundedCorner,
					heightSouth - roundedCorner,
					heightSouth - roundedCorner
				];
				this.arcTopPosX = [
					topX + offsetSouthX + roundedCorner,
					topX + widthNorth - this.topOffset - roundedCorner,
					topX + widthNorth - this.topOffset - roundedCorner,
					topX + widthSouth - this.topOffset + roundedCorner,
					topX + widthSouth - this.topOffset + offsetSouthX - roundedCorner,
					topX + offsetSouthX + roundedCorner
				];
				this.arcTopPosY = [
					topY + roundedCorner,
					topY + roundedCorner,
					topY + heightNorth - this.topOffset - roundedCorner,
					topY + heightNorth - this.topOffset + roundedCorner,
					topY + heightSouth - this.topOffset - roundedCorner,
					topY + heightSouth - this.topOffset - roundedCorner
				];
				this.arcRotation = [-90, 0, 90, -90, 90, 180];
				this.arcBorderPosition = [true, true, true, false, true, true];
			} else {
				// No, upright BAE
				this.arcPosX = [
					roundedCorner,
					widthNorth - roundedCorner,
					widthNorth - roundedCorner,
					offsetSouthX + roundedCorner,
					offsetSouthX + roundedCorner,
					-roundedCorner,
				];
				this.arcPosY = [
					roundedCorner,
					roundedCorner,
					heightNorth - roundedCorner,
					heightNorth - roundedCorner,
					offsetSouthY + roundedCorner,
					offsetSouthY - roundedCorner
				];
				this.arcTopPosX = [
					topX + roundedCorner,
					topX + widthNorth - this.topOffset - roundedCorner,
					topX + widthNorth - this.topOffset - roundedCorner,
					topX + offsetSouthX + roundedCorner,
					topX + offsetSouthX + roundedCorner,
					topX - roundedCorner,
				];
				this.arcTopPosY = [
					topY + roundedCorner,
					topY + roundedCorner,
					topY + heightNorth - this.topOffset - roundedCorner,
					topY + heightNorth - this.topOffset - roundedCorner,
					topY + offsetSouthY + roundedCorner,
					topY + offsetSouthY - roundedCorner
				];
				this.arcRotation = [-90, 0, 90, 180, -90, 90];
				this.arcBorderPosition = [true, true, true, true, true, false];
			}
		} else { // No, the 2nd member is aligned with or Eastward of the member:
			// we assume it's an ISO situation
			size(widthNorth, heightSouth);
			if (offsetSouthY > 99) { // Is the 2nd member Southward in the shape?
				// Yes, inverted ISO
				this.arcPosX = [
					roundedCorner,
					widthNorth - roundedCorner,
					widthNorth + roundedCorner,
					widthSouth - roundedCorner,
					roundedCorner,
					widthSouth - roundedCorner,
				];
				this.arcPosY = [
					roundedCorner,
					roundedCorner,
					offsetSouthY - roundedCorner,
					offsetSouthY + roundedCorner,
					heightNorth - roundedCorner,
					heightNorth - roundedCorner
				];
				this.arcTopPosX = [
					topX + roundedCorner,
					topX + widthNorth - this.topOffset - roundedCorner,
					topX + widthNorth - this.topOffset + roundedCorner,
					topX + widthSouth - this.topOffset - roundedCorner,
					topX + roundedCorner,
					topX + widthSouth - this.topOffset - roundedCorner,
				];
				this.arcTopPosY = [
					topY + roundedCorner,
					topY + roundedCorner,
					topY + offsetSouthY - roundedCorner,
					topY + offsetSouthY + roundedCorner,
					topY + heightNorth - this.topOffset - roundedCorner,
					topY + heightNorth - this.topOffset - roundedCorner
				];
				this.arcRotation = [-90, 0, 180, 0, 180, 90];
				this.arcBorderPosition = [true, true, false, true, true, true];
			} else {
				// No, upright ISO
				this.arcPosX = [
					roundedCorner,
					width - roundedCorner,
					roundedCorner,
					roundedCorner,
					roundedCorner + offsetSouthX,
					width - roundedCorner
				];
				this.arcPosY = [
					roundedCorner,
					roundedCorner,
					heightNorth - roundedCorner,
					heightNorth + roundedCorner,
					heightSouth - roundedCorner,
					heightSouth - roundedCorner
				];
				this.arcTopPosX = [
					topX + roundedCorner,
					topX + widthNorth - this.topOffset - roundedCorner,
					topX + roundedCorner,
					topX + roundedCorner,
					topX + roundedCorner + offsetSouthX,
					topX + widthNorth - this.topOffset - roundedCorner
				];
				this.arcTopPosY = [
					topY + roundedCorner,
					topY + roundedCorner,
					topY + heightNorth - this.topOffset - roundedCorner,
					topY + heightNorth - this.topOffset + roundedCorner,
					topY + heightSouth - this.topOffset - roundedCorner,
					topY + heightSouth - this.topOffset - roundedCorner
				];
				this.arcRotation = [-90, 0, 180, 0, 180, 90];
				this.arcBorderPosition = [true, true, true, false, true, true];
			}
		}
	}

	override public function create(): Visual {
		this.border = new Border();
		if (this.offsetSouthX < 0) {
			this.border.pos(this.offsetSouthX, 0);
		} else {
			this.border.pos(0, 0);
		}
		if (this.heightNorth > this.heightSouth) {
			if (this.widthNorth > this.widthSouth) {
				this.border.size(this.widthNorth, this.heightNorth);
			} else {
				this.border.size(this.widthSouth, this.heightNorth);
			}
		} else {
			if (this.widthNorth > this.widthSouth) {
				this.border.size(this.widthNorth, this.heightSouth);
			} else {
				this.border.size(this.widthSouth, this.heightSouth);
			}
		}
		this.border.borderColor = Color.RED; // UI theme 2ndary accent color!
		this.border.borderPosition = MIDDLE;
		this.border.borderSize = 2;
		this.border.depth = 4;
		this.border.visible = false;
		this.add(this.border);

		final top = new Quad();
		top.color = topColor;
		top.depth = 2; // this is in the sense of layers
		top.pos(topX + roundedCorner, topY);
		top.size(widthNorth - this.topOffset - roundedCorner * 2, heightNorth - this.topOffset);
		this.add(top);

		final top = new Quad();
		top.color = topColor;
		top.depth = 2; // this is in the sense of layers
		top.pos(topX, topY + roundedCorner);
		top.size(widthNorth - this.topOffset, heightNorth - this.topOffset - roundedCorner * 2);
		this.add(top);

		final top = new Quad();
		top.color = topColor;
		top.depth = 2; // this is in the sense of layers
		top.pos(topX + roundedCorner + offsetSouthX, topY + offsetSouthY);
		top.size(widthSouth - this.topOffset - roundedCorner * 2, heightSouth - this.topOffset);
		this.add(top);

		final top = new Quad();
		top.color = topColor;
		top.depth = 2; // this is in the sense of layers
		top.pos(topX + offsetSouthX, topY + offsetSouthY + roundedCorner);
		top.size(widthSouth - this.topOffset, heightSouth - this.topOffset - roundedCorner * 2);
		this.add(top);

		for (i in 0...arcRotation.length) {
			final topArc = new Arc();
			topArc.color = topColor;
			topArc.radius = roundedCorner;
			// topArc.borderPosition = OUTSIDE; // how the drawn line rides the arc

			if (arcBorderPosition[i])
				topArc.borderPosition = INSIDE
			else
				topArc.borderPosition = OUTSIDE; // how the drawn line rides the arc

			topArc.angle = 90;
			topArc.depth = 3; // this is in the sense of layers
			topArc.thickness = roundedCorner;
			topArc.rotation = arcRotation[i];
			topArc.pos(arcTopPosX[i], arcTopPosY[i]);
			this.add(topArc);
		}

		for (i in 0...arcRotation.length) {
			final bottomArc = new Arc();
			bottomArc.color = bodyColor;
			bottomArc.radius = roundedCorner;
			// bottomArc.borderPosition = OUTSIDE; // how the drawn line rides the arc

			if (arcBorderPosition[i])
				bottomArc.borderPosition = INSIDE
			else
				bottomArc.borderPosition = OUTSIDE; // how the drawn line rides the arc

			bottomArc.angle = 90;
			bottomArc.depth = 1; // this is in the sense of layers
			bottomArc.thickness = roundedCorner;
			bottomArc.rotation = arcRotation[i];
			bottomArc.pos(arcPosX[i], arcPosY[i]);
			this.add(bottomArc);
		}

		final bottom = new Quad();
		bottom.color = bodyColor;
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(roundedCorner, 0);
		bottom.size(widthNorth - roundedCorner * 2, heightNorth);
		this.add(bottom);

		final bottom = new Quad();
		bottom.color = bodyColor;
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(0, roundedCorner);
		bottom.size(widthNorth, heightNorth - roundedCorner * 2);
		this.add(bottom);

		final bottom = new Quad();
		bottom.color = bodyColor;
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(roundedCorner + offsetSouthX, offsetSouthY);
		bottom.size(widthSouth - roundedCorner * 2, heightSouth);
		this.add(bottom);

		final bottom = new Quad();
		bottom.color = bodyColor;
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(offsetSouthX, offsetSouthY + roundedCorner);
		bottom.size(widthSouth, heightSouth - roundedCorner * 2);
		this.add(bottom);

		return this;
	}
}
