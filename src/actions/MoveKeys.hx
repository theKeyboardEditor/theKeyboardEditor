package actions;

import viewport.Viewport;
import keyson.Keyson;

class MoveKeys extends Action {
	var activeProject: Keyson;
	var keys: Array<KeyRenderer>;
	var destinations: Array<Float>;

	override public function new(activeProject: Keyson, keys: Array<KeyRenderer>, destinations: Array<Float>) {
		super();
		this.activeProject = activeProject;
		this.keys = keys;
		this.destinations = destinations;
	}

	override public function act() {
		trace('Move in:[${this.activeProject.name}] objects:${keys} to: ${destinations}');
		//TODO check for origin pos
		super.act();
	}

	override public function undo() {
		trace("Boop beep");
	}
}
