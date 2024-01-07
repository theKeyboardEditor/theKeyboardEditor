package;

import ceramic.Scene;
import haxe.ui.ComponentBuilder;
import haxe.ui.core.Screen;

class MainScene extends Scene {
	public var unitScale: Float = 54 / 100; // herewith we zoom the viewport

	// Add any asset you want to load here
	override function preload() {
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
		assets.add(Texts.ALLPAD);
	}

	// Called when scene has finished preloading
	override function create() {
		// Render keys
		var keyboard = keyson.Keyson.parse(assets.text(Texts.NUMPAD));
		// final keyboard = keyson.Keyson.parse(assets.text(Texts.ALLPAD));
		var viewport = new viewport.Viewport(keyboard.unit[0]);
		this.add(viewport);

		// Create base container
		var view = new haxe.ui.containers.VBox();
		view.styleString = "spacing: 0;";
		view.percentWidth = view.percentHeight = 100;
		Screen.instance.addComponent(view);

		// Render elements
		var tabbar = ComponentBuilder.fromFile("ui/tabbar.xml");
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

		StatusBar.element = ComponentBuilder.fromFile("ui/status.xml");
		view.addComponent(StatusBar.element);

		tabbar.findComponent("picker").onChange = (e) -> {
			trace('File operation selected: ${e.relatedComponent.id}');
			switch (e.relatedComponent.id) {
				case "open":
					final dialog = new FileDialog();
					dialog.openJson("Keyson File");
					dialog.onFileLoaded(this, (body: String) -> {
						keyboard = keyson.Keyson.parse(body);
						trace("Read in keyboard:", keyboard.unit[0]);
						viewport.cursor.destroy();
						viewport.grid.destroy();
						viewport.destroy();

						trace("Cleaned viewport.");
						viewport = new viewport.Viewport(keyboard.unit[0]);
						this.add(viewport);
					});
				case "save":
					// TODO: Compress using hxPako or similar
					var save = new ceramic.PersistentData("keyboard");
					save.set(Std.string(keyboard.unit[0].id), keyboard);
					save.save();
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE File");
					dialog.onFileLoaded(this, (body: String) -> {
						keyboard = keyson.KLE.toKeyson(body);
						viewport.cursor.destroy();
						viewport.grid.destroy();
						viewport.destroy();
						viewport = new viewport.Viewport(keyboard.unit[0]);
						this.add(viewport);
					});
			}
		}
	}
}
