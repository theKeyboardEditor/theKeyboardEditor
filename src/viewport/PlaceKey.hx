package viewport;

class PlaceKey extends Action {
	var viewport: Viewport;
	var key: keyson.Keyson.Key;
	var renderedKey: ceramic.Visual;
	final shape: String;
	final x: Float;
	final y: Float;

	override public function new(viewport: Viewport, x: Float, y: Float, shape: String) {
		super();
		this.viewport = viewport;
		this.x = x;
		this.y = y;
		// we take shape for input what actual key to place
		this.shape = shape;
	};

	override public function act() {
		// Create a keyson key
		this.key = viewport.keyboard.addKey(shape, [x, y], shape);
		// Draw that key
		this.renderedKey = this.viewport.drawKey(this.key);
		trace("ADDING",this.viewport.keyboard.keys);
		super.act();
	}

	override public function undo() {
		trace("UNADDING BEFORE:",this.viewport.keyboard.keys);
		this.viewport.keyboard.keys.remove(this.key);
		trace("UNADDED:",this.viewport.keyboard.keys);
		this.renderedKey.dispose();
	}
}
