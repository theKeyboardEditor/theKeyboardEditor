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
			this.deleted.push(key);
			// First deselect everything
			viewport.selected[key].select();
			// Delete from viewport renderer
			viewport.universe.remove(viewport.selected[key]);
			viewport.selected[key].destroy();
			// and finally delete from the keyson
			viewport.keyboard.keys.remove(key);
		}
		super.act();
	}

	override public function undo() {
		for (key in deleted) {
			this.viewport.keyboard.keys.push(key);
			this.viewport.drawKey(key);
		}
	}
}
