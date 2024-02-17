package;

class KeyRenderer extends ceramic.Visual {
	@content public var topColor: Int = 0xffFCFCFC;
	@content public var bottomColor: Int = 0xFFCCCCCC;

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
}
