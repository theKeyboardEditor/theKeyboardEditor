package;

import ceramic.Scene;
import ceramic.Quad;
import ceramic.KeyBindings;
import ceramic.KeyCode;
import haxe.ui.core.Screen;

class MainScene extends Scene {
	public var gui: UI;
	public var unitScale: Float = 54 / 100; // herewith we zoom the viewport

	// Add any asset you want to load here
	override function preload() {
		assets.add(Fonts.FONTS__ROBOTO_REGULAR);
		// MODES
		assets.add(Images.ICONS__PLACE_MODE);
		assets.add(Images.ICONS__UNIT_MODE);
		assets.add(Images.ICONS__LEGEND_MODE);
		assets.add(Images.ICONS__KEYBOARD_MODE);
		assets.add(Images.ICONS__COLOR_MODE);
		// MISC ICONS
		assets.add(Images.ICONS__KEBAB_DROPDOWN);
		assets.add(Images.HEADER);
		// JSON
		assets.add(Texts.NUMPAD);
		assets.add(Texts.ALLPAD);
	}

	// Called when scene has finished preloading
	override function create() {
		// Render keys
		var keyboard = keyson.Keyson.parse(assets.text(Texts.NUMPAD));
		var viewport = new viewport.Viewport(keyboard.unit[0]);
		this.add(viewport);

		var store = new ceramic.PersistentData("keyboard");
		gui = new UI();

		for (key in store.keys()) {
			gui.welcome.findComponent("project-list").addComponent(new ui.Project(key));
		}

		// TODO can we make picking "New" uncover the welcome screen eveon on a running session
		// HIDING FOR NOW!
		Screen.instance.addComponent(gui);

		var keyBindings = new KeyBindings();
		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_S)], function() {
			trace("boo");
			save(keyboard, store);
		});

		gui.tabbar.findComponent("picker").onChange = (e) -> {
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
					save(keyboard, store);
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE Json File");
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

	function save(keyboard: keyson.Keyson, store: ceramic.PersistentData) {
		/*
		 * TODO: Compress using hxPako or similar - logo
		 * fire-h0und section:
		 * (if we compress the files we gain little but lose some of the simplicity when parsing our files)
		 * ((modern OSes have transparent compression options that makes even those small gains mooth))
		 * TODO: where we save (dialog) to lacal or remote storage?
		 */
		store.set(Std.string(keyboard.name), keyboard);
		store.save();
		StatusBar.inform("Project has been saved");
	}
}
