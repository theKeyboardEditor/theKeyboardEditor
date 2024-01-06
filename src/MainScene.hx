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
			trace("File operation selected: ", e.relatedComponent.id);
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
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE File");
					dialog.onFileLoaded(this, (body: String) -> {
						var y: Float = 0; // coordinates
						var x: Float = 0;
						var xNext: Float = 1;
						var shape: String = "1U";
						var w: Float = 1;
						// do parse the KLE json here
						var kle = haxe.Json.parse(body);
						keyboard = new keyson.Keyson();
						kle[0];
						y = 0;
						for (r in kle) {
							r[0];
							x = 0;
							for (c in r) {
								if (c.y != null)
									y = y + c.y;
								if (c.x != null)
									xNext += c.x;
								if (c is String) {
									var legend: String = Std.string(c);
									trace("Key:", c, "at:", x, y, "w:", w, "Type:", c is String);
									keyboard.unit[0].addKey(shape, [x, y], legend);
									w = 1;
									shape = "1U";
								} else {
									w = if (c.w != null) c.w else if (c.h != null) c.h else 1;
									shape = if (c.w != null) Std.string(w) + "U" else if (c.h != null) Std.string(w) + "U Vertical" else "1U";
									x--;
								}
								x = x + xNext;
								if (c.w != null) {
									xNext = c.w;
								} else {
									xNext = 1;
								}
							}
							y++;
						}

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
