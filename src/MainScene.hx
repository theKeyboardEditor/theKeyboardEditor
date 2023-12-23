package;

import ceramic.Quad;
import ceramic.Scene;
import haxe.ui.ComponentBuilder;
import haxe.ui.core.Screen;

class MainScene extends Scene {
	// Add any asset you want to load here
	override function preload() {
		assets.add(Images.CERAMIC);
		// MODES
		assets.add(Images.ICONS__PLACE_MODE);
		assets.add(Images.ICONS__UNIT_MODE);
		assets.add(Images.ICONS__LEGEND_MODE);
		assets.add(Images.ICONS__KEYBOARD_MODE);
		assets.add(Images.ICONS__COLOR_MODE);
		// MISC ICONS
		assets.add(Images.ICONS__KEBAB_DROPDOWN);
		// JSON
		assets.add(Texts.NUMPAD);
	}

	// Called when scene has finished preloading
	override function create() {
		// Render keys
		final keyboard = keyson.Keyson.parse(assets.text(Texts.NUMPAD));
		final viewport = new Viewport(keyboard.board[0]);
		this.add(viewport);

		//// Normal XT 2U enter
		// width1 = 100 - gapX;
		// height1 = 200 - gapY;
		// width2 = 200 - gapX;
		// height2 = 100 - gapY;
		// offsetX2 = -100 - Std.int(gapX / 2);
		// offsetY2 = 100 + Std.int(gapY / 2);
		// var key = new HookedKeyRenderer(width1, height1, width2, height2, offsetX2, offsetY2);
		// key.pos(unit * key.scaleTo * 2 + 500, unit * key.scaleTo * 7 + 50);
		////		key.rotation = 180;
		// this.add(key);

		//// AEK odd ball ISO enter
		// width1 = 125 - gapX;
		// height1 = 100 - gapY;
		// width2 = 100 - gapX;
		// height2 = 200 - gapY;
		// offsetX2 = 25 + Std.int(gapX / 2);
		// offsetY2 = 0 + Std.int(gapY / 2);
		// var key = new HookedKeyRenderer(width1, height1, width2, height2, offsetX2, offsetY2);
		// key.pos(unit * key.scaleTo * 3 + 500, unit * key.scaleTo * 7 + 50);
		// this.add(key);

		// Create base container
		var view = new haxe.ui.containers.VBox();
		view.styleString = "spacing: 0;";
		view.percentWidth = view.percentHeight = 100;
		Screen.instance.addComponent(view);

		// Render elements
		final tabbar = ComponentBuilder.fromFile("ui/tabbar.xml");
		view.addComponent(tabbar);

		var left = new haxe.ui.containers.HBox();
		left.styleString = "spacing: 0; height: 100%;";
		view.addComponent(left);
		{
			final modeSelector = ComponentBuilder.fromFile("ui/modeselector.xml");
			left.addComponent(modeSelector);

			final sidebar = ComponentBuilder.fromFile("ui/sidebar.xml");
			left.addComponent(sidebar);
		}

		final statusBar = ComponentBuilder.fromFile("ui/status.xml");
		view.addComponent(statusBar);
	}

	// Here, you can add code that will be executed at every frame
	override function update(delta: Float) {}

	// Called everytime the scene size has changed
	override function resize(width: Float, height: Float) {}

	// Perform any cleanup before final destroy
	override function destroy() {
		super.destroy();
	}
}
