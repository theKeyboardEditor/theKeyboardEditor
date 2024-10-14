package actions;

import viewport.Viewport;
import keyson.Axis;

class MoveKeys extends Action {
	final viewport: Viewport;
	var movees: Array<Keycap>;
	// in the sense of keyson 1U units
	final deltaX: Float;
	final deltaY: Float;

	override public function new(viewport: Viewport, movees: Array<Keycap>, deltaX: Float, deltaY: Float) {
		super();
		this.viewport = viewport;
		this.movees = movees.copy();
		this.deltaX = deltaX;
		this.deltaY = deltaY;
	}

	override public function act(type: ActionType) {
		for (member in movees) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						key.position[Axis.X] += this.deltaX;
						key.position[Axis.Y] += this.deltaY;
						if (type == Redo) {
							member.x += this.deltaX * this.viewport.unit;
							member.y += this.deltaY * this.viewport.unit;
						}
					}
				}
			}
		}
		super.act(type);
	}

	override public function undo() {
		for (member in movees) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						key.position[Axis.X] -= this.deltaX;
						key.position[Axis.Y] -= this.deltaY;
						member.x -= this.deltaX * this.viewport.unit;
						member.y -= this.deltaY * this.viewport.unit;
					}
				}
			}
		}
		super.undo();
	}
}
