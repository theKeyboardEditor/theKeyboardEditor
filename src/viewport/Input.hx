package viewport;

import ceramic.InputMap;

enum abstract ViewportInput(Int) {
	final UP;
	final DOWN;
	final LEFT;
	final RIGHT;
	final ZOOM_IN;
	final ZOOM_OUT;
	final PLACE_1U;
	final PLACE_ISO;
	final UNDO;
	final REDO;
	final DELETE_SELECTED;
}

class Input extends InputMap<ViewportInput> {
	public function new() {
		super();

		// Basic movement
		this.bindKeyCode(UP, UP);
		this.bindKeyCode(DOWN, DOWN);
		this.bindKeyCode(LEFT, LEFT);
		this.bindKeyCode(RIGHT, RIGHT);

		// Same as above, but with arrow keys
		this.bindScanCode(UP, KEY_W);
		this.bindScanCode(DOWN, KEY_S);
		this.bindScanCode(LEFT, KEY_A);
		this.bindScanCode(RIGHT, KEY_D);

		// Zoom Time
		this.bindScanCode(ZOOM_IN, EQUALS);
		this.bindScanCode(ZOOM_OUT, MINUS);

		// Key Placement (Temporary)
		this.bindScanCode(PLACE_1U, KEY_P);
		this.bindScanCode(PLACE_ISO, KEY_I);
		this.bindScanCode(DELETE_SELECTED, BACKSPACE);
		this.bindScanCode(DELETE_SELECTED, DELETE);

		//TODO undo/redo action(s)
		this.bindScanCode(UNDO, KEY_Z); //TODO find Ctrl+Z keycode
		this.bindScanCode(REDO, KEY_Y);

	}
}
