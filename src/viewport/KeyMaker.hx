package viewport;

import keyson.Axis;
import ceramic.Color;

/*
 * Here we convert the shape-string into an actual key shape and bestow the legend(s) upon it :^]
 * 
 */
class KeyMaker {
	public static function createKey(keyboard: keyson.Keyson.Keyboard, k: keyson.Keyson.Key, unit: Int, gapX: Int, gapY: Int,
			color: String): KeyRenderer {
		var key: KeyRenderer;

		var width: Float;
		var height: Float;

		var widthNorth: Int = 0;
		var heightNorth: Int = 0;
		var widthSouth: Int = 0;
		var heightSouth: Int = 0;
		var offsetSouthX: Int = 0;
		var offsetSouthY: Int = 0;

		// we convert the values into actual ceramic color
		final keyColor: Color = Std.parseInt(k.keysColor) ?? Std.parseInt(color) ?? Color.WHITE;
		final keyShadow: Color = getKeyShadow(keyColor);

		// TODO: Create some form of syntax that can define this information without this switch case creature
		for (t in ["BAE", "ISO", "XT_2U", "AEK"]) { // the special shape cases
			if (k.shape.split(' ').indexOf(t) != -1) { // if shape found found go here
				switch k.shape {
					case "ISO":
						// Normal ISO
						widthNorth = 150 - gapX;
						heightNorth = 100 - gapY;
						widthSouth = 125 - gapX;
						heightSouth = 200 - gapY;
						offsetSouthX = 25;
						offsetSouthY = 0;
					case "ISO Inverted":
						// Inverted ISO
						// This is an ISO enter but with the top of the keycap reversed
						widthNorth = 125 - gapX;
						heightNorth = 200 - gapY;
						widthSouth = 150 - gapX;
						heightSouth = 100 - gapY;
						offsetSouthX = 0;
						offsetSouthY = 100;
					case "BAE":
						// Normal BAE
						widthNorth = 150 - gapX;
						heightNorth = 200 - gapY;
						widthSouth = 225 - gapX;
						heightSouth = 100 - gapY;
						offsetSouthX = -75;
						offsetSouthY = 100;
					case "BAE Inverted":
						// Inverted BAE
						widthNorth = 225 - gapX;
						heightNorth = 100 - gapY;
						widthSouth = 150 - gapX;
						heightSouth = 200 - gapY;
						offsetSouthX = -1; // the -1 is a code-design quirk!
						offsetSouthY = 0;
					case "XT_2U":
						widthNorth = 100 - gapX;
						heightNorth = 200 - gapY;
						widthSouth = 200 - gapX;
						heightSouth = 100 - gapY;
						offsetSouthX = -100;
						offsetSouthY = 100;
					case "AEK":
						widthNorth = 125 - gapX;
						heightNorth = 100 - gapY;
						widthSouth = 100 - gapX;
						heightSouth = 200 - gapY;
						offsetSouthX = 25;
						offsetSouthY = 0;
				}
			}
		}

		final keySize = Std.parseFloat(k.shape); // every valid size will get caught here
		if (Math.isNaN(keySize) == false) { // aka it is a number
			if (k.shape.split(' ').indexOf("Vertical") != -1) { // it's vertical! '<Number>U Vertical'
				width = unit - gapX;
				height = unit * keySize - gapY;
			} else {
				width = unit * keySize - gapX;
				height = unit - gapY;
			}
			key = new keys.RectangularKey(width, height, keyColor, keyShadow);
		} else { // non '<number>U' cases:
			key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY, keyColor, keyShadow);
		}

		// here we populate the legends (see function below)
		var keyLegends: Array<LegendRenderer> = KeyMaker.createLegend(keyboard, k, unit); // it is another Visual
		for (l in keyLegends) {
			key.add(l.create()); // adding ti to the key visual
		}

		key.represents = k;

		return key;
	}

	public static function createLegend(keyboard: keyson.Keyson.Keyboard, k: keyson.Keyson.Key, unit: Int): Array<LegendRenderer> {
		var keyLegends: Array<LegendRenderer> = [];
		var legendOffsetX: Float;
		var legendOffsetY: Float;

		for (l in k.legends) { // we can have many labels!
			// default to GRAY if undefined
			var legendColor = Std.parseInt(l.legendColor) ?? Std.parseInt(keyboard.legendColor) ?? Color.GRAY;
			var legend = new LegendRenderer(l.symbol, legendColor);
			// is the legend position set specifically?
			if (l.legendPosition != null) { // yes we account for individual adjustment too!
				legendOffsetX = l.legendPosition[Axis.X] + keyboard.legendPosition[Axis.X];
				legendOffsetY = l.legendPosition[Axis.Y] + keyboard.legendPosition[Axis.Y];
			} else { // no we use the global coordinates
				legendOffsetX = keyboard.legendPosition[Axis.X];
				legendOffsetY = keyboard.legendPosition[Axis.Y];
			}
			// is the fontsize set specifically?
			if (l.legendSize != 0) { // TODO make this detect per key font change
				legend.fontSize = l.legendSize;
			} else {
				legend.fontSize = keyboard.keyboardFontSize;
			}

			legend.depth = 4; // make sure labels render on top
			//			legend.pos(legendOffsetX + legend.topX + unit * k.position[Axis.X], legendOffsetY + legend.topY + unit * k.position[Axis.Y]);
			legend.pos(legendOffsetX + legend.topX, legendOffsetY + legend.topY); // relative to the key shape

			keyLegends.push(legend);
		}

		return keyLegends;
	}

	static function getKeyShadow(color: Color): Color {
		color.lightnessHSLuv -= 0.15;
		return color;
	}
}
