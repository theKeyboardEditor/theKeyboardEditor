package;

import haxe.Constraints;
import zui.Zui;
import zui.Id;
import kha.System;
import kha.graphics2.Graphics;

class MenuTabElement {
	public var handle:Dynamic;
	
	public function new(x: Int, y: Int, title: String, options: Map<String, Function>, ui: Zui) {
		handle = Id.handle();
		if (y == null) y = 28;
		if (ui.window(handle, x, y, 240, 600)) {
			ui.text(title, Center, 0xff434c5e);
			for (option in options.keys()) {
				if (ui.button(option, Left)) {
					options[option]();
				}
			}
		}
	}
}
