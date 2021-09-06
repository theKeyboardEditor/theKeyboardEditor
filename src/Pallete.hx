package;

import zui.Zui;
import zui.Id;
import kha.System;
import kha.graphics2.Graphics;

class Pallete {
	static var _colors = [0xffffcd75, 0xff3b5dc9, 0xfff4f4f4];

	public function new(ui: Zui) {
		if (ui.window(Id.handle(), 0, System.windowHeight()-28, System.windowWidth(), System.windowHeight())) {
			ui.row([1/8, 1/48, 1/48, 1/48]);
			ui.text("Pallete name: Untitled", Center, 0xff434c5e);

			for (color in _colors) {
				ui.buttonRect(23, 23, color, color, color);
			}
		}
	}
}
