package ui;

import haxe.ui.containers.Box;
import haxe.ui.events.UIEvent;

class ViewportContainer extends Box {
	public var display(default, set): viewport.Viewport;

	var clipper = new ceramic.Quad();

	@:bind(this, UIEvent.RESIZE)
	function resize(e: UIEvent) {
		if (this.display == null) {
			return;
		}
		this.display.width = e.target.width;
		this.display.height = e.target.height;
		this.clipper.width = display.width;
		this.clipper.height = display.height;
		this.display.screenX = screenLeft;
		this.display.screenY = screenTop;
		trace(screenTop);
	}

	function set_display(display: viewport.Viewport): viewport.Viewport {
		this.clipper.width = display.width;
		this.clipper.height = display.height;
		this.clipper.transparent = true;

		this.display = display;
		this.display.width = this.width;
		this.display.height = this.height;
<<<<<<< Updated upstream
		//this.display.screenX = screenLeft; //works better when commented out
		//this.display.screenY = screenTop;  //why?
=======
		//this.display.screenX = screenLeft;
		//this.display.screenY = screenTop;
>>>>>>> Stashed changes
		this.display.clip = clipper;

		this.add(display);
		this.add(clipper);

		return display;
	}
}
