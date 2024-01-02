package;

class KeyRenderer extends ceramic.Visual {
	public var represents: keyson.Keyson.Key;
	public var border: ceramic.Border;

	public function create(): ceramic.Visual {
		return null;
	}

	public function select() {
		border.visible = !border.visible;
	}
}
