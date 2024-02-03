package actions;

import ceramic.Entity;
import keyson.Keyson.Keyboard;

/**
 * This class represents a user-caused action that will be placed in a stack/queue
 * We use this as a way to handle undo/redo
 * Look up "Command Pattern" for more information
 */
class Action extends Entity {
	@event function actionCompleted();

	//	@event function actionReverted();

	public function new() {
		super();
	}

	public function act(): Void {
		emitActionCompleted();
	}

	public function undo(): Void {
		emitActionCompleted();
	}

	public function redo(): Void {
		emitActionCompleted();
	}
}
