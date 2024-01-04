package viewport;

class PlaceKey extends Action {
	var viewport: Viewport;
	var key: KeyRenderer;
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
		// place the ordered key
		this.key = this.viewport.drawKey(viewport.keyboard.addKey(shape, [x, y], shape));
		// TODO apply settings
		super.act();
	}

	override public function undo() {
		this.viewport.universe.remove(this.key);
		this.viewport.keyboard.remove(this.key);
		this.key.dispose();
	}
}
