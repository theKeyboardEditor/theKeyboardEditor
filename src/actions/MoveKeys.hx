package actions;

import viewport.Viewport;
import keyson.Keyson;

class MoveKeys extends Action {
	var activeProject: Keyson;
	var keys: Array<KeyRenderer>;
	var deltaX: Float;
	var deltaY: Float;

	override public function new(activeProject: Keyson, keys: Array<KeyRenderer>, deltaX: Float, deltaY: Float) {
		super();
		this.activeProject = activeProject;
		this.keys = keys;
		this.deltaX = deltaX;
		this.deltaY = deltaY;
	}

	override public function act() {
		trace('Move in:[${this.activeProject.name}] objects:${keys} for: [${deltaX},${deltaY}]');
		//TODO check for origin pos to store to undo
		for ( member in keys) {
			for ( unit in activeProject.units) {
				for ( key in unit.keys) {
					if ( member.sourceKey == key ) {
						trace ('Found ${member.sourceKey.legends[0].legend} as ${key.legends[0].legend}!');
						// TODO move for the offset!
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
