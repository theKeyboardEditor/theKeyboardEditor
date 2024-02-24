package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class ColorBody extends Action {
	final viewport: Viewport;
	var coloredKeys: keyson.Keyboard; // we store data in here
	var colorees: Array<KeyRenderer>; // we access keys thru this
	final color: ceramic.Color; // in 1U keyson units

	override public function new(viewport: Viewport, colorees: Array<KeyRenderer>, color: ceramic.AlphaColor) {
		super();
		this.viewport = viewport;
		this.colorees = colorees;
		this.color = color;
	};

	override public function act(type: ActionType) {
		final cloner = new cloner.Cloner();
		if (type != Redo) {
			// severe any entanglement with the buffer and placed elements:
			// this can't be final we store information for undo here
			final tempKeyboard = new Keyboard();
			for (member in colorees) {
				tempKeyboard.insertKey(member.sourceKey);
			}
			coloredKeys = cloner.clone(tempKeyboard);
			// we use this to preserve only color attributes for undo
		}
		for (k in this.colorees) {
			// add to keyson:
			k.sourceKey.keysColor = '${this.color}';
			// the ceramic on screen representation object
			k.topColor = Std.parseInt(k.sourceKey.keysColor);
			k.bottomColor = KeyMaker.getKeyShadow(Std.parseInt(k.sourceKey.keysColor));
		}
		super.act(type);
	}

	override public function undo() {
		// restore by the recorded keycapSet shapes:
		for (member in this.coloredKeys.keys) {
			for (k in this.colorees) {
				if (k.sourceKey.legends[0].legend == member.legends[0].legend) {
					if (member.keysColor != null) {
						k.sourceKey.keysColor = member.keysColor;
					} else { // it's undefined, so it's default
						k.sourceKey.keysColor = this.viewport.keyson.units[this.viewport.currentUnit].keysColor;
					}
					k.topColor = Std.parseInt(k.sourceKey.keysColor);
					k.bottomColor = KeyMaker.getKeyShadow(Std.parseInt(k.sourceKey.keysColor));
				}
			}
		}
		super.undo();
	}
}
