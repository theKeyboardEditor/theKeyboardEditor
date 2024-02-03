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
	var unapplied: Array<Action> = [];

	public function new() {}

	public function act() {
		if (queue.length > 0) {
			final action = this.queue.pop();
			action.act();
			this.applied.push(action);
			StatusBar.inform('Applied action: $action [${applied.length}]');
		}
	}

	public inline function undo() {
		if (applied.length > 0) {
			var action = this.applied.pop();
			action.undo();
			this.unapplied.push(action);
			StatusBar.inform('Reverted previous action: $action [U:${applied.length}/R:${unapplied.length}]');
		} else {
			StatusBar.error('No action to undo [U:${applied.length}]');
		}
	}

	public inline function redo() {
		if (unapplied.length > 0) {
			var action = this.unapplied.pop();
			action.redo();
			this.applied.push(action);
			StatusBar.inform('Repeated previously undone action: $action [U:${applied.length}/R:${unapplied.length}]');
		} else {
			StatusBar.error('No undone action to redo [R:${unapplied.length}]');
		}
	}

	public function push(a: Action) {
		this.queue.push(a);
	}
}
