package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class ColorLegend extends Action {
	final viewport: Viewport;
	var coloredKeyLegends: keyson.Keyboard; // we store data in here
	final legendIndex: Int;
	var colorees: Array<KeyRenderer>; // we access keys thru this
	final color: ceramic.Color; // in 1U keyson units

	override public function new(viewport: Viewport, colorees: Array<KeyRenderer>, legendIndex: Int, color: ceramic.AlphaColor) {
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
			coloredKeyLegends = cloner.clone(tempKeyboard);
			// we use this to preserve only color attributes for undo
		}
		for (k in this.colorees) {
			// add to keyson:
			k.sourceKey.legends[legendIndex].legendColor = '${this.color}';
			// the ceramic on screen representation object
			k.legends[legendIndex].color = Std.parseInt(k.sourceKey.legends[legendIndex].legendColor);
		}
		super.act(type);
	}

	override public function undo() {
		// restore by the recorded keycapSet shapes:
		for (member in this.coloredKeyLegends.keys) {
			for (k in this.colorees) {
				if (k.sourceKey.legends[0].legend == member.legends[0].legend) {
					if (member.legends[eachLegend].legendColor != null) {
						k.sourceKey.legends[legendIndex].legendColor = member.legends[legendIndex].legendColor;
					} else { // it's undefined, so it's default
						k.sourceKey.legends[legendIndex].legendColor = this.viewport.keyson.units[this.viewport.currentUnit].legendColor;
					}
					k.legends[legendIndex].color = Std.parseInt(k.sourceKey.legends[legendIndex].legendColor);
				}
			}
		}
		super.undo();
	}
}
