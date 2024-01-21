package;

class KeyRenderer extends ceramic.Visual {
	public var border: ceramic.Border;
	public var pivot: viewport.Pivot;

	public function create(): ceramic.Visual {
		return null;
	}

	public function select() {
		border.visible = !border.visible;
		pivot.visible = border.visible; // we always copy border visibility!
	}
}
