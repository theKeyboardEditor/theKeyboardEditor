package viewport;

import ceramic.InputMap;
import ceramic.MouseButton;

enum abstract ViewportInput(Int) {
	final UP;
	final DOWN;
	final LEFT;
	final RIGHT;
	final KEY_W;
	final KEY_A;
	final KEY_S;
	final KEY_D;
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
		this.bindScanCode(KEY_W, KEY_W);
		this.bindScanCode(KEY_S, KEY_S);
		this.bindScanCode(KEY_A, KEY_A);
		this.bindScanCode(KEY_D, KEY_D);

		// Zoom Time
		this.bindScanCode(ZOOM_IN, EQUALS);
		this.bindScanCode(ZOOM_OUT, MINUS);
		this.bindScanCode(ZOOM_IN, EQUALS);
		this.bindScanCode(ZOOM_OUT, MINUS);

		// Key Placement (Temporary)
		this.bindScanCode(PLACE_1U, KEY_P);
		this.bindScanCode(PLACE_ISO, KEY_I);
		this.bindScanCode(DELETE_SELECTED, BACKSPACE);
		this.bindScanCode(DELETE_SELECTED, DELETE);

		// TODO undo/redo action(s)
		this.bindScanCode(UNDO, KEY_Z); // TODO find Ctrl+Z keycode
		this.bindScanCode(REDO, KEY_Y);

		// Mouse buttons
		//this.bindMouseButton(ZOOM_IN, EXTRA1);
		//this.bindMouseButton(ZOOM_OUT, EXTRA2); those are the next page & gang!
	}
}
