package viewport;

import keyson.Axis;
import ceramic.Color;

/*
 * Here we convert the shape-string into an actual key shape and bestow the legend(s) upon it :^]
 * 
 */
class KeyMaker {
	public static function createKey(keyboard: keyson.Keyson.Keyboard, k: keyson.Keyson.Key, unit: Float, gapX: Int, gapY: Int,
			color: String): KeyRenderer {
		var key: KeyRenderer;

		var width: Float;
		var height: Float;

		var widthNorth: Float = 0;
		var heightNorth: Float = 0;
		var widthSouth: Float = 0;
		var heightSouth: Float = 0;
		var offsetSouthX: Float = 0;
		var offsetSouthY: Float = 0;

		// we convert the values into actual ceramic color
		final keyColor: Color = Std.parseInt(k.keysColor) ?? Std.parseInt(color) ?? Color.WHITE;
		final keyShadow: Color = getKeyShadow(keyColor);

		// TODO: Create some form of syntax that can define this information without this switch case creature
		for (t in ["BAE", "ISO", "XT_2U", "AEK"]) { // the special shape cases
			if (k.shape.split(' ').indexOf(t) != -1) { // if shape found found go here
				switch k.shape {
					case "ISO":
						// Normal ISO
						widthNorth = 1.50 * unit - gapX;
						heightNorth = 1.00 * unit - gapY;
						widthSouth = 1.25 * unit - gapX;
						heightSouth = 2.00 * unit - gapY;
						offsetSouthX = 0.25 * unit;
						offsetSouthY = 0;
					case "ISO Inverted":
						// Inverted ISO
						// This is an ISO enter but with the top of the keycap reversed
						widthNorth = 1.25 * unit - gapX;
						heightNorth = 2.00 * unit - gapY;
						widthSouth = 1.50 * unit - gapX;
						heightSouth = 1.00 * unit - gapY;
						offsetSouthX = 0;
						offsetSouthY = 100 * unit;
					case "BAE":
						// Normal BAE
						widthNorth = 1.50 * unit - gapX;
						heightNorth = 2.00 * unit - gapY;
						widthSouth = 2.25 * unit - gapX;
						heightSouth = 1.00 * unit - gapY;
						offsetSouthX = -0.75 * unit;
						offsetSouthY = 1.00 * unit;
					case "BAE Inverted":
						// Inverted BAE
						widthNorth = 2.25 * unit - gapX;
						heightNorth = 1.00 * unit - gapY;
						widthSouth = 1.50 * unit - gapX;
						heightSouth = 2.00 * unit - gapY;
						offsetSouthX = -1; // the -1 is a code-design quirk!
						offsetSouthY = 0;
					case "XT_2U":
						widthNorth = 1.00 * unit - gapX;
						heightNorth = 2.00 * unit - gapY;
						widthSouth = 2.00 * unit - gapX;
						heightSouth = 1.00 * unit - gapY;
						offsetSouthX = -1.00 * unit;
						offsetSouthY = 1.00 * unit;
					case "AEK":
						widthNorth = 1.25 * unit - gapX;
						heightNorth = 1.00 * unit - gapY;
						widthSouth = 1.00 * unit - gapX;
						heightSouth = 2.00 * unit - gapY;
						offsetSouthX = 0.25 * unit;
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
			key = new keys.LShapeKey(widthNorth, heightNorth, keyColor, keyShadow, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
		}

		// here we populate the legends (see function below)
		var keyLegends: Array<LegendRenderer> = KeyMaker.createLegend(keyboard, k, unit); // it is another Visual
		for (l in keyLegends) {
			key.add(l.create()); // adding ti to the key visual
		}

		key.represents = k;

		return key;
	}

	public static function createLegend(keyboard: keyson.Keyson.Keyboard, k: keyson.Keyson.Key, unit: Float): Array<LegendRenderer> {
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
