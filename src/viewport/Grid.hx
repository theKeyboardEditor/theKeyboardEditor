package viewport;

import ceramic.Layer;
import ceramic.Repeat;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

@:structInit
class GridProperties {
	public var fg: Color = Color.WHITE;
	public var primaryStepX: Float = 100;
	public var primaryStepY: Float = 100;
	public var subStepX: Float = 25;
	public var subStepY: Float = 25;
	public var maxStepsX: Int = 48;
	public var maxStepsY: Int = 12;
}

/**
 * The grid is a background used for alignment
 * It is comprised of boxes made up of pluses and dots
 */
class Grid extends Layer {
	static inline final plusSize: Float = 16;

	var repeat: Repeat;

	override public function new(props: GridProperties) {
		super();
		var quad = new Visual();

		var plus = createPlus(props.fg);
		quad.add(plus);

		var qWidth = 0.0;
		var horizontalDots = new Visual();
		for (x in 0...3) {
			var dot = createDot(props.fg);
			dot.x = (x * props.subStepX) + props.subStepX;
			qWidth += dot.width + props.subStepX;
			horizontalDots.add(dot);
		}
		horizontalDots.y = plusSize / 2;
		quad.width = qWidth;
		quad.add(horizontalDots);

		var qHeight = 0.0;
		var verticalDots = new Visual();
		for (y in 0...3) {
			var dot = createDot(props.fg);
			dot.y = (y * props.subStepY) + props.subStepY;
			qHeight += dot.height + props.subStepY;
			verticalDots.add(dot);
		}
		quad.height = qHeight;
		quad.add(verticalDots);

		// this.add(quad);
		repeat = new Repeat();
		var texture = new ceramic.RenderTexture(qWidth, qHeight);
		texture.autoRender = true;
		texture.stamp(quad, () -> {
			repeat.texture = texture;
			repeat.size(this.width, this.height);
			repeat.x -= plusSize / 2;
			this.add(repeat);
		});
	}

	// override public function computeContent() {
	//	//repeat.size(width, height);
	//	super.computeContent();
	// }

	inline function createPlus(fg: Color): Visual {
		var plus = new Visual();
		plus.size(plusSize, plusSize);

		var plusHorizontal = new Quad();
		plusHorizontal.size(plusSize, plusSize / 8);
		plusHorizontal.anchor(0.5, 0.5);
		plusHorizontal.depth = 0;
		plusHorizontal.color = fg;
		plusHorizontal.color.lightnessHSLuv += 0.15;
		plus.add(plusHorizontal);

		var plusVertical = new Quad();
		plusVertical.size(plusSize / 8, plusSize);
		plusVertical.anchor(0.5, 0.5);
		plusVertical.depth = 0;
		plusVertical.color = fg;
		plusVertical.color.lightnessHSLuv += 0.15;
		plus.add(plusVertical);

		plus.pos(Std.int(plusHorizontal.width / 2), Std.int(plusVertical.height / 2));

		return plus;
	}

	inline function createDot(fg: Color) {
		var dot = new Quad();
		dot.size(plusSize / 8, plusSize / 8);
		dot.depth = 0;
		dot.color = fg;
		dot.color.lightnessHSLuv += 0.15;
		return dot;
	}
}
