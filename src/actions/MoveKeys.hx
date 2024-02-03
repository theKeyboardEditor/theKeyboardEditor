package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class MoveKeys extends Action {
	final viewport: Viewport;
	final moved: Array<KeyRenderer>;
	final deltaX: Float; // in keyson 1U units
	final deltaY: Float;

	override public function new(viewport: Viewport, moved: Array<KeyRenderer>, deltaX: Float, deltaY: Float) {
		super();
		this.viewport = viewport;
		this.moved = moved;
		this.deltaX = deltaX;
		this.deltaY = deltaY;
	}

	override public function act() {
		for (member in moved) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						trace('move: [${member.sourceKey.legends[0].legend}] d[${this.deltaX}/${this.deltaY}].');
						// since our key is already moved by the desinger we only update keyson:
						key.position[Axis.X] += this.deltaX;
						key.position[Axis.Y] += this.deltaY;
					}
				}
			}
		}
		super.act();
	}

	override public function undo() {
		trace ('undoing: [${moved.length}] members.');
		for (member in moved) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						trace('undo move: [${member.sourceKey.legends[0].legend}] d[${this.deltaX}/${this.deltaY}].');
						key.position[Axis.X] -= this.deltaX;
						key.position[Axis.Y] -= this.deltaY;
						// undo moving the member too:
						member.x -= this.deltaX * this.viewport.unit;
						member.y -= this.deltaY * this.viewport.unit;
					}
				}
			}
		}
		super.undo();
	}

	override public function redo() {
		for (member in moved) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						trace('undo move: [${member.sourceKey.legends[0].legend}] d[${this.deltaX}/${this.deltaY}].');
						key.position[Axis.X] += this.deltaX;
						key.position[Axis.Y] += this.deltaY;
						// undo moving the member too:
						member.x += this.deltaX * this.viewport.unit;
						member.y += this.deltaY * this.viewport.unit;
					}
				}
			}
		}
		super.redo();
	}
}
