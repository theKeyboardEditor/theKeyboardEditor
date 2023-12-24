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
			// if nothing is given it defaults to 1U
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
					// we shouldn't override the gap now on:
					// gapX = Std.int((19.05 - 18.5) / 19.05 * unit);
					// gapY = Std.int((19.05 - 18.5) / 19.05 * unit);
					final widthNorth = 150 - gapX;
					final heightNorth = 100 - gapY;
					final widthSouth = 125 - gapX;
					final heightSouth = 200 - gapY;
					final offsetSouthX = 25 + Std.int(gapX / 2);
					final offsetSouthY = 0 + Std.int(gapY / 2);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
				case "ISO Inverted":
					// Inverted ISO
					// This is an ISO enter but with the top of the keycap reversed
					// we shouldn't override the gap now on:
					// gapX = Std.int((19.05 - 18.5) / 19.05 * unit);
					// gapY = Std.int((19.05 - 18.5) / 19.05 * unit);
					final widthNorth = 125 - gapX;
					final heightNorth = 200 - gapY;
					final widthSouth = 150 - gapX;
					final heightSouth = 100 - gapY;
					final offsetSouthX = 0 + Std.int(gapX / 2);
					final offsetSouthY = 100 + Std.int(gapY / 2);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
				case "BAE":
					// Normal BAE
					// we shouldn't override the gap now on:
					// gapX = Std.int((19.05 - 18.5) / 19.05 * unit);
					// gapY = Std.int((19.05 - 18.5) / 19.05 * unit);
					final widthNorth = 150 - gapX;
					final heightNorth = 200 - gapY;
					final widthSouth = 225 - gapX;
					final heightSouth = 100 - gapY;
					final offsetSouthX = -75 - Std.int(gapX / 2);
					final offsetSouthY = 100 + Std.int(gapY / 2);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
				case "BAE Inverted":
					// Inverted BAE
					final widthNorth = 225 - gapX;
					final heightNorth = 100 - gapY;
					final widthSouth = 150 - gapX;
					final heightSouth = 200 - gapY;
					final offsetSouthX = 0 - Std.int(gapX / 2);
					final offsetSouthY = 0 + Std.int(gapY / 2);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
				case "XT 2U":
					final widthNorth = 100 - gapX;
					final heightNorth = 200 - gapY;
					final widthSouth = 200 - gapX;
					final heightSouth = 100 - gapY;
					final offsetSouthX = -100 - Std.int(gapX / 2);
					final offsetSouthY = 100 + Std.int(gapY / 2);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
				case "AEK":
					final widthNorth = 125 - gapX;
					final heightNorth = 100 - gapY;
					final widthSouth = 100 - gapX;
					final heightSouth = 200 - gapY;
					final offsetSouthX = 25 + Std.int(gapX / 2);
					final offsetSouthY = 0 + Std.int(gapY / 2);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
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
