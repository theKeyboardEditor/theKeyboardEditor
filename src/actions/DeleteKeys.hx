package actions;

import viewport.Viewport;
import keyson.Keyson;

class DeleteKeys extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	var deletees: Array<KeyRenderer>;

	override public function new(viewport: Viewport, device: keyson.Keyboard, deletees: Array<KeyRenderer>) {
		super();
		this.viewport = viewport;
		this.device = device;
		this.deletees = deletees.copy();
	}

	override public function act(type: ActionType) {
			for (member in deletees) {
			// clear keyson:
			this.device.removeKey(member.sourceKey);
			// toggle selection status:
			member.select();
			// clear Ceramic:
			this.viewport.workSurface.remove(member);
		}
		super.act(type);
	}

	override public function undo() {
		for (member in deletees) {
			// recreate keyson:
			this.device.insertKey(member.sourceKey);
			// recreate Ceramic:
			this.viewport.workSurface.add(member);
		}
	}
}
