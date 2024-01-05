package keyson;

/**
	** Conversion from a theKeyboardEditor keyboard design object into JSON string and back
	**  https://github.com/theKeyboardEditor/keyson
**/
class Keyson {
	// the version string for later compatibility tracking:
	public static var version = "0.1-alpha";

	// public vars (for the load and save content and flags)
	public var name: String;
	public var author: String;
	public var license: String;
	public var comment: String;
	public var colorTable: Palette;
	public var unit: Array<Keyboard>;

	@:jignored public static var tabulation: String = "	"; // keyson output indentation

	public function new() { // initialize our object with sane defaults
		name = "unknown";
		author = "unknown";
		license = "CC";
		comment = "empty";
		colorTable = new Palette();
		unit = [new Keyboard()]; // one of keyboard rulerUnits
	}

	/** The parser and the encoder
		** Maybe we move one day to TJSON (tolerant json parser) instead?
	**/
	public static function parse(data: String) {
		var parser = new json2object.JsonParser<Keyson>();
		var object: Keyson;
		object = parser.fromJson(data);
		return object;
	}

	public static function encode(object: Keyson) {
		var writer = new json2object.JsonWriter<Keyson>();
		var data = writer.write(object, tabulation);
		return data;
	}
}

class Palette {
	public var name: String;
	public var url: String;
	public var colorMatchingProfile: String;
	public var size: Int;
	public var swatches: Array<Color>;

	public function new() {
		this.name = "unknown";
		this.url = "unknown";
		this.colorMatchingProfile = "none";
		this.size = 1; // amount of colors
		this.swatches = [new Color("BLACK", "0x00000000")]; // the names are for humans only
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

/** Keyboard:
	** Each of a Split keyboard's rulerUnits with a numpad and a joypad (4 sub rulerUnits)
	** Each of wo halves wirelessly connected to a host via bluetooth
	** Or just a common single unit keyboard
**/
class Keyboard {
	public var id: Int;
	public var designator: String;
	public var keyStep: Array<Float>;
	public var stabilizerType: String;
	public var switchType: String;
	public var capSize: Array<Float>; // in rulerUnits of measurement
	public var rulerUnits: String; // units of real world measurement
	public var caseColor: String; // it is a binary value
	public var keysColor: String; // it is a binary value
	public var labelSizeUnits: String; // "px,pc,mm,thou,U/100"
	public var keyboardFont: String;
	public var keyboardFontSize: Float;
	public var legendColor: String; // it is a binary value
	public var legendPosition: Array<Float>;
	public var profile: String;
	public var keySculpt: String;
	public var position: Array<Float>; // case/element position
	public var angle: Array<Float>; // maybe one day we will be 3D
	public var relativeRotationCenter: Array<Float>; // case center offset
	public var size: Int; // number of keys/elements
	public var keys: Array<Key>;

	public function new() { // empty default keyboard
		this.designator = "default"; // "Master", "Slave", "Numpad" ...
		this.keyStep = [19.05, 19.05];
		this.stabilizerType = "";
		this.switchType = "";
		this.capSize = [18.5, 18.5]; // some usually expected values
		this.rulerUnits = "mm"; // important!
		this.caseColor = "0xFFFCFCFC"; // shadow of withe
		this.keysColor = "0xFFFFFFFF"; // blinding withe
		this.labelSizeUnits = "U/100"; // "px,pc,mm,thou,U/100"
		this.keyboardFont = '|Empty|'; // placeholder
		this.keyboardFontSize = 24; // somewhat sane default
		this.legendColor = "0xFF000000"; // we default to black
		this.legendPosition = [0.0, 0.0];
		this.profile = "OEM";
		this.keySculpt = "R3";
		this.position = [0.0, 0.0]; // placement of the unit
		this.angle = [0, 0, 0]; //  rotation around the anchor point
		this.size = 0; // initial number of keys/elements
		this.keys = [];
	}

	public function addKey(shape: String, pos: Array<Float>, leg: String): Key {
		// calculate a new ID
		var uid = this.keys.length;
		// define a new key:
		var key = new Key(uid, shape, pos, leg);
		// append the new key to the end of the array
		this.keys.push(key);
		// now sort for Y and X coordinates:
		// to get Y placement take precedence we will premultiply Y by 128
		// naively (assuming no keyboard will ever have more than 128 keys in one row)
		// the difference resolution is 25/100 (a hundredth of a quarter)
		this.keys.sort(function (a , b) return ( Std.int((a.position[0] + 128 * a.position[1]) * 25) - Std.int((b.position[0] + 128 * b.position[1]) * 25) ) );
		var i: Int = 0;
		//sort out ids
		this.keys = [
			for (k in this.keys) {
				k.id = i++;
				k;
			}
		];
		// trace(keys);
		return key;
	}

	public inline function removeKey(id: Int) {
		var i: Int = 0;
		this.keys = [
			for (key in this.keys.filter(key -> key.id != id)) {
				key.id = i++;
				key;
			}
		];
	}
}

/** The actual tactile unit of interaction
**/
class Key {
	public var id: Int;
	public var position: Array<Float>;
	public var stabilizer: String;
	public var angle: Float;
	public var shape: String;
	public var legendPosition: String;
	public var relativeRotationCenter: Array<Float>;
	public var features: Array<String>;
	public var steppedTop: Float;
	public var homingFeature: String;
	public var keysColor: String;
	public var spacerSize: Array<Float>;
	public var amountOfLegends: Int;
	public var legends: Array<KeyLegend>;

	public function new(id: Int, shape: String, position: Array<Float>, legend: String) {
		this.id = id; // unique key ID
		this.position = position; // place on the unit
		this.stabilizer = "None"; // "None","2U","2.25U","2.75U","6.25U","7.25U",(Custom Bar)"125.5"
		this.angle = 0.0;
		this.shape = shape; // "1U","2U","2U vertical","1.25U","1.5U","1.75U","2.25U","2.75U","ISO","BAE","6.25U","7.25U","3U","0.75U"
		this.legendPosition = "";
		this.relativeRotationCenter = [0.0, 0.0];
		this.features = []; // "Stepped","Window","Homing","Spacer","Comment","Shadow","LED","OLED","LCD","Encoder","Trackpoint","Trackpad"
		this.steppedTop = 0.0; // by it's size we reconstruct the type
		this.homingFeature = ""; // "Bar", "Dot", "Sculpt"
		this.spacerSize = [0.0, 0.0]; // in units of U (1 x 2 U)
		this.keysColor = "0xFFFFFFFF";
		this.amountOfLegends = 1;
		this.legends = [];

		this.legends.push(new KeyLegend(legend));
	}

	public function addLegend(symbol: String, position: Array<Float>) {
		var newLegend = new KeyLegend(symbol);
	}
}

/** The sign/symbol on the unit
**/
class KeyLegend {
	// the Keyboard options or here define their own
	public var legend: String;
	public var legendSize: Int;
	public var legendColor: String;
	public var legendPosition: Array<Float>;
	public var symbol: String;

	public function new(symbol: String) {
		this.legend = "";
		this.legendSize = 24; // sane default
		this.legendColor = "0xFF00000f";
		this.legendPosition = [5.0, 5.0];
		this.symbol = symbol;
	}
}

/*
 * Various key position features/replacements and their
 * respective properties:
**/
// TODO do we want actual separate features or will we mimick them with standard keycap features instead?

/** The Actual Keyboard status led
**/
class LEDFeature {
	public var diameter: Float; // diameter usually 3.0 or 5.0 mm
}

class EncoderFeature {
	public var diameter: Float; // in unit size
	public var barrelSize: Float; // height/length in rulerUnits size
	public var profile: String; // "Round" "Curled" "Ribbed"
	public var type: String; // axis:"Upright" "Barrel X" "Barrel Y"

	public function new() {
		diameter = 0.0;
		barrelSize = 0.0;
		profile = "";
		type = "";
	}
}

class TrackpointFeature {
	public var diameter: Float;
	public var profile: String; // "Round","Square"

	public function new() {
		diameter = 0.0;
		profile = "";
	}
}
