package actions;

mport viewport.Viewport;
import keyson.Keyson;
import keyson.Axis;

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
			for (unit in viewport.keyson.units) {
				// clear keyson:
				this.viewport.keyson.units[unit].removeKey(member.sourceKey);
				// clear Ceramic:
				this.viewport.workKeyboard.dispose(member);
			}
		}
		super.act();
	}

	override public function undo() {
		for (member in deleted) {
			for (unit in viewport.keyson.units) {
				// recreate keyson:
				this.viewport.keyson.units[unit].addKey(member.sourceKey);
				// recreate Ceramic:
				this.viewport.workKeyboard.add(member);
			}
		}
	}
