package;

import keyson.Keyson;
import kha.graphics2.Graphics;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import haxe.ui.core.Screen;
import haxe.ui.ComponentBuilder;
import haxe.ui.backend.kha.SDFPainter;

/*
 * The main view for theKeyboardEditor
 */
class MainView {
	var g: SDFPainter;
	var screen: Screen;
	var view: haxe.ui.containers.VBox;
	var keyboard: Keyson;

	public function new() {
		Assets.loadEverything(init);
	}

	private function init() {
		keyboard = Keyson.parse(Assets.blobs.keyboard_json.toString());

		kha.System.notifyOnFrames(render);

		// HaxeUI Initialization
		haxe.ui.Toolkit.theme = 'keyboard-editor-theme';
		haxe.ui.Toolkit.init();

		screen = Screen.instance;

		view = new haxe.ui.containers.VBox();
		view.percentWidth = view.percentHeight = 100;

		var toolbar = ComponentBuilder.fromFile("ui/toolbar.xml");
		view.addComponent(toolbar);
		var sidebar = ComponentBuilder.fromFile("ui/sidebar.xml");
		view.addComponent(sidebar);

		screen.addComponent(view);
	}

	private function render(frames: Array<Framebuffer>): Void {
		g = new SDFPainter(frames[0]);
		g.begin(true, 0xFF282828);
		for (key in keyboard.board[0].keys) {
			trace("boo");
			drawKey(g, 54 * key.position[0] + 250, 54 * key.position[1] + 50);
		}
		screen.renderTo(g);
		g.end();
	}

	private function drawKey(g: SDFPainter, x: Float, y: Float, width: Float = 0, height: Float = 0) {
		g.sdfRect(x, y, 54, 54, {
			tr: 7,
			br: 7,
			tl: 7,
			bl: 7
		}, 1, 0x18000000, 2.2, 0xffCCCCCC, 0xffCCCCCC, 0xffCCCCCC, 0xffCCCCCC);
		g.sdfRect(x + 6, y + 3, 42, 42, {
			tr: 5,
			br: 5,
			tl: 5,
			bl: 5
		}, 1, 0x18000000, 2.2, 0xffFCFCFC, 0xffFCFCFC, 0xffFCFCFC, 0xffFCFCFC);
	}
}
