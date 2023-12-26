package;

import ceramic.InputMap;
import ceramic.Scene;
import ceramic.Visual;
import keyson.Keyson.Keyboard;

class Viewport extends Scene {
	var keyboard: Keyboard;
	var inputMap = new InputMap<ViewportInput>();

	// Everything inside the viewport is stored here
	var universe: Visual = new Visual();

	// Constants
	inline static var movementSpeed: Int = 500;
	inline static final unit = 100;

	// Used for zooming
	var originX: Float = 510;
	var originY: Float = 60;
	var keySize: Float = 0; // size of a key
	var widthNorth: Int;
	var heightNorth: Int;
	var widthSouth: Int;
	var heightSouth: Int;
	var offsetSouthX: Int;
	var offsetSouthY: Int;

	override public function new(keyboard: Keyboard) {
		super();
		this.keyboard = keyboard;
		this.universe = new Visual();
		this.universe.pos(originX, originY);

		// Define the inputs
		bindInput();
	}

	function bindInput() {
		inputMap.bindKeyCode(UP, UP);
		inputMap.bindKeyCode(DOWN, DOWN);
		inputMap.bindKeyCode(LEFT, LEFT);
		inputMap.bindKeyCode(RIGHT, RIGHT);
		// We use scan code for these so that it will work with non-qwerty layouts as well
		inputMap.bindScanCode(UP, KEY_W);
		inputMap.bindScanCode(DOWN, KEY_S);
		inputMap.bindScanCode(LEFT, KEY_A);
		inputMap.bindScanCode(RIGHT, KEY_D);
		// Zoom Time
		inputMap.bindScanCode(ZOOM_IN, EQUALS);
		inputMap.bindScanCode(ZOOM_OUT, MINUS);
	}

	override function create() {
		final gapX = Std.int((this.keyboard.keyStep[Axis.X] - this.keyboard.capSize[Axis.X]) / this.keyboard.keyStep[Axis.X] * unit);
		final gapY = Std.int((this.keyboard.keyStep[Axis.Y] - this.keyboard.capSize[Axis.Y]) / this.keyboard.keyStep[Axis.Y] * unit);
		final labelUnit = this.keyboard.labelSizeUnits;

		for (k in this.keyboard.keys) {
			var key: Dynamic;
			var keyLabel: LabelRenderer;
			keySize = 1; // reset to default

			// TODO: Create some form of syntax that can define this information without this switch case creature
			for (t in ["BAE", "ISO", "XT_2U", "AEK"]) { // the special shape cases
				if (k.shape.split(' ').indexOf(t) != -1) { // if shape found found go here
					// trace ("in:",k.shape,"found:", t);
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
					} // now that the appropriate values are assigned, we apply them:
					trace(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
					key = new keys.LShapeKey(widthNorth, heightNorth, widthSouth, heightSouth, offsetSouthX, offsetSouthY);
				}
			}
			keySize = Std.parseFloat(k.shape); // every valid size will get caught here
			if (!Math.isNaN(keySize)) {
				if (k.shape.split(' ').indexOf("Vertical") != -1) { // it's vertical!
					width = unit - gapX;
					height = unit * keySize - gapY;
					trace("|");
				} else {
					width = unit * keySize - gapX;
					height = unit - gapY;
					trace("-");
				}
				trace(width, height);
				key = new keys.RectangularKey(width, height);
			}
			key.pos(unit * k.position[Axis.X], unit * k.position[Axis.Y]);
			key.onPointerDown(key, (_) -> {
				key.select();
			});
			this.universe.add(key.create());

			// A ceramic visual does not inherit the size of it's children
			// Hence we must set it ourselves
			if (key.width + key.x > this.universe.width) {
				this.universe.width = key.width + gapX + key.x;
			} // we end up with the biggest value when the loop is over

			if (key.height + key.y > this.universe.height) {
				this.universe.height = key.height + gapY + key.y;
			}

			// Key label rendering pass
			var labelOffsetX: Float;
			var labelOffsetY: Float;
			for (l in k.labels) { // we can have many labels!
				keyLabel = new LabelRenderer(l.glyph);
				keyLabel.labelColor = 0xFF00000F;
				// is the label position set specifically?
				if (l.labelPosition != null) { // yes we adjust specifically
					labelOffsetX = l.labelPosition[Axis.X];
					labelOffsetY = l.labelPosition[Axis.Y];
				} else { // no we use the global coordinates
					labelOffsetX = this.keyboard.labelPosition[Axis.X];
					labelOffsetY = this.keyboard.labelPosition[Axis.Y];
				}
				// is the fontsize set specifically?
				if (l.labelFontSize != 0) { // TODO make this detect per key font change
					keyLabel.labelFontSize = l.labelFontSize;
				} else {
					keyLabel.labelFontSize = this.keyboard.keyboardFontSize;
				}

				keyLabel.depth = 4; // mae sure labels render on top

				keyLabel.pos(labelOffsetX + keyLabel.topX + unit * k.position[Axis.X],
					labelOffsetY + keyLabel.topY + unit * k.position[Axis.Y]);
				this.universe.add(keyLabel.create());
			}
		}
		this.add(universe);
	}

	final zoom = 2;

	override function update(delta: Float) {
		// Handle keyboard input.
		if (inputMap.pressed(UP)) {
			// this.universe.y += movementSpeed * delta;
			this.universe.y += 12.5;
		}
		if (inputMap.pressed(LEFT)) {
			// this.universe.x += movementSpeed * delta;
			this.universe.x += 12.5;
		}
		if (inputMap.pressed(DOWN)) {
			// this.universe.y -= movementSpeed * delta;
			this.universe.y -= 12.5;
		}
		if (inputMap.pressed(RIGHT)) {
			// this.universe.x -= movementSpeed * delta;
			this.universe.x -= 12.5;
		}
		// ZOOMING!
		if (inputMap.pressed(ZOOM_IN)) {
			//	this.universe.anchor(screen.pointerX / this.width, screen.pointerY / this.height);

			this.universe.scaleX += zoom * delta;
			this.universe.scaleY += zoom * delta;
			//	this.universe.anchor(0, 0);
		} else if (inputMap.pressed(ZOOM_OUT)) {
			//	this.universe.anchor(screen.pointerX / this.universe.width, screen.pointerY / this.universe.height);
			this.universe.scaleX -= zoom * delta;
			this.universe.scaleY -= zoom * delta;
			//	this.universe.anchor(0, 0);
		}
	}
}

enum abstract ViewportInput(Int) {
	var UP;
	var DOWN;
	var LEFT;
	var RIGHT;
	var ZOOM_IN;
	var ZOOM_OUT;
}

/**
 * We define the X and Y axes exclusively for convenience here
 * It will compile down to just X = 0, Y = 1
 */
enum abstract Axis(Int) to Int {
	var X;
	var Y;
}
