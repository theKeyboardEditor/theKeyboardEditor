package keyson;

/**
 * Conversion from a theKeyboardEditor keyboard design object into JSON string and back
 * https://github.com/theKeyboardEditor/keyson
 */
class Keyson {
	// the version string for later compatibility tracking:
	public static var version = "0.1-alpha";

	// public vars (for the load and save content and flags)
	public var name: String;
	public var author: String;
	public var license: String;
	@:optional public var comment: String;
	@:optional public var palettes: Array<Palette> = [];
	public var units: Array<Keyboard> = [];

	@:jignored public static var tabulation: String = "	"; // keyson output indentation

	public function new(?name: String) { // initialize our object with sane defaults
		this.name = if (name != null) name else "unknown";
		author = "unknown";
		license = "CC";
		comment = "empty";
		palettes.push(new Palette());
		units.push(new Keyboard());
	}

	public function findPalettes(name: String): Array<Palette> {
		return palettes.filter((p) -> {
			return p.name == name;
		});
	}

	public static function parse(data: String) {
		final parser = new json2object.JsonParser<Keyson>();
		final keyson = parser.fromJson(data);
		for (err in parser.errors) {
			#if ceramic
			log.error(err);
			#else
			trace(err);
			#end
		}
		return keyson;
	}

	public static function encode(object: Keyson) {
		final writer = new json2object.JsonWriter<Keyson>();
		return writer.write(object, tabulation);
	}
}
class Palette {
	/**
	 * Name of the palette
	 */
	public var name: String = "unknown";

	/**
	 * Source of the palette
	 */
	@:optional public var url: String = "unknown";
	@:optional public var colorMatchingProfile: ColorMatchingProfile = Generic;

	/**
	 * Amount of colors
	 */
	@:optional public var size: Null<Int> = 1;

	/**
	 * List of colors
	 */
	public var swatches: Array<Color>;
	public function new() {
		this.swatches = [new Color("BLACK", "0x00000000")]; // the names are for humans only
	}

	public function fromName(name: String): Color {
		return swatches.filter((i) -> {
			i.name == name;
		})[0];
	}
}

class Color {
	public var name: String;
	public var value: String;

	public function new(name: String, value: String) {
		this.name = name;
		this.value = value;
	}
}

/**	
 * Each of a Split keyboard's devices with a numpad and a joypad (4 sub rulerUnits)
 * Each of wo halves wirelessly connected to a host via bluetooth
 * Or just a common single unit keyboard
 */
class Keyboard {
	public var id: Int;
	@:optional public var defaults: Defaults = new Defaults();
	@:optional public var designator: String = "default";
	@:optional public var keyStep: Array<Float> = [19.05, 19.05];
	@:optional public var stabilizerType: String = "";
	@:optional public var switchType: String = "";
	@:optional public var capSize: Array<Float> = [18.5, 18.5];
	@:optional public var rulerUnits: String = "mm";
	@:optional public var caseColor: String = "0xFFFCFCFC";
	@:optional public var legendSizeUnits: String = "U/100";
	@:optional public var keyboardFont: String = "default";
	@:optional public var keyboardFontSize: Float = 24.0;
	@:optional public var profile: Profile = OEM;
	@:optional public var keySculpt: String = "R3";
	@:optional public var position: Array<Float> = [0.0, 0.0];
	@:optional public var angle: Array<Float> = [0, 0];
	@:optional public var relativeRotationCenter: Array<Float> = [];
	@:optional public var size: Null<Int> = 0;
	@:optional public var keys: Array<Key> = [];

	public function new() {}

	public function createKey(shape: String, pos: Array<Float>, legend: String): Key {
		var uid = this.keys.length;
		var key = new Key(uid, shape, pos, legend);
		insertKey(key);
		return key;
	}

	/**
	 * Insert a keyson key and put it in it's place by position and id
	 */
	public function insertKey(insertee: Key) {
		this.keys.push(insertee);
		sortKeys();
		return insertee;
	}

	/**
	 * Remove key by keyson reference
	 */
	public function removeKey(deletee: Key) {
		this.keys = [
			for (key in this.keys.filter(key -> key != deletee)) {
				key;
			}
		];
	}
	public function removeKeyById(id: Int) {
		var i: Int = 0;
		this.keys = [
			for (key in this.keys.filter(key -> key.id != id)) {
				key.id = i++;
				key;
			}
		];
	}

	/**
	 * Sort keyson by position and steamroll the ids
	 */
	public function sortKeys() {
		// First order all keys by X and Y position
		this.keys.sort((a, b) -> {
			return (Std.int((a.position[0] + 128 * a.position[1]) * 25) - Std.int((b.position[0] + 128 * b.position[1]) * 25));
		});

		// Next adjust the id to reflect just that
		var i: Int = 0;
		this.keys = [
			for (k in this.keys) {
				k.id = i++;
				k;
			}
		];
	}
}

/**
 * The actual tactile unit of interaction
 */
class Key {
	public var id: Int;
	public var position: Array<Float> = [];
	public var shape: String;
	@:optional public var stabilizer: String = "";
	@:optional public var angle: Null<Float> = 0.0;
	@:optional public var relativeRotationCenter: Array<Float> = [0, 0];
	@:optional public var features: Array<String> = [];
	@:optional public var homingFeature: HomingFeature = None;
	@:optional public var color: String = "0xFFFFFFFF";
	@:optional public var spacerSize: Array<Float>;
	@:optional public var amountOfLegends: Null<Int> = 0;
	@:optional public var legends: Array<KeyLegend> = [];

	public function new(id: Int, shape: String, position: Array<Float>, legend: String) {
		this.id = id;
		this.position = position;
		// "1U","2U","2U vertical","1.25U","1.5U","1.75U","2.25U","2.75U","ISO","BAE","6.25U","7.25U","3U","0.75U"
		this.shape = shape;
		this.legends.push(new KeyLegend(legend));
		this.amountOfLegends = legends.length;
	}

	public function addLegend(legend: String, position: Array<Float>) {
		legends.push(new KeyLegend(legend));
	}
}
@:default(auto)
class Defaults {
	@:default("0xFFFCFCFC")
	@:optional public var keyColor: String = "0xFFFCFCFC";
	@:default([5.0, 5.0])
	@:optional public var legendPosition: Array<Float> = [5.0, 5.0];
	@:default("0xFF00000F")
	@:optional public var legendColor: String = "0xFF00000F";

	public function new() {}
}

enum abstract Profile(String) from String {
	// OEM is default
	final OEM;
	final Cherry;
	final XDA;
	final Choc;
	final MBK;
	final WRK;
	final Laptop;
	final Flat;
	final SA;
	final DSA;
}

enum abstract ColorMatchingProfile(String) from String {
	final Generic;
}

/**
 * The sign/symbol on the unit
 */
class KeyLegend {
	public var legend: String = "";
	@:optional public var legendSize: Null<Float> = 24.0;
	@:optional public var color: String = "0xFF00000f";
	@:optional public var position: Array<Float> = [5.0, 5.0];

	public function new(legend: String) {
		this.legend = legend;
	}
}
// Various key position features/replacements and their respective properties:

class LEDFeature {
	public var diameter: Null<Float>; // diameter usually 3.0 or 5.0 mm
}

class EncoderFeature {
	public var diameter: Float = 0.0; // in unit size
	public var barrelSize: Float = 0.0; // height/length in rulerUnits size
	public var profile: String = ""; // "Round" "Curled" "Ribbed"
	public var type: String = ""; // axis:"Upright" "Barrel X" "Barrel Y"

	public function new() {}
}

class TrackpointFeature {
	public var diameter: Float = 0.0;
	public var profile: String = "Round"; // "Round","Square"

	public function new() {}
}

enum abstract HomingFeature(String) from String {
	final None;
	final Bar;
	final Dot;
	final Scoop;
}
