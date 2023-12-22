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
	public var board: Array<Keyboard>;

	@:jignored public static var tabulation: String = "	"; // keyson output indentation

	public function new() { // initialize our object with sane defaults
		name = "unknown";
		author = "unknown";
		license = "CC";
		comment = "empty";
		colorTable = new Palette();
		board = [new Keyboard()];
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
	public var squashes: Array<Color>;

	public function new() {
		this.name = "unknown";
		this.url = "unknown";
		this.colorMatchingProfile = "none";
		this.size = 1; // amount of colors
		this.squashes = [new Color("", "0x00000000")];
	}
}

class Color {
	public var color: String;
	public var value: String;

	public function new(color: String, value: String) {
		this.color = color;
		this.value = value;
	}
}

/** Keyboard:
	** The entirety of an HID device behind a connecting point on a host:
	** A Split keyboard with a numpad and a joypad (4 sub units)
	** all interconnected by a TRRS to each other or
	** a common single unit keyboard
**/
class Keyboard {
	public var keyboardID: Int;
	public var designator: String;
	public var keyStep: Array<Float>;
	public var stabilizerType: String;
	public var switchType: String;
	public var capSize: Array<Float>; // in units of measurement
	public var units: String; // units of measurement
	public var caseColor: String;
	public var keysColor: String;
	public var labelSizeUnits: String; // "px,pc,mm,thou"
	public var labelFont: String;
	public var sublabelFont: String;
	public var labelFontSize: Float;
	public var sublabelFontSize: Float;
	public var labelColor: String;
	public var labelPosition: Array<Float>;
	public var sublabelColor: String;
	public var profile: String;
	public var keySculpt: String;
	public var amountOfUnits: Int;
	public var position: Array<Float>; // case/element position
	public var angle: Array<Float>; // maybe one day we will be 3D
	public var relativeRotationCenter: Array<Float>; // case center offset
	public var size: Int;
	public var keys: Array<Key>;

	public function new() { // empty default keyboard
		this.designator = "default"; // "Master", "Slave", "Numpad" ...
		this.keyStep = [0.0, 0.0];
		this.stabilizerType = "";
		this.switchType = "";
		this.capSize = [0.0, 0.0];
		this.units = "mm";
		this.caseColor = "";
		this.keysColor = "";
		this.labelSizeUnits = "px"; // "px,pc,mm,thou"
		this.labelFont = "unknown";
		this.sublabelFont = "unknown";
		this.labelFontSize = 12; // somewhat sane default
		this.sublabelFontSize = 7; // questionably sane default
		this.labelColor = "";
		this.labelPosition = [0.0, 0.0];
		this.sublabelColor = "";
		this.profile = "Cherry";
		this.keySculpt = "R3";
		this.amountOfUnits = 1;
		this.position = [0.0, 0.0]; // placement of the unit
		this.angle = [0, 0, 0]; //     rotation around the anchor point
		this.size = 0; //          number of keys/elements
		this.keys = [];
	}

	public function addKey(shap: String, pos: Array<Float>, lab: String) {
		// calculate a new ID
		var uid = this.keys.length;
		// define a new key:
		var newKnob = new Key(uid, shap, pos, new Keyson.KeyLabel(lab));
		// append the new key to the end of the array
		this.keys.push(newKnob);
	}
}

/** The actual tactile unit of interaction
**/
class Key {
	public var keyId: Int;
	public var position: Array<Float>;
	public var stabilizer: String;
	public var angle: Float;
	public var shape: String;
	public var labelFont: String;
	public var relativeRotationCenter: Array<Float>;
	public var features: Array<String>;
	public var steppedTop: Float;
	public var homingFeature: String;
	public var keysColor: String;
	public var spacerSize: Array<Float>;
	public var label: KeyLabel;
	public var sublabels: Sublabel;

	public function new(keyId: Int, shape: String, position: Array<Float>, label: KeyLabel) {
		this.keyId = keyId; // unique key ID
		this.position = position; // place on the unit
		this.stabilizer = "None"; // "None","2U","2.25U","2.75U","6.25U","7.25U",(Custom Bar)"125.5"
		this.angle = 0.0;
		this.shape = shape; // "1U","2U","2U vertical","1.25U","1.5U","1.75U","2.25U","2.75U","ISO","BAE","6.25U","7.25U","3U","0.75U"
		this.labelFont = "";
		this.relativeRotationCenter = [0.0, 0.0];
		this.features = []; // "Stepped","Window","Homing","Spacer","Comment","Shadow","LED","OLED","LCD","Encoder","Trackpoint","Trackpad"
		this.steppedTop = 0.0;
		this.homingFeature = ""; // "Bar", "Dot", "Sculpt"
		this.spacerSize = [0.0, 0.0]; // in units of U (1 x 2 U)
		this.keysColor = "";
		this.label = label;
		this.sublabels = new Sublabel();
	}
}

/** The sign/glyph on the unit
**/
class KeyLabel {
	// the Keyboard options or here define their own
	public var keysColor: String;
	public var labelFont: String;
	public var labelFontSize: Int;
	public var labelColor: String;
	public var labelPosition: Array<Float>;
	public var profile: String;
	public var keySculpt: String;
	public var glyph: String;

	public function new(glyph: String) {
		this.keysColor = "";
		this.labelFont = "";
		this.labelFontSize = 12; // sane default
		this.labelColor = "";
		this.labelPosition = [0.0, 0.0];
		this.profile = "";
		this.keySculpt = "";
		this.glyph = glyph;
	}
}

/** The secondary sign on the unit, usually with different properties
	** as shape, font, encoding...
**/
// TODO do we want actual sublabels or we better be served with
// peer equal individual glyphs in an array?

class Sublabel {
	// the Keyboard options or here define their own
	public var sublabelFont: String;
	public var sublabelFontSize: Int;
	public var sublabelColor: String;

	public var positions: Array<String>; // the 9 positions on a key

	public function new() {
		sublabelFont = "";
		sublabelFontSize = 7; // sane default
		sublabelColor = "";
		positions = ["", "", "", "", "", "", "", "", ""];
	}
}

/*
 * Various key position features/replacements and their
 * respective properties:
**/
/** The Actual Keyboard status led
**/
class LEDFeature {
	public var diameter: Float; // diameter usually 3.0 or 5.0 mm
}

class EncoderFeature {
	public var diameter: Float; // in unit size
	public var barrelSize: Float; // height/length in units size
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
