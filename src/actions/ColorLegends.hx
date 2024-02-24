package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class ColorLegends extends Action {
	final viewport: Viewport;
	var coloredKeyLegends: keyson.Keyboard; // we store data in here
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
			coloredKeyLegends = cloner.clone(tempKeyboard);
			// we use this to preserve only color attributes for undo
		}
		for (k in this.colorees) {
			for (eachLegend in 0...k.legends.length) {
				// add to keyson:
				k.sourceKey.legends[eachLegend].legendColor = '${this.color}';
				// the ceramic on screen representation object
				k.legends[eachLegend].color = Std.parseInt(k.sourceKey.legends[eachLegend].legendColor);
			}
		}
		super.act(type);
	}

	override public function undo() {
		// restore by the recorded keycapSet shapes:
		for (member in this.coloredKeyLegends.keys) {
			for (k in this.colorees) {
				if (k.sourceKey.legends[0].legend == member.legends[0].legend) {
					for (eachLegend in 0...k.legends.length) {
						if (member.legends[eachLegend].legendColor != null) {
							k.sourceKey.legends[eachLegend].legendColor = member.legends[eachLegend].legendColor;
						} else { // it's undefined, so it's default
							k.sourceKey.legends[eachLegend].legendColor = this.viewport.keyson.units[this.viewport.currentUnit].legendColor;
						}
						k.legends[eachLegend].color = Std.parseInt(k.sourceKey.legends[eachLegend].legendColor);
					}
				}
			}
		}
		super.undo();
	}
}
