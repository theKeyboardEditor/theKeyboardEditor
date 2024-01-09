package viewport;

import ceramic.Quad;
import ceramic.Color;
import ceramic.Visual;

/*
 * The cursor is the shape that points where the next object will be placed
 *
 */
class Grid extends Visual {
	public var color1: Color;
	public var color2: Color;
	public var mainStepX: Float;
	public var mainStepY: Float;
	public var subStepX: Float;
	public var subStepY: Float;
	public var offsetX: Float;
	public var offsetY: Float;
	public var maxStepsX: Int = 48;
	public var maxStepsY: Int = 12;

	var long: Float = 15;
	var thick: Float = 3;

	override public function new(mainStepX: Float, mainStepY: Float) {
		super();
		size(mainStepX * maxStepsX, mainStepY * maxStepsY);
		this.color1 = 0xff282828; // UI theme background color!
		this.color2 = 0xff1d2021; // UI theme 2nd background color!
		this.color2 = Color.WHITE; // UI theme 2nd background color!
		this.pos(0, 0);
		this.mainStepX = mainStepX;
		this.mainStepY = mainStepY;
	}

	public function create(): Visual {
		final q5 = new Quad();
		q5.pos(offsetX-5,offsetY-5);
		q5.size(15,15);
		q5.depth = 0;
		q5.color = 0xFF282828;
		q5.color.lightnessHSLuv += 0.15;
		this.add(q5);
		for (xPos in 0...maxStepsX) {
			for (yPos in 0...maxStepsY) {
				final q1 = new Quad();
				q1.pos(offsetX + xPos * mainStepX - thick / 2, offsetY + yPos * mainStepY - long / 2);
				q1.size(thick, long);
				q1.depth = 0;
				q1.color = 0xff282828;
				q1.color.lightnessHSLuv += 0.15;
				this.add(q1);
				for (subX in 0...Std.int(this.mainStepX / this.subStepX)) {
					final q3 = new Quad();
					q3.pos(offsetX + xPos * mainStepX - thick / 2 + subX * subStepX, offsetY + yPos * mainStepY - thick / 2);
					q3.size(thick, thick);
					q3.depth = 0;
					q3.color = 0xff282828;
					q3.color.lightnessHSLuv += 0.15;
					this.add(q3);
				}

				final q2 = new Quad();
				q2.pos(offsetX + xPos * mainStepX - long / 2, offsetY + yPos * mainStepY - thick / 2);
				q2.size(long, thick);
				q2.depth = 0;
				q2.color = 0xff282828;
				q2.color.lightnessHSLuv += 0.15;
				this.add(q2);
				for (subY in 0...Std.int(this.mainStepY / this.subStepY)) {
					final q4 = new Quad();
					q4.pos(offsetX + xPos * mainStepX - thick / 2, offsetY + yPos * mainStepY - thick / 2 + subY * subStepY);
					q4.size(thick, thick);
					q4.depth = 0;
					q4.color = 0xff282828;
					q4.color.lightnessHSLuv += 0.15;
					this.add(q4);
				}
			}
		}
		this.anchorX = 0;
		this.anchorY = 0;
		return this;
	}
}
