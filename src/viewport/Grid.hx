package viewport;

import ceramic.Layer;
import ceramic.Repeat;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

@:structInit
class GridProperties {
	public var fg: Color = Color.GRAY;
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
	static inline final plusRatio: Float = 1 / 8;

	var repeat: Repeat;

	override public function new(props: GridProperties) {
		super();
		static final halfPlus = plusSize * (1 - plusRatio) / 2;
		static final halfAndPlus = plusSize * (1 + plusRatio) / 2;

		var field = new Visual();

		var plus = createPlus(props.fg);
		field.add(plus);

		var horizontalDots = new Visual();
		for (x in 1...Std.int(props.primaryStepX / props.subStepX)) {
			var dot = createDot(props.fg);
			dot.x = x * props.subStepX;
			horizontalDots.add(dot);
		}
		horizontalDots.y = halfPlus;
		horizontalDots.x = halfPlus;
		field.width = props.primaryStepX;
		field.add(horizontalDots);

		var verticalDots = new Visual();
		for (y in 1...Std.int(props.primaryStepY / props.subStepY)) {
			var dot = createDot(props.fg);
			dot.y = y * props.subStepY;
			verticalDots.add(dot);
		}
		verticalDots.x = halfPlus;
		verticalDots.y = halfPlus;
		field.height = props.primaryStepY;
		field.add(verticalDots);

		repeat = new Repeat();
		var texture = new ceramic.RenderTexture(props.primaryStepX, props.primaryStepY);
		texture.autoRender = true;
		texture.stamp(field, () -> {
			repeat.texture = texture;
			repeat.size(this.width, this.height);
			// sniper exact middle of keycaps:
			repeat.x -= halfAndPlus;
			repeat.y -= halfAndPlus;
			this.add(repeat);
		});
	}

	override public function computeContent() {
		// repeat.size(width, height);
		super.computeContent();
	}

	inline function createPlus(fg: Color): Visual {
		var plus = new Visual();
		plus.size(plusSize, plusSize);

		var plusHorizontal = new Quad();
		plusHorizontal.size(plusSize, plusSize * plusRatio);
		plusHorizontal.anchor(0.5, 0.5);
		plusHorizontal.depth = 0;
		plusHorizontal.color = fg;
		plusHorizontal.color.lightnessHSLuv += 0.15;
		plus.add(plusHorizontal);

		var plusVertical = new Quad();
		plusVertical.size(plusSize * plusRatio, plusSize);
		plusVertical.anchor(0.5, 0.5);
		plusVertical.depth = 0;
		plusVertical.color = fg;
		plusVertical.color.lightnessHSLuv += 0.15;
		plus.add(plusVertical);

		plus.pos(plusHorizontal.width / 2, plusVertical.height / 2);

		return plus;
	}

	inline function createDot(fg: Color) {
		var dot = new Quad();
		dot.size(plusSize * plusRatio, plusSize * plusRatio);
		dot.depth = 0;
		dot.color = fg;
		dot.color.lightnessHSLuv += 0.15;
		return dot;
	}
}
