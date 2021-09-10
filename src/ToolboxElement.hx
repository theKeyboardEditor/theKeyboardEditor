package;

import zui.Zui;
import zui.Id;
import kha.System;
import kha.graphics2.Graphics;

/*
 * A class used to define the different toolbox windows
 * "Lefty Loosey, Righty Tighty"
 */
class ToolboxElement {
	public var handle:Dynamic;

	public function new(ui: Zui, loc: Localization) {
		handle = Id.handle();
		if (ui.window(handle, 0, 28, 120, System.windowHeight()-28, true)) {
			ui.text(loc.tr("Key Shapes"), Center, 0xff434c5e);
			ui.row([1/2, 1/2]);
			ui.button("1u R1");
			ui.button("1.25 R2");
			ui.row([1/2, 1/2]);
			ui.button("1.5u R2");
			ui.button("1.75 R3");
			ui.row([1/2, 1/2]);
			ui.button("2u R3");
			ui.button("2.25 R2");
			ui.row([1/2, 1/2]);
			ui.button("2.75 R4");
			ui.button("6.25 R5");
			ui.row([1/2, 1/2]);
			ui.button("7u R5");
			ui.button("ISO");
			ui.row([1/2, 1/2]);
			ui.button("BAE");
			ui.button("ANSI");
			ui.row([1/2, 1/2]);
			ui.button("N+");
			ui.button("N ent");
			ui.row([1/2, 1/2]);
			ui.button("1u R2");
			ui.button("1u R3");
			ui.row([1/2, 1/2]);
			ui.button("1u R4");
			ui.button("2.25 R3");
		}
	}
}
