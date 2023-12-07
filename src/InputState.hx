package;

import kha.input.KeyCode;

/*
 * Used the handle which direction the viewport should move
 */
class InputState {
	// Directions
	public var up = false;
	public var down = false;
	public var left = false;
	public var right = false;

	public function new() {}

	/**
	 * Based on the keycode, will set the appropriate direction to `bool`
	 */
	public function fromKeyCode(k: KeyCode, bool: Bool) {
		switch (k) {
			case W:
				this.up = bool;
			case S:
				this.down = bool;
			case A:
				this.left = bool;
			case D:
				this.right = bool;
			default:
				return;
		}
	}
}
