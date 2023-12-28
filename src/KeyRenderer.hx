package;

class KeyRenderer extends ceramic.Visual {
	public var border: ceramic.Border;

	public function create(): ceramic.Visual {
		return null;
	}

	public function select() {
		border.visible = !border.visible;
	}
}
