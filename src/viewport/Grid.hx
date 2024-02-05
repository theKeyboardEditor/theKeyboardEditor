package viewport;

import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

/**
 * The grid is a background used for alignment
 * It is comprised of boxes made up of pluses and dots
 */
class Grid extends Visual {
	@content public var color: Color = 0xff282828;
	public var primaryStepX(default, set): Float = 100;
	public var primaryStepY(default, set): Float = 100;
	@content public var subStepX: Float = 25;
	@content public var subStepY: Float = 25;
	@content public var maxStepsX: Int = 48;
	@content public var maxStepsY: Int = 12;

	// Defines the size of the pluses
	static inline final long: Float = 15;
	// Defines the thickness of the pluses which effects the dots
	static inline final thick: Float = 3;

	override public function computeContent() {
		var quad = new Quad();
		quad.pos(3.5, 3.5);
		quad.size(7, 7);
		quad.depth = 0;
		quad.color = color;
		quad.color.lightnessHSLuv += 0.15;
		this.add(quad);

		for (xPos in 0...maxStepsX) {
			for (yPos in 0...maxStepsY) {
				var quad1 = new Quad();
				quad1.pos(xPos * primaryStepX - thick / 2, yPos * primaryStepY - long / 2);
				quad1.size(thick, long);
				quad1.depth = 0;
				quad1.color = color;
				quad1.color.lightnessHSLuv += 0.15;
				this.add(quad1);

				for (subX in 1...Std.int(this.primaryStepX / this.subStepX)) {
					var quad3 = new Quad();
					quad3.pos(xPos * primaryStepX - thick / 2 + subX * subStepX, yPos * primaryStepY - thick / 2);
					quad3.size(thick, thick);
					quad3.depth = 0;
					quad3.color = color;
					quad3.color.lightnessHSLuv += 0.15;
					this.add(quad3);
				}

				var quad2 = new Quad();
				quad2.pos(xPos * primaryStepX - long / 2, yPos * primaryStepY - thick / 2);
				quad2.size(long, thick);
				quad2.depth = 0;
				quad2.color = color;
				quad2.color.lightnessHSLuv += 0.15;
				this.add(quad2);

				for (subY in 1...Std.int(this.primaryStepY / this.subStepY)) {
					var quad4 = new Quad();
					quad4.pos(xPos * primaryStepX - thick / 2, yPos * primaryStepY - thick / 2 + subY * subStepY);
					quad4.size(thick, thick);
					quad4.depth = 0;
					quad4.color = color;
					quad4.color.lightnessHSLuv += 0.15;
					this.add(quad4);
				}
			}
		}
		super.computeContent();
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
