package keys;

import ceramic.Color;
import ceramic.Visual;
import ceramic.Border;
import ceramic.Arc;
import ceramic.Quad;
import ceramic.TouchInfo;
import haxe.ui.backend.ceramic.RoundedRect;

class RectangularKey extends KeyRenderer {
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC;

	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 12;
	var topY: Float = 12 * .25; // North top vs E/W ratio
	var topOffset: Float = 12 * 2; // the top island offset
	var roundedCorner: Float = 12;
	var arcPosX: Array<Float>;
	var arcPosY: Array<Float>;
	var arcRotation: Array<Int>;

	override public function new(width: Float, height: Float, topColor: Int, bodyColor: Int) {
		super();
		size(width, height);
		this.topColor = topColor;
		this.bodyColor = bodyColor;
	}

	override public function create(): Visual {
		this.border = new Border();
		this.border.pos(0, 0);
		this.border.size(this.width, this.height);
		this.border.borderColor = Color.RED; // UI theme 2ndary accent color!
		this.border.borderPosition = MIDDLE;
		this.border.borderSize = 2;
		this.border.depth = 4;
		this.border.visible = false;
		this.add(this.border);

		this.arcPosX = [
			topX + roundedCorner,
			topX + width - this.topOffset - roundedCorner,
			topX + roundedCorner,
			topX + width - this.topOffset - roundedCorner
		];
		this.arcPosY = [
			topY + roundedCorner,
			topY + roundedCorner,
			topY + height - this.topOffset - roundedCorner,
			topY + height - this.topOffset - roundedCorner
		];
		this.arcRotation = [-90, 0, 180, 90];

		for (i in 0...4) {
			final topArc = new Arc();
			topArc.color = topColor;
			topArc.radius = roundedCorner;
			topArc.borderPosition = INSIDE; // how the drawn line rides the arc
			topArc.angle = 90;
			topArc.depth = 2; // this is in the sense of layers
			topArc.thickness = roundedCorner;
			topArc.rotation = arcRotation[i];
			topArc.pos(arcPosX[i], arcPosY[i]);
			this.add(topArc);
		}

		final top = new Quad();
		top.color = topColor;
		top.depth = 1; // this is in the sense of layers
		top.pos(topX + roundedCorner, topY);
		top.size(width - this.topOffset - roundedCorner * 2, height - this.topOffset);
		this.add(top);

		final top = new Quad();
		top.color = topColor;
		top.depth = 1; // this is in the sense of layers
		top.pos(topX, topY + roundedCorner);
		top.size(width - this.topOffset, height - this.topOffset - roundedCorner * 2);
		this.add(top);

		this.arcPosX = [
			0 + roundedCorner,
			width - roundedCorner,
			0 + roundedCorner,
			width - roundedCorner
		];
		this.arcPosY = [
			0 + roundedCorner,
			0 + roundedCorner,
			height - roundedCorner,
			height - roundedCorner
		];
		this.arcRotation = [-90, 0, 180, 90];

		for (i in 0...arcRotation.length) {
			final bottomArc = new Arc();
			bottomArc.color = bodyColor;
			bottomArc.radius = roundedCorner;
			bottomArc.borderPosition = INSIDE; // how the drawn line rides the arc
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
		bottom.size(width - roundedCorner * 2, height);
		this.add(bottom);

		final bottom = new Quad();
		bottom.color = bodyColor;
		bottom.depth = 0; // this is in the sense of layers
		bottom.pos(0, roundedCorner);
		bottom.size(width, height - roundedCorner * 2);
		this.add(bottom);

		return this;
	}
}
