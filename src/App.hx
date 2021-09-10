package;

import kha.graphics2.Graphics;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import zui.Zui;

/*
 * The main class for theKeyboardEditor, that is it.
 */
class App {
	var ui:Zui;
	var g:Graphics;
	var loc:Localization;

	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		loc = new Localization();
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
		new MenuElement(ui, loc);
		new ToolboxElement(ui, loc);
		new Pallete(ui, loc);
		ui.end();
	}
}
