package;

import keyson.Axis;

class KeyMaker {
	public static function createKey(k: keyson.Keyson.Key, unit: Int, gapX: Int, gapY: Int): KeyRenderer {
		var key: KeyRenderer;

        var width: Float;
        var height: Float;

        var widthNorth: Int = 0;
        var heightNorth: Int = 0;
        var widthSouth: Int = 0;
        var heightSouth: Int = 0;
        var offsetSouthX: Int = 0;
        var offsetSouthY: Int = 0;

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
						offsetSouthY = 101; // the 101 is a code-desing quirk!
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
			if (k.shape.split(' ').indexOf("Vertical") != -1) { // it's vertical!
				width = unit - gapX;
				height = unit * keySize - gapY;
			} else {
				width = unit * keySize - gapX;
				height = unit - gapY;
			}
			key = new keys.RectangularKey(width, height);
		} else {
			key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
		}

        return key;
	}

	public static function createLabel(keyboard: keyson.Keyson.Keyboard, k: keyson.Keyson.Key, unit: Int): Array<LabelRenderer> {
		var keyLabels: Array<LabelRenderer> = [];
        var labelOffsetX: Float;
		var labelOffsetY: Float;

		for (l in k.labels) { // we can have many labels!
			var label = new LabelRenderer(l.glyph);
			label.color = 0xFF00000F;
			// is the label position set specifically?
			if (l.labelPosition != null) { // yes we adjust specifically
				labelOffsetX = l.labelPosition[Axis.X];
				labelOffsetY = l.labelPosition[Axis.Y];
			} else { // no we use the global coordinates
				labelOffsetX = keyboard.labelPosition[Axis.X];
				labelOffsetY = keyboard.labelPosition[Axis.Y];
			}
			// is the fontsize set specifically?
			if (l.labelFontSize != 0) { // TODO make this detect per key font change
				label.fontSize = l.labelFontSize;
			} else {
				label.fontSize = keyboard.keyboardFontSize;
			}

			label.depth = 4; // mae sure labels render on top
			label.pos(labelOffsetX + label.topX + unit * k.position[Axis.X], labelOffsetY + label.topY + unit * k.position[Axis.Y]);

            keyLabels.push(label);
		}

        return keyLabels;
    }
}
