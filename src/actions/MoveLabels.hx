package actions;

import viewport.Viewport;
import keyson.Axis;

class MoveLabels extends Action {
	final viewport: Viewport;
	var movees: Array<LegendRenderer>;
	// in the sense of keyson 1U units
	final deltaX: Float;
	final deltaY: Float;

	override public function new(viewport: Viewport, movees: Array<LegendRenderer>, deltaX: Float, deltaY: Float) {
		super();
		this.viewport = viewport;
		this.movees = movees.copy();
		this.deltaX = deltaX;
		this.deltaY = deltaY;
	}

	override public function act(type: ActionType) {
		for (member in movees) {
			// TODO make this work for labels
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					for (label in key.legends) {
						if (member.sourceLegend == label) {
							// TODO the math is off!
							trace ('Offset: ${this.deltaX}/${this.deltaY}');
							label.position[Axis.X] += this.deltaX;
							label.position[Axis.Y] += this.deltaY;
							if (type == Redo) {
								member.x += this.deltaX * this.viewport.unit;
								member.y += this.deltaY * this.viewport.unit;
							}
						}
					}
				}
			}
		}
		super.act(type);
	}

	override public function undo() {
		for (member in movees) {
			// TODO make this work for labels
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					for (label in key.legends) {
						if (member.sourceLegend == label) {
							label.position[Axis.X] -= this.deltaX;
							label.position[Axis.Y] -= this.deltaY;
							member.x -= this.deltaX * this.viewport.unit;
							member.y -= this.deltaY * this.viewport.unit;
						}
					}
				}
			}
		}
		super.undo();
	}
}
