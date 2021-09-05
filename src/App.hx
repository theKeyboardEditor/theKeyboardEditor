package;

import kha.graphics2.Graphics;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import zui.Zui;

class App {
	var ui:Zui;
	var g:Graphics;

	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		ui = new Zui({font: Assets.fonts.FiraSansSemiBold, theme: Themes.nord});
		kha.System.notifyOnFrames(render);
	}

	public function render(frames: Array<Framebuffer>): Void {
		// Graphics2
		g = frames[0].g2;
		g.begin(true, Color.fromBytes(67, 76, 94));
		g.end();

		// User interface
		ui.begin(g);
		new MenuElement(ui);
		ui.end();
	}
}
