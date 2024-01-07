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

		// KLE's keyson has really odd fileds and relations?
		for (row in kle) { // iterate thru rows
			row[0]; // with calling this we force haxe alow iteration of row
			x = 0; // reset vertical key position
			for (col in row) { // iterate thru keys and gaps and all other stuff
				if (col.y != null) // if we find a y: pair we add it as vertical row-to row padding
					y = y + col.y; // effective immediately
				if (col.x != null) // if we find a x: pair we assume it's key to key padding
					xNext += col.x; // effective sfter placing the current element
				if (col is String) { // we check if there is a "legend" in this columanr element 
					var legend: String = Std.string(col); // yes, we take it in
					keyson.unit[0].addKey(shape, [x, y], legend);
					w = 1; // default presumed width (if none is given)
					shape = "1U"; // presumed shape
				} else { // no there is no string in this element:
					w = if (col.w != null) col.w else if (col.h != null) col.h else 1; // if we have w: pair we evaluate width
					shape = if (col.w != null) Std.string(w) + "U"
						 else if (col.h != null) Std.string(w) + "U Vertical"
								else "1U"; // w to shape
					x--; // we compensate default automatic horizontal stepping for this non key producing element
				}
				x = x + xNext; // make horizontal stepping for the next item
				if (col.w != null) {
					xNext = col.w; // accout for item position in the next iteration
				} else {
					xNext = 1;
				}
			}
			y++; // make vertical stepping after the row is processed
		}
		// return what was converted
		return keyson;
	}

	// Converts a Keyson object to a Keyboard Layout Editor json
	public static function fromKeyson(keyson: Keyson) {}
}
