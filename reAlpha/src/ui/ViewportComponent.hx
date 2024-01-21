package ui;

import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;

class ViewportComponent extends VBox {
	public var display(default, set): viewport.Viewport;

	@:bind(this, UIEvent.RESIZE)
	function resize(e: UIEvent) {
		if (this.display == null) {
			return;
		}
		this.display.width = e.target.width;
		this.display.height = e.target.height;
	}

	function set_display(display: viewport.Viewport): viewport.Viewport {
		this.display = display;
		this.display.width = this.width;
		this.display.height = this.height;
		trace(this.width);
		trace(this.display.width);
		this.add(display); // TODO check this toroughy out
		return display;
	}
}
