package actions;

import viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

class MoveKeys extends Action {
	final activeProject: Keyson;
	final keys: Array<KeyRenderer>;
	final deltaX: Float; // in keyson 1U units
	final deltaY: Float;

	override public function new(activeProject: Keyson, keys: Array<KeyRenderer>, deltaX: Float, deltaY: Float) {
		super();
		this.activeProject = activeProject;
		this.keys = keys;
		this.deltaX = deltaX;
		this.deltaY = deltaY;
	}

	override public function act() {
		for (member in keys) {
			for (unit in activeProject.units) {
				for (key in unit.keys) {
					if (member.sourceKey == key) {
						key.position[Axis.X] += deltaX;
						key.position[Axis.Y] += deltaY;
					}
				}
			}
		}
		super.act();
	}

	override public function undo() {
		trace("Boop beep");
	}
}
