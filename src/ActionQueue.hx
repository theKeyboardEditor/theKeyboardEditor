package;

import actions.Action;

/**
 * This is a data structure that is used for saving and executing different "actions"
 * These actions can range anything from placing a key to changing the color
 * We can use this to handle undo/redo by reconstructing the "base" from the beginning
 */
class ActionQueue {
	var queue: Array<Action> = [];
	var applied: Array<Action> = [];

	public function new() {}

	public function act() {
		if (queue.length > 0) {
			final action = this.queue.pop();
			action.act();
			this.applied.push(action);
			trace(applied);
			StatusBar.inform('Applied action: $action [${applied.length}]');
		}
	}

	public inline function undo() {
		if (applied.length > 0) {
			var action = this.applied.pop();
			action.undo();
			StatusBar.inform('Reverted previous action: $action [${applied.length}]');
		} else {
			StatusBar.error('No action to undo [${applied.length}]');
		}
	}

	public function push(a: Action) {
		this.queue.push(a);
	}
}
