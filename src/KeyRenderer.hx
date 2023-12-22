package;

import ceramic.Visual;
import haxe.ui.backend.ceramic.RoundedRect;

class KeyRenderer extends Visual {
	override public function new() {
		super();
		size(54, 54);

		final fg = new RoundedRect(0xffFCFCFC, 3, 1.5, 7, this.width - 12, this.height - 12);
		this.add(fg);

		final bg = new RoundedRect(0xffCCCCCC, 0, 0, 7, this.width, this.height);
		this.add(bg);
	}
}
