package actions;

import viewport.Viewport;

class DeleteKeys extends Action {
	final viewport: Viewport;
	var deleted: Array<KeyRenderer>;

	override public function new(viewport: Viewport, deleted: Array<KeyRenderer>) {
		super();
		this.viewport = viewport;
		this.deleted = deleted.copy();
	}

	override public function act(type: ActionType) {
		// if (type == Redo) {
		// }
		// TODO is here any difference with act and redo?

		for (member in deleted) {
			for (u in this.viewport.keyson.units) {
				// clear keyson:
				u.removeKey(member.sourceKey);
				// clear Ceramic:
				this.viewport.workSurface.remove(member);
			}
		}
		super.act(type);
	}

	override public function undo() {
		for (member in deleted) {
			for (u in this.viewport.keyson.units) {
				// recreate keyson:
				u.pushKey(member.sourceKey);
				// recreate Ceramic:
				this.viewport.workSurface.add(member);
			}
		}
	}
}
