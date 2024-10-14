package;

import keyson.Axis;
import keyson.Keyson.Keyboard;
import keyson.Keyson.Key;
import ceramic.Color;

/**
 * Here we convert the shape-string into an actual keyShape shape and bestow the legend(s) upon it :^]
 */
class KeyMaker {
	/**
	 * Create a complete keyShape with all its belonging features
	 */
	public static function createKey(keyboard: Keyboard, k: Key, unit: Float, gapX: Int, gapY: Int, ?color: Color): KeyRenderer {
		var width: Float;
		var height: Float;

		var widthNorth: Float = 0;
		var heightNorth: Float = 0;
		var widthSouth: Float = 0;
		var heightSouth: Float = 0;
		var offsetSouthX: Float = 0;
		var offsetSouthY: Float = 0;

		var stepWidth: Float = 0;
		var stepHeight: Float = 0;
		var stepOffsetX: Float = 0;
		var stepOffsetY: Float = 0;
		var stepped: Float = 0;

		// We convert the values into actual ceramic colors
		final keyColor: Color = Std.parseInt(k.color) ?? color ?? Color.WHITE;
		final keyShadow: Color = getKeyShadow(keyColor);

		var keyShape: KeyRenderer;

		for (t in ["BAE", "ISO", "XT_2U", "AEK"]) { // the special shape cases
			if (k.shape.split(' ').indexOf(t) != -1) { // if shape found found go here
				switch k.shape {
					case "ISO":
						// Normal ISO
						widthNorth = 1.50 * unit - gapX;
						heightNorth = 1.00 * unit - gapY;
						widthSouth = 1.25 * unit - gapX;
						heightSouth = 2.00 * unit - gapY;
					case "ISO Inverted":
						// Inverted ISO
						// This is an ISO enter but with the top of the keycap reversed
						widthNorth = 1.25 * unit - gapX;
						heightNorth = 2.00 * unit - gapY;
						widthSouth = 1.50 * unit - gapX;
						heightSouth = 1.00 * unit - gapY;
					case "BAE":
						// Normal BAE
						widthNorth = 1.50 * unit - gapX;
						heightNorth = 2.00 * unit - gapY;
						widthSouth = 2.25 * unit - gapX;
						heightSouth = 1.00 * unit - gapY;
						offsetSouthX = -0.75 * unit - gapY;
					case "BAE Inverted":
						// Inverted BAE
						widthNorth = 2.25 * unit - gapX;
						heightNorth = 1.00 * unit - gapY;
						widthSouth = 1.50 * unit - gapX;
						heightSouth = 2.00 * unit - gapY;
					case "XT_2U":
						widthNorth = 1.00 * unit - gapX;
						heightNorth = 2.00 * unit - gapY;
						widthSouth = 2.00 * unit - gapX;
						heightSouth = 1.00 * unit - gapY;
						offsetSouthX = -1.00 * unit - gapY;
					case "AEK":
						widthNorth = 1.25 * unit - gapX;
						heightNorth = 1.00 * unit - gapY;
						widthSouth = 1.00 * unit - gapX;
						heightSouth = 2.00 * unit - gapY;
				}
			}
		}

		final keySize = Std.parseFloat(k.shape);
		if (Math.isNaN(keySize) == false) {
			if (k.shape.split(' ').indexOf("Vertical") != -1) {
				// VERTICAL
				width = unit - gapX;
				height = unit * keySize - gapY;
				if (k.shape.split(' ').indexOf("Stepped") != -1) {
					stepped = Std.parseFloat(k.shape.split('Stepped')[1]) * unit + gapX;
					if (stepped < 0) {
						// NEGATIVE
						stepOffsetY = width + stepped;
					} else {
						stepOffsetY = 0;
					}
					stepOffsetX = 0;
					stepHeight = Math.abs(stepped);
					stepWidth = unit - gapY;
				}
			} else {
				width = unit * keySize - gapX;
				height = unit - gapY;
				if (k.shape.split(' ').indexOf("Stepped") != -1) {
					// STEPPED
					stepped = Std.parseFloat(k.shape.split('Stepped')[1]) * unit + gapX;
					if (stepped < 0) {
						// NEGATIVE
						stepOffsetX = width + stepped; // stepped is negative so this is actually subtraction!
					} else {
						stepOffsetX = 0;
					}
					stepOffsetY = 0;
					stepWidth = Math.abs(stepped);
					stepHeight = unit - gapY;
				}
			}
			if (k.shape.split(' ').indexOf("Stepped") != -1) {
				var stepedKey = new keys.SteppedKey();
				stepedKey.size(width, height);
				stepedKey.stepWidth = stepWidth;
				stepedKey.stepHeight = stepHeight;
				stepedKey.stepOffsetX = stepOffsetX;
				stepedKey.stepOffsetY = stepOffsetY;
				stepedKey.stepped = stepped;
				stepedKey.topColor = keyColor;
				stepedKey.bottomColor = keyShadow;
				stepedKey.sourceKey = k;
				keyShape = stepedKey;
			} else {
				keyShape = new keys.RectangularKey();
				keyShape.size(width, height);
				keyShape.topColor = keyColor;
				keyShape.bottomColor = keyShadow;
				keyShape.sourceKey = k;
			}
		} else {
			var enterShaped = new keys.EnterShapedKey();
			enterShaped.widthNorth = widthNorth;
			enterShaped.heightNorth = heightNorth;
			enterShaped.widthSouth = widthSouth;
			enterShaped.heightSouth = heightSouth;
			enterShaped.topColor = keyColor;
			enterShaped.bottomColor = keyShadow;
			enterShaped.shape = k.shape;
			if (offsetSouthX != null)
				enterShaped.offsetSouthX = offsetSouthX;
			enterShaped.sourceKey = k;
			keyShape = enterShaped;
		}
		var keyLegends: Array<LegendRenderer> = KeyMaker.createLegend(keyboard, k, unit);
		for (legend in keyLegends) {
			keyShape.add(legend);
		}
		keyShape.legends = keyLegends;

		return keyShape;
	}

	/**
	 * Create all legends on a key
	 */
	public static function createLegend(keyboard: keyson.Keyson.Keyboard, k: keyson.Keyson.Key, unit: Float): Array<LegendRenderer> {
		var keyLegends: Array<LegendRenderer> = [];
		var legendOffsetX: Float;
		var legendOffsetY: Float;

		for (l in k.legends) {
			var currentLegendColor = Std.parseInt(l.color) ?? Std.parseInt(keyboard.defaults.legendColor) ?? Color.GRAY;

			var symbol = new LegendRenderer();
			symbol.content = l.legend;
			symbol.color = currentLegendColor;

			if (l.position != null) {
				legendOffsetX = l.position[Axis.X] + keyboard.defaults.legendPosition[Axis.X];
				legendOffsetY = l.position[Axis.Y] + keyboard.defaults.legendPosition[Axis.Y];
			} else {
				legendOffsetX = keyboard.defaults.legendPosition[Axis.X];
				legendOffsetY = keyboard.defaults.legendPosition[Axis.Y];
			}
			// if omitted the size equals to null, but we ignore zero too
			if (l.legendSize != 0 && l.legendSize != null) {
				symbol.fontSize = l.legendSize;
			} else {
				symbol.fontSize = keyboard.keyboardFontSize;
			}
			symbol.pos(legendOffsetX + symbol.topX, legendOffsetY + symbol.topY);
			symbol.depth = 50;

			keyLegends.push(symbol);
		}
		return keyLegends;
	}
	public static function getKeyShadow(color: Color): Color {
		color.lightnessHSLuv -= 0.15;
		return color;
	}
}
