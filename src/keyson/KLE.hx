package keyson;

using StringTools;
using haxe.io.Bytes;

typedef KeyType = {
	x: Null<Float>,
	f: Null<Int>,
	w: Null<Float>,
	h: Null<Float>,
	y: Null<Float>,
	rx: Null<Float>,
	ry: Null<Float>,
	w2: Null<Float>,
	a: Null<Int>,
	c: String,
	t: String,
	d: Bool
}

class KLE {
	public static final legendSanitizers: Map<String, String> = [
		"<BR>" => "\n",
		"<br>" => "\n",
		"\n\n\n\n" => "\n",
		"\n\n\n" => "\n",
		"\n\n" => "\n",
		"<b>" => "",
		"</b>" => "",
		"<u>" => "",
		"</u>" => "",
		"&ndash;" => "-",
		"&mdash;" => "_",
		"&nbsp;" => " ",
		"&#x021d1;" => "⇑",
		"&#x021d3;" => "⇓",
		"&#x021d0;" => "⇐",
		"&#x021d2;" => "⇒",
		"&uArr;" => "⇑",
		"&dArr;" => "⇓",
		"&lArr;" => "⇐",
		"&rArr;" => "⇒",
		"&Uarr;" => "⇑",
		"&Darr;" => "⇓",
		"&Larr;" => "⇐",
		"&Rarr;" => "⇒",
		"&uarr;" => "↑",
		"&darr;" => "↓",
		"&larr;" => "←",
		"&rarr;" => "→",
		"&crarr;" => "↵",
	];

	static final fontSizes: Array<Int> = [20, 11, 14, 20, 24, 26, 27, 28, 30, 32];

	// Converts a json string from Keyboard Layout Editor to Keyson's object format
	public static function toKeyson(name: String, string: String): Keyson {
		var keyson = new keyson.Keyson();
		keyson.name = name;
		keyson.comment = 'Imported by Keyson.KLE';

		var kle: Array<Array<KeyType>> = haxe.Json.parse(string);

		var w: Float = 1;
		var x: Float = 0;
		var y: Float = 0;
		var legendX: Float = 0;
		var legendY: Float = 0;
		var xNext: Float = 1;
		var bodyColor: String = "0xFFFAFAFA";
		var legendColor: String = "0xFF000000";
		var legendSize: Int = 20;

		keyson.units[0].defaults.legendPosition = [6.0, 0.0];

		for (row in kle) {
			var shape = "1U";
			x = 0;
			for (column in (row:Array<KeyType>)) {
				if (column.y != null) {
					y = y + column.y;
				}

				if (column.x != null) {
					xNext += column.x;
				}

				if (column is String) {
					var legend: String = Std.string(column);
					if (legend.contains("</i>")) {
						var reg: EReg = ~/<i class='.*'><\/i>/;
						legend = reg.replace(legend, '#');
					}

					for (key => value in legendSanitizers) {
						legend = legend.replace(key, value);
					}

					var s: String = "";
					if (legend.contains("&#")) {
						s = String.fromCharCode(Std.parseInt("" + legend.substring(2 + legend.indexOf("&#"), 6)));
						legend = legend.substr(0, legend.indexOf("&#")) + s + legend.substr(7 + legend.indexOf("&#"));
					}

					// ISO keys need an 0.25U offset to the left
					var key = if (shape == "ISO") {
						keyson.units[0].createKey(shape, [x - 0.25, y], legend);
					} else {
						keyson.units[0].createKey(shape, [x, y], legend);
					}

					key.color = bodyColor;
					key.legends[0].color = legendColor;
					key.legends[0].legendSize = legendSize;
					key.legends[0].position = [legendX, legendY];

					// Some presumed defaults
					w = 1;
					shape = "1U";
				} else {
					w = column.w ?? column.h ?? 1;

					// SHAPES
					x = if (column.rx != null) column.rx else x;
					y = if (column.ry != null) column.ry + 1 else y;

					if (column.w2 != null && column.w2 == 1.5 && column.h == 2) {
						shape = "ISO";
					} else if (column.w2 != null && column.w2 == 2.25 && column.h == 2) {
						shape = "BAE";
					} else if (column.h != null) {
						shape = Std.string(w) + "U Vertical";
					} else if (column.w != null) {
						shape = Std.string(w) + "U";
					} else {
						shape = "1U";
					}

					// COLOR
					if (column.c != null) {
						bodyColor = "0xFF" + column.c.split("#")[1];
					}
					if (column.t != null) {
						legendColor = "0xFF" + column.t.split("#")[1];
					}
					if (column.f != null) {
						legendSize = fontSizes[column.f];
					}

					if (column.a != null) {
						/**
						 * LEGEND POSITIONS:
						 * bitmask 1 << 0 (0x01) seems to be for X offset to the middle
						 * TODO: this should actually be the middle but we don't have centered text just yet
						 */
						if ((column.a & 1 << 0) == 1 << 0) {
							legendX = 18;
						}

						// bitmask 1 << 1 (0x02) seems to be for X offset to the middle
						legendY = if ((column.a & 1 << 1) == 1 << 1) legendSize * 0.8 else 0;
					}
					x--;
				}
				// Set horizontal stepping for the next item
				x = x + xNext;
				if (column.w != null) {
					// Account for item position in the next iteration
					xNext = column.w;
				} else {
					xNext = 1;
				}
			}
			y++;
		}
		return keyson;
	}

	// Converts a Keyson object to a Keyboard Layout Editor json
	public static function fromKeyson(keyson: Keyson) {}
}
