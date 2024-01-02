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
	public var mainStepy: Float;
	public var subStepX: Float;
	public var subStepy: Float;

	override public function new(mainStepX: Float, mainStepY: Float, subStepX: Float, subStepX: Float) {
		super();
		size(mainStepX*256,mainStepY*128);
		this.depth = 0;
		this.color1 = 0xFF282828; // UI theme background color!
		this.color2 = 0xFF1d2021; // UI theme 2nd background color!
	}

	public function create(): Visual { // TODO make cursor's size dynamic

		// TODO kreate the grid

		return this;
	}
}
