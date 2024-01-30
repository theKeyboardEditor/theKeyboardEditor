package actions;

import viewport.Viewport;

class MoveKeys extends Action {
	final viewport: Viewport;
	final keys: Array<KeyRenderer>;
	final to: Array<Int>;

	override public function new(viewport: Viewport, keys: Array<KeyRenderer>, to: Array<Int>) {
		super();
		this.viewport = viewport;
		this.keys = keys;
		this.to = to;
	}

	override public function act() {
		trace("Beep boop");
		super.act();
	}

	override public function undo() {
		trace("Boop beep");
	}
}
