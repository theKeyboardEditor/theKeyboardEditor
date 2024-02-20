package;

class KeyRenderer extends ceramic.Visual {
	@content public var topColor: ceramic.Color = 0xffFCFCFC;
	@content public var bottomColor: ceramic.Color = 0xFFCCCCCC;
	@content public var legends: Array<LegendRenderer>;

	public var border: ceramic.Border;
	public var pivot: viewport.Pivot;
	public var sourceKey: keyson.Keyson.Key;

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
			trace('legend color: ${StringTools.hex(l.color,8)}');
			l.depth = 50;
			this.add(l);
		}
		super.computeContent();
	}
}
