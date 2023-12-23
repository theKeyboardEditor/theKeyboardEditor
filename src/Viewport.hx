package;

import ceramic.Scene;
import keyson.Keyson.Keyboard;

class Viewport extends Scene {
	var keyboard: Keyboard;
	inline static final unit = 100;

	override public function new(keyboard: Keyboard) {
		super();
		this.keyboard = keyboard;
	}

	override function create() {
		var gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit);
		var gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit);

		for (k in this.keyboard.keys) {
			var key: KeyRenderer;

			// TODO: Create some form of syntax that can define this information without this switch case creature
			switch k.shape {
				case "2U":
					final width = unit * 2 - gapX;
					final height = unit - gapY;
					key = new keys.RectangularKey(width, height);
				case "2U vertical":
					final width = unit - gapX;
					final height = unit * 2 - gapY;
					key = new keys.RectangularKey(width, height);
				case "ISO":
					// Normal ISO
					gapX = Std.int((19.05 - 18.5) / 19.05 * unit);
					gapY = Std.int((19.05 - 18.5) / 19.05 * unit);
					final width = unit - gapX;
					final height = unit - gapY;
					final width1 = 150 - gapX;
					final height1 = 100 - gapY;
					final width2 = 125 - gapX;
					final height2 = 200 - gapY;
					final offsetX2 = 25 + Std.int(gapX / 2);
					final offsetY2 = 0 + Std.int(gapY / 2);
					key = new keys.LShapeKey(width1, height1, width2, height2, offsetX2, offsetY2);
				default:
					// 1U
					var width = unit - gapX;
					var height = unit - gapY;
					key = new keys.RectangularKey(width, height);
			}

			key.pos(unit * key.unitScale * k.position[Axis.X] + 500, unit * key.unitScale * k.position[Axis.Y] + 50);

			this.add(key.create());
		}
	}
}

/**
 * We define the X and Y axes exclusively for convenience here
 * It will compile down to just X = 0, Y = 1
 */
enum abstract Axis(Int) to Int {
	var X;
	var Y;
}
