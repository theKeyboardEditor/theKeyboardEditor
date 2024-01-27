package;

class KeyRenderer extends ceramic.Visual {
	@content public var topColor: Int = 0xffFCFCFC;
	@content public var bottomColor: Int = 0xFFCCCCCC;

	public var border: ceramic.Border;
	public var pivot: viewport.Pivot;

	public function select() {
		border.visible = !border.visible;
		pivot.visible = border.visible; // we always copy border visibility!
	}
}
