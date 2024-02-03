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
//		final tracked = [];
		for (member in this.moved) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						trace('move: [$member].');
						// since our key is already moved by the desinger we only update keyson:
						key.position[Axis.X] += this.deltaX;
						key.position[Axis.Y] += this.deltaY;
					}
				}
			}
//			tracked.push(member);
		}
//		final moved = [];
		super.act();
	}

	override public function undo() {
//		for (member in tracked) {
		for (member in this.moved) {
			for (unit in viewport.keyson.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						trace('undo move: [$member].');
						key.position[Axis.X] -= this.deltaX;
						key.position[Axis.Y] -= this.deltaY;
						// undo moving the member too:
						member.x -= this.deltaX * this.viewport.unit;
						member.y -= this.deltaY * this.viewport.unit;
					}
				}
			}
//			moved.push(member);
		}
//		final tracked = [];
		super.undo();
	}
}
