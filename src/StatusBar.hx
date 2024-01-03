package;

class StatusBar {
	public static var element: haxe.ui.containers.HBox;

	/**
	 * Displays text in the left column
	 */
	public static function inform(to: String) {
		element.findComponent("action").text = to;
	}

	/**
	 * Sets the position text
	 */
	public static function pos(x: Float, y: Float) {
		element.findComponent("pos").text = 'cursor pos: $x x $y';
	}
}
