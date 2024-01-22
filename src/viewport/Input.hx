package viewport;

import ceramic.InputMap;
import ceramic.MouseButton;

enum abstract ViewportInput(Int) {
	final UP;
	final DOWN;
	final LEFT;
	final RIGHT;
	final PAN_UP;
	final PAN_DOWN;
	final PAN_LEFT;
	final PAN_RIGHT;
	final PAN;
	final SELECT;
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
		this.bindScanCode(PAN_UP, KEY_W);
		this.bindScanCode(PAN_DOWN, KEY_S);
		this.bindScanCode(PAN_LEFT, KEY_A);
		this.bindScanCode(PAN_RIGHT, KEY_D);

		// Zoom Time
		this.bindScanCode(ZOOM_IN, EQUALS);
		this.bindScanCode(ZOOM_OUT, MINUS);

		// Key Placement (Temporary)
		this.bindScanCode(PLACE_1U, KEY_P);
		this.bindScanCode(PLACE_ISO, KEY_I);
		this.bindScanCode(DELETE_SELECTED, BACKSPACE);
		this.bindScanCode(DELETE_SELECTED, DELETE);

		// TODO undo/redo action(s)
		this.bindScanCode(UNDO, KEY_Z);
		this.bindScanCode(REDO, KEY_Y);

		// Mouse buttons
		// LEFT
		this.bindMouseButton(SELECT, 0);
		// MIDDLE
		this.bindMouseButton(PAN, 1);
	}
}
