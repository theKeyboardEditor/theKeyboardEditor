package;

import kha.graphics2.Graphics;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import haxe.ui.core.Screen;
import haxe.ui.ComponentBuilder;

/*
 * The main view for theKeyboardEditor
 */
class MainView {
	var g: Graphics;
	var screen: Screen;

	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		kha.System.notifyOnFrames(render);
		haxe.ui.Toolkit.init();
		screen = Screen.instance;
	}

	public function render(frames: Array<Framebuffer>): Void {
		g = frames[0].g2;
		g.begin(true, Color.fromBytes(67, 76, 94));
		// HaxeUI Elements
		var view = new haxe.ui.containers.VBox();
		view.percentWidth = view.percentHeight = 100;
		var toolbar = ComponentBuilder.fromFile("ui/toolbar.xml");
		view.addComponent(toolbar);
		//var sidebar = ComponentBuilder.fromFile("ui/sidebar.xml");
		//view.addComponent(sidebar);
		screen.addComponent(view);
		screen.renderTo(g);
		g.end();
	}
}
