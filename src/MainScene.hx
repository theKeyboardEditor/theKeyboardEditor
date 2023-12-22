package;

import ceramic.Quad;
import ceramic.Scene;
import haxe.ui.ComponentBuilder;
import haxe.ui.core.Screen;

class MainScene extends Scene {
	override function preload() {
		// Add any asset you want to load here
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

	override function create() {
		var width:Int;
		var height:Int;
		var unit:Int; // always 1U for positioning
		// Called when scene has finished preloading
		// Render keys
		var keyboard = keyson.Keyson.parse(assets.text(Texts.NUMPAD));
		for (k in keyboard.board[0].keys) {
			trace ("shape:>"+k.shape+"<");
			width=100;
			height=100;
			unit=100;
			switch k.shape {
			case "2U":
			trace (">>2U");
			width=200;
			height=100;
			case "2U vertical":
			trace (">>2U vertical");
			width=100;
			height=200;
			case other:
			trace (">>other");
			width=100;
			height=100;
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

	override function update(delta: Float) {
		// Here, you can add code that will be executed at every frame
	}

	override function resize(width: Float, height: Float) {
		// Called everytime the scene size has changed
	}

	override function destroy() {
		// Perform any cleanup before final destroy

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
