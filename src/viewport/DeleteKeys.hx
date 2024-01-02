package viewport;

class DeleteKeys extends Action {
	final viewport: Viewport;
	var deleted: Array<keyson.Keyson.Key> = [];

	override public function new(viewport: Viewport) {
		super();
		this.viewport = viewport;
	}

	override public function act() {
		for (key in viewport.selected.keys()) {
			this.deleted.push(viewport.selected[key].represents);
			// First deselect everything
			viewport.selected[key].select();
			viewport.selected[key].dispose();
			// Delete from viewport renderer
			viewport.selected.remove(key);
			// and finally delete from the keyson
			viewport.keyboard.removeKey(key);
			// We delete as last so the previous actions have a target to act upon!
		}
		super.act();
	}

	override public function undo() {
		for (key in deleted) {
			this.viewport.drawKey(viewport.keyboard.addKey(key.shape, key.position, key.shape));
		}
	}
}
