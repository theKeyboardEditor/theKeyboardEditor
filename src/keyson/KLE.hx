package keyson;

class KLE {
	// Converts a json string from Keyboard Layout Editor to Keyson's object format
	public static function toKeyson(string: String): Keyson {
		var keyson = new keyson.Keyson();
		var kle = haxe.Json.parse(string);
		kle[0];
		
		var w: Float = 1;
		var x: Float = 0;
		var y: Float = 0;
		var xNext: Float = 1;
		var shape: String = "1U";

		for (row in kle) {
			row[0];
			x = 0;
			for (col in row) {
				if (col.y != null)
					y = y + col.y;
				if (col.x != null)
					xNext += col.x;
				if (col is String) {
					var legend: String = Std.string(col);
					keyson.unit[0].addKey(shape, [x, y], legend);
					w = 1;
					shape = "1U";
				} else {
					w = if (col.w != null) col.w else if (col.h != null) col.h else 1;
					shape = if (col.w != null) Std.string(w) + "U" else if (col.h != null) Std.string(w) + "U Vertical" else "1U";
					x--;
				}
				x = x + xNext;
				if (col.w != null) {
					xNext = col.w;
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
