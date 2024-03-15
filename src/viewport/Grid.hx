package viewport;

import ceramic.Repeat;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

/**
 * The grid is a background used for alignment
 * It is comprised of boxes made up of pluses and dots
 */
class Grid extends Visual {
	@content public var fg: Color = 0xff282828;
	public var primaryStepX(default, set): Float = 100;
	public var primaryStepY(default, set): Float = 100;
	@content public var subStepX: Float = 25;
	@content public var subStepY: Float = 25;
	@content public var maxStepsX: Int = 48;
	@content public var maxStepsY: Int = 12;
	static inline final plusSize: Float = 16;

	override public function computeContent() {
		var quad = new Quad();
		var plus = createPlus();
		quad.add(plus);
		
		var qWidth = 0.0;
		var horizontalDots = new Visual();
		for (x in 0...3) {
			var dot = createDot();
			dot.x = (x * subStepX) + subStepX;
			qWidth += dot.width + subStepX;
			horizontalDots.add(dot);
		}
		quad.width = qWidth;
		quad.add(horizontalDots);

		var qHeight = 0.0;
		var verticalDots = new Visual();
		for (y in 0...3) {
			var dot = createDot();
			dot.y = (y * subStepY) + subStepY;
			qHeight += dot.height + subStepY;
			verticalDots.add(dot);
		}
		quad.height = qHeight;
		quad.add(verticalDots);

		var repeat = new Repeat();
		var texture = new ceramic.RenderTexture(width, height);
		texture.autoRender = true;
		texture.stamp(quad, () -> {
			repeat.texture = texture;
			repeat.size(width, height);
			repeat.add(quad);
			repeat.spacingX = 2;
			this.add(repeat);
		});

		super.computeContent();
	}

	inline function createPlus(): Visual {
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

		return plus;
	}

	inline function createDot() {
		var dot = new Quad();
		dot.size(plusSize / 8, plusSize / 8);
		dot.depth = 0;
		dot.color = fg;
		dot.color.lightnessHSLuv += 0.15;
		return dot;
	}

	function set_primaryStepX(step: Float) {
		this.width = primaryStepX * maxStepsX;
		contentDirty = true;
		return step;
	}

	function set_primaryStepY(step: Float) {
		this.height = primaryStepY * maxStepsY;
		contentDirty = true;
		return step;
	}

	public function primaryStep(value: Float) {
		this.primaryStepX = value;
		this.primaryStepY = value;
	}

	public function subStep(value: Float) {
		this.subStepX = value;
		this.subStepY = value;
	}
}
