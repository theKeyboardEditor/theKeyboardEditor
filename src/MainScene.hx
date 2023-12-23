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
		var width: Int;
		var height: Int;
		var gapX: Int;
		var gapY: Int;
		var unit: Int; // always 1U for positioning
		// Render keys
		var keyboard = keyson.Keyson.parse(assets.text(Texts.NUMPAD));

		for (k in keyboard.board[0].keys) {
			unit = 100;
			gapX = Std.int((keyboard.board[0].keyStep[Axis.X] - keyboard.board[0].capSize[Axis.X]) / keyboard.board[0].keyStep[Axis.X] * unit);
			gapY = Std.int((keyboard.board[0].keyStep[Axis.Y] - keyboard.board[0].capSize[Axis.Y]) / keyboard.board[0].keyStep[Axis.Y] * unit);
			width = unit - gapX;
			height = unit - gapY;

			switch k.shape {
				case "2U":
					width = unit * 2 - gapX;
					height = unit - gapY;
				case "2U vertical":
					width = unit - gapX;
					height = unit * 2 - gapY;
				case other:
					width = unit - gapX;
					height = unit - gapY;
			}

			var key = new KeyRenderer(width, height);
			key.pos(unit * key.scaleTo * k.position[Axis.X] + 500, unit * key.scaleTo * k.position[Axis.Y] + 50);

			this.add(key);
		}

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
	override function update(delta: Float) {
	}

	// Called everytime the scene size has changed
	override function resize(width: Float, height: Float) {
	}

	// Perform any cleanup before final destroy
	override function destroy() {
		super.destroy();
	}
}

/**
 * We define the X and Y axes exclusively for convenience here
 * It will compile down to just X = 0, Y = 1
 */
enum abstract Axis(Int) to Int {
	var X;
	var Y;
}
