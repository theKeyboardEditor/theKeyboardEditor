package;

import kha.System;
import zui.Zui;
import zui.Id;

class Properties {
	public function new(ui: Zui, loc: Localization) {
		if (ui.window(Id.handle(), System.windowWidth()-200, 28, 200, System.windowHeight())) {
			ui.text(loc.tr("Properties"), Center, 0xff434c5e);
			if (ui.panel(Id.handle(), "Legends")) {
				ui.text("Top Legend:");
				ui.row([1/3, 1/3, 1/3]);
				ui.textInput(Id.handle());
				ui.textInput(Id.handle());
				ui.textInput(Id.handle());
			}
		}
	}
}
