package;

class StatusBar {
	public static var element: haxe.ui.containers.HBox;

	/**
	 * Displays text in the left column
	 */
	public static function inform(with: String) {
		element.findComponent("action").text = with;
	}
	public static function error(with: String) {
		element.findComponent("action").text = with;
		haxe.ui.animation.AnimationTools.flash(element.findComponent("action"), 0xFFb13e53);
	}

	/**
	 * Sets the position text
	 */
	public static function pos(x: Float, y: Float) {
		element.findComponent("pos").text = 'cursor pos: $x x $y';
	}
}
