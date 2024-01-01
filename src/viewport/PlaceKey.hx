package viewport;

class PlaceKey extends Action {
	var viewport: Viewport;
	var x: Float;
	var y: Float;

	override public function new(viewport: Viewport, x: Float, y: Float) {
		super();
		this.viewport = viewport;
		this.x = x;
		this.y = y;
	}; 

	override public function act() {
		viewport.drawKey(viewport.keyboard.addKey("1U", [x, y], "1U"));
		super.act();
	}
}
