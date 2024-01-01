package viewport;

import ceramic.Entity;

class DeleteKeys extends Action {
	var viewport: Viewport;

	override public function new(viewport: Viewport) {
		super();
		this.viewport = viewport;
	}; 

	override public function act() {
		for (key in viewport.selected.keys()) {
			// First deselect everything
			viewport.selected[key].select();
			viewport.selected[key].dispose();
			// Delete from the keyson
			viewport.keyboard.removeKey(key);
			// Delete from viewport renderer
			viewport.selected.remove(key);
		}
		super.act();
	}
}
