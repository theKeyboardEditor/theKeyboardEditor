package viewport;

import ceramic.Entity;

/**
 * This class represents a user-caused action that will be placed in a stack/queue
 * We use this as a way to handle undo/redo
 */
class Action extends Entity {
	@event function actionCompleted();
	public function new() {
		super();
	}
	public function act(): Void {
		emitActionCompleted();
	}
}
