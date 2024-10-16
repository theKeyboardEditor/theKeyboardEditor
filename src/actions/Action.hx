package actions;

import ceramic.Entity;

/**
 * This class represents a user-caused action that will be placed in a stack/queue
 * We use this as a way to handle undo/redo
 * Look up "Command Pattern" for more information
 */
class Action extends Entity {
	public var queueReversable = true;
	@event function actionCompleted();

	//	@event function actionReverted();

	public function new() {
		super();
	}

	public function act(type: ActionType): Void {
		emitActionCompleted();
	}

	public function undo(): Void {
		emitActionCompleted();
	}
}
