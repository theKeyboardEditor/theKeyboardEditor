package keys;

import ceramic.Shape;
import ceramic.Color;
import ceramic.Border;
import ceramic.Visual;
import viewport.Pivot;

/**
 *    Draw a enter shaped rectangle with nice rounded corners
 *
 */
class EnterShapedKey extends KeyRenderer {
	var topColor: Int = 0xffFCFCFC;
	var bodyColor: Int = 0xFFCCCCCC; // defaults
	// we are in the 1U = 100 units of scale ratio here:
	// this is the preset for OEM/Cherry profile keycaps (TODO more presets)
	var topX: Float = 100 / 8;
	var topY: Float = (100 / 8) * 0.25;
	var topOffset: Float = (100 / 8) * 2;
	var roundedCorner: Float = (100 / 1 / 8);
	var widthNorth: Float; // North is the further away member of the pair
	var heightNorth: Float;
	var widthSouth: Float; // South is the closer member of the piar
	var heightSouth: Float;
	var gapX: Float; // The closer member's offset
	var gapY: Float;
	var shape: String;
	var recipe: String;
	var insets: Array<Int>;
	var signumL: Array<Int>;
	var signumR: Array<Int>;
	var signumT: Array<Int>;
	var signumB: Array<Int>;
	var offsetL: Float;
	var offsetR: Float;
	var offsetT: Float;
	var offsetB: Float;
	var localRadius: Float;
	var localWidth: Float;
	var localHeight: Float;
	var sine: Array<Float>;
	var cosine: Array<Float>;
	var points: Array<Float>;
	var turn: Int;

	public var top: Shape; // we might use top for clipping the legend this way?
	public var bottom: Shape;
	public var segments: Int = 10; // 1...many (sane only up to 10)

	override public function new(widthNorth: Float, heightNorth: Float, topColor: Int, bodyColor: Int, widthSouth: Float, heightSouth: Float,
			shape: String, gapX: Float, gapY: Float) {
		super();
		this.widthNorth = widthNorth;
		this.heightNorth = heightNorth;
		this.widthSouth = widthSouth;
		this.heightSouth = heightSouth;
		this.gapX = gapX;
		this.gapY = gapY;
		this.topColor = topColor;
		this.bodyColor = bodyColor;
		this.shape = shape; // the string
	}

	override public function create() {
		offsetB = heightSouth - heightNorth;
		offsetL = widthSouth - widthNorth;
		// TODO  There is still some oddity to fix with BEA and XT_2U
		this.border = new Border();
		if (this.shape == 'BAE' || this.shape == 'XT_2U') {
			this.border.pos(-this.offsetL, 0); // negative for BAE and XT_2U
			this.width = widthSouth;
		} else {
			this.border.pos(0, 0);
		}
		if (this.heightNorth > this.heightSouth) { // north element is the narrow one?
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
		this.border.visible = false; // per default created invisible
		this.add(this.border);

		this.pivot = new Pivot(0, 0);
		// TODO account for key.relativeRotationCenter
		// this.pivot.create();
		this.pivot.depth = 500; // ueber alles o/
		this.pivot.visible = false;
		this.add(this.pivot);

		this.top = enterShape(widthNorth - this.topOffset, heightNorth - this.topOffset, widthSouth - this.topOffset, heightSouth - this.topOffset, topColor, topX, topY);
		this.top.depth = 5;
		this.add(this.top);
		this.bottom = enterShape(widthNorth, heightNorth, widthSouth, heightSouth, bodyColor, 0.0, 0.0);
		this.bottom.depth = 0;
		this.add(this.bottom);

		return this;
	}

	function enterShape(widthNorth: Float, heightNorth: Float, widthSouth: Float, heightSouth: Float, color: Int, posX: Float, posY: Float) {
		var sine = [for (angle in 0...segments + 1) Math.sin(Math.PI / 2 * angle / segments)];
		var cosine = [for (angle in 0...segments + 1) Math.cos(Math.PI / 2 * angle / segments)];
		// @formatter:off
		points = []; // re-clear the array since we are pushing only
		// the shape has 4 corner types:
		// +--------+
		// |7      F|
		// |        |
		// |J      L|
		// +--------+
		// the string is picked so its feature points to an corner
		//    +-----+
		// 7  |7   F|
		// +--+L    | <-the BAE case (we start counting from top leftmost corner)
		// |J      L|
		// +--------+
		recipe = "777777"; // default is BAE
		insets = [];
		// clockwise around we go:
		switch shape {
			case 'BAE Inverted':
			localWidth = widthNorth;
			localHeight = heightSouth;
			recipe = "7FLNLJ";
			//        012345
			// 7 #### F
			//   ### NL
			// J     L
			signumL= [ 0, 0, 0, 0, 0, 0];
			signumR= [ 0, 0, 0,-1,-1, 0];
			signumT= [ 0, 0, 0, 0, 0, 0];
			signumB= [ 0, 0,-1,-1, 0, 0];
			case 'BAE' | 'XT_2U':
			localWidth = widthSouth;
			localHeight = heightNorth;
			recipe = "7FLJZV";
			//    7   F
			// ZV  ##
			// J #### L
			signumL= [ 0,-1,-1,-1,-1, 0];
			signumR= [ 0, 0, 0, 0, 0, 0];
			signumT= [ 0, 0, 0, 0, 0, 0];
			signumB= [ 0, 0, 0, 0,-1,-1];
			case'ISO Inverted':
			localWidth = widthSouth;
			localHeight = heightNorth;
			recipe = "7FDYLJ";
			// 7 ### F
			//   ####DF
			// J     L
			signumL= [ 0, 0, 0, 0, 0, 0];
			signumR= [ 0,-1,-1, 0, 0, 0];
			signumT= [ 0, 0, 0, 0, 0, 0];
			signumB= [ 0, 0,-1,-1, 0, 0];
			case 'AEK' | 'ISO':
			localWidth = widthNorth;
			localHeight = heightSouth;
			recipe = "7FLJIJ";
			// 7 #### F
			// J I###
			//   J   L
			signumL= [ 0, 0, 0, 1, 1, 0];
			signumR= [ 0, 0, 0, 0, 0, 0];
			signumT= [ 0, 0, 0, 0, 0, 0];
			signumB= [ 0, 0, 0, 0,-1,-1];
		}
		// @formatter:on
		this.localRadius = roundedCorner;
		size(localWidth, localHeight);
		// recipe must always be 6 long
		for (turn in 0...6) {
			switch shape {
				case 'AEK' | 'ISO' | 'BAE Inverted':
					offsetT = Math.abs(heightNorth - heightSouth) * signumT[turn]; // TODO account for gapX and gapY
					offsetB = Math.abs(heightNorth - heightSouth) * signumB[turn];
				case 'ISO Inverted' | 'BAE' | 'XT_2U': // to draw proper lower member height:
					offsetT = Math.abs(heightSouth) * signumT[turn]; // TODO account for gapX and gapY
					offsetB = Math.abs(heightSouth) * signumB[turn];
			}
			offsetL = Math.abs(widthNorth - widthSouth) * signumL[turn];
			offsetR = Math.abs(widthNorth - widthSouth) * signumR[turn];
			switch (recipe.charAt(turn)) {
				case "7":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localRadius * (1 - cosine[pointPairIndex]));
						points.push(posY + offsetT + offsetB + localRadius * (1 - sine[pointPairIndex]));
						// trace ('7');
					}
				case "N":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localWidth + localRadius * (1 - cosine[segments - pointPairIndex]));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (1 - sine[segments - pointPairIndex]));
						// trace ('N');
					}
				case "Z":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localRadius * (1 - cosine[pointPairIndex]));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (1 - sine[pointPairIndex]));
						// trace ('Z');
					}
				case "F":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localWidth + localRadius * (cosine[segments - pointPairIndex] - 1));
						points.push(posY + offsetT + offsetB + localRadius * (1 - sine[segments - pointPairIndex]));
						// trace ('F');
					}
				case "Y":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localWidth + localRadius * (cosine[segments - pointPairIndex] - 1));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (1 - sine[segments - pointPairIndex]));
						// trace ('Y');
					}
				case "I":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localRadius * (cosine[pointPairIndex] - 1));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (1 - sine[pointPairIndex]));
						// trace ('I');
					}
				case "L":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localWidth + localRadius * (cosine[pointPairIndex] - 1));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (sine[pointPairIndex] - 1));
						// trace ('L');
					}
				case "V":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localRadius * (cosine[segments - pointPairIndex] - 1));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (sine[segments - pointPairIndex] - 1));
						// trace ('V');
					}
				case "J":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localRadius * (1 - cosine[segments - pointPairIndex]));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (sine[segments - pointPairIndex] - 1));
						// trace ('J');
					}
				case "D":
					for (pointPairIndex in 0...segments) {
						points.push(posX + offsetL + offsetR + localWidth + localRadius * (1 - cosine[pointPairIndex]));
						points.push(posY + offsetT + offsetB + localHeight + localRadius * (sine[pointPairIndex] - 1));
						// trace ('D');
					}
			}
		}
		var shape = new Shape();
		shape.color = color;
		shape.points = points;
		// shape.triangulation = POLY2TRI;
		//		shape.alpha = 0.95 * this.subAlpha; // we draw slightly opaque
		return shape;
	}
}
