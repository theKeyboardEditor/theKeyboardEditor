package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class ColorBody extends Action {
	final viewport: Viewport;
	var coloredKeys: keyson.Keyboard; // we store data in here
	var targets: Array<Keycap>; // we access keys thru this
	final color: ceramic.Color; // in 1U keyson units

	override public function new(viewport: Viewport, targets: Array<Keycap>, color: ceramic.AlphaColor) {
		super();
		this.viewport = viewport;
		this.targets = targets;
		this.color = color;
	};

	override public function act(type: ActionType) {
		final cloner = new cloner.Cloner();
		if (type != Redo) {
			// severe any entanglement with the buffer and placed elements:
			// this can't be final we store information for undo here
			final tempKeyboard = new Keyboard();
			for (member in targets) {
				tempKeyboard.insertKey(member.sourceKey);
			}
			coloredKeys = cloner.clone(tempKeyboard);
			// we use this to preserve only color attributes for undo
		}
		for (k in this.targets) {
			// add to keyson:
			k.sourceKey.color = '${this.color}';
			// the ceramic on screen representation object
			k.topColor = Std.parseInt(k.sourceKey.color);
			k.bottomColor = KeyMaker.getKeyShadow(Std.parseInt(k.sourceKey.color));
		}
		super.act(type);
	}

	override public function undo() {
		// restore by the recorded keyboard shapes:
		for (member in this.coloredKeys.keys) {
			for (k in this.targets) {
				if (k.sourceKey.legends[0].legend == member.legends[0].legend) {
					if (member.color != null) {
						k.sourceKey.color = member.color;
					} else { // it's undefined, so it's default
						k.sourceKey.color = this.viewport.keyson.units[this.viewport.focusedUnit].defaults.keyColor;
					}
					k.topColor = Std.parseInt(k.sourceKey.color);
					k.bottomColor = KeyMaker.getKeyShadow(Std.parseInt(k.sourceKey.color));
				}
			}
		}
		super.undo();
	}
}
