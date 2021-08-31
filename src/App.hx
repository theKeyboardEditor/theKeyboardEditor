package;

import kha.graphics2.Graphics;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import zui.Zui;
import zui.Id;

class App {
	var ui:Zui;
	var g:Graphics;

	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		ui = new Zui({font: Assets.fonts.SourceSansProSemibold});
		kha.System.notifyOnFrames(render);
	}

	public function render(frames: Array<Framebuffer>): Void {
		// Graphics2
		g = frames[0].g2;
		g.begin(true, Color.fromBytes(67, 76, 94));
		g.end();

		// User interface
		ui.begin(g);
		if (ui.window(Id.handle(), 0, 0, System.windowWidth(), System.windowHeight())) {
			if (ui.button("Hello")) {
				trace("World");
			}
		}
		ui.end();
	}
}
