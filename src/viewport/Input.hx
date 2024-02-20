package viewport;

import ceramic.InputMap;

enum abstract ViewportInput(Int) {
	final PAN_UP;
	final PAN_DOWN;
	final PAN_LEFT;
	final PAN_RIGHT;
	final ZOOM_IN;
	final ZOOM_OUT;
	final UNDO;
	final REDO;
	final DELETE_SELECTED;
	final COPY;
	final CUT;
	final PASTE;
}

class Input extends InputMap<ViewportInput> {
	public function new() {
		super();

		// Basic movement
		this.bindKeyCode(PAN_UP, UP);
		this.bindKeyCode(PAN_DOWN, DOWN);
		this.bindKeyCode(PAN_LEFT, LEFT);
		this.bindKeyCode(PAN_RIGHT, RIGHT);

		// TODO make this not interfere with ctrl+ keycodes
		//		this.bindScanCode(PAN_UP, KEY_W);
		//		this.bindScanCode(PAN_DOWN, KEY_S);
		//		this.bindScanCode(PAN_LEFT, KEY_A);
		//		this.bindScanCode(PAN_RIGHT, KEY_D);

		this.bindScanCode(DELETE_SELECTED, BACKSPACE);
		this.bindScanCode(DELETE_SELECTED, DELETE);

		this.bindScanCode(ZOOM_IN, EQUALS);
		this.bindScanCode(ZOOM_OUT, MINUS);
		this.bindScanCode(ZOOM_IN, KP_PLUS);
		this.bindScanCode(ZOOM_OUT, KP_MINUS);
	}
}
