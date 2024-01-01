package viewport;

class PlaceKey extends Action {
	var viewport: Viewport;
	var shape: String;
	var x: Float;
	var y: Float;

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
		viewport.drawKey(viewport.keyboard.addKey(shape, [x, y], shape));
		super.act();
	}
}
