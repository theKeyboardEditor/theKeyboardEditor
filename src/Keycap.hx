package;

class Keycap extends ceramic.Visual {
	@content public var topColor: ceramic.Color;
	@content public var bottomColor: ceramic.Color;
	@content public var legends: Array<Legend>;

	public var border: ceramic.Border;
	@content public var pivot: viewport.visuals.Pivot;
	@content public var sourceKey: keyson.Keyson.Key;

	public function select() {
		border.visible = true;
		pivot.visible = true;
	}

	// explicit deselection is sometimes unavoidable
	public function deselect() {
		border.visible = false;
		pivot.visible = false;
	}

	override public function computeContent() {
		for (l in legends) {
			l.depth = 50;
			this.add(l);
		}
		super.computeContent();
	}
}
