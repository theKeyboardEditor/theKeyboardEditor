package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class MoveKeys extends Action {
	final viewport: Viewport;
	final moved: Array<KeyRenderer>;
	final tracked: Array<KeyRenderer>;
	final deltaX: Float; // in keyson 1U units
	final deltaY: Float;

	override public function new(viewport: Viewport, moved: Array<KeyRenderer>, deltaX: Float, deltaY: Float) {
		super();
		this.viewport = viewport;
		this.moved = moved;
		this.tracked = [];
		this.deltaX = deltaX;
		this.deltaY = deltaY;
	}

	override public function act() {
		final tracked = [];
		for (member in moved) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						key.position[Axis.X] += deltaX;
						key.position[Axis.Y] += deltaY;
					}
				}
			}
		tracked.push(member);
		}
		final moved = [];
		super.act();
	}

	override public function undo() {
		for (member in tracked) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						key.position[Axis.X] -= deltaX;
						key.position[Axis.Y] -= deltaY;
					}
				}
			}
			moved.push(member);
		}
		final tracked = [];
		super.undo();
	}
}
