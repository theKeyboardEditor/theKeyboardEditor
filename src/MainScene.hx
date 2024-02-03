package;

import ceramic.Scene;
import ceramic.KeyBindings;
import ceramic.KeyCode;
import haxe.ui.core.Screen;

class MainScene extends Scene {
	public var gui: UI;

	/*
	 * Add any assets you want to load here
	 */
	override function preload() {
		assets.add(Fonts.FONTS__ROBOTO_REGULAR);
		// MODES
		assets.add(Images.ICONS__PLACE_MODE);
		assets.add(Images.ICONS__EDIT_MODE);
		assets.add(Images.ICONS__UNIT_MODE);
		assets.add(Images.ICONS__LEGEND_MODE);
		assets.add(Images.ICONS__KEYBOARD_MODE);
		assets.add(Images.ICONS__PALETTE_MODE);
		// MISC ICONS
		assets.add(Images.ICONS__KEBAB_DROPDOWN);
		assets.add(Images.ICONS__UNDO);
		assets.add(Images.ICONS__REDO);
		assets.add(Images.ICONS__COPY);
		assets.add(Images.ICONS__CUT);
		assets.add(Images.ICONS__PASTE);
		assets.add(Images.HEADER);
		// JSON
		assets.add(Texts.NUMPAD);
		assets.add(Texts.ALLPAD);
	}

	/*
	 * Called when scene has finished preloading
	 */
	override function create() {
		// Grab the stored projects
		var store = new ceramic.PersistentData("keyboard");

		// Initialize global variables
		this.gui = new UI(this, store);

		// Render keys
		gui.openViewport(keyson.Keyson.parse(assets.text(Texts.ALLPAD)));
		gui.openViewport(keyson.Keyson.parse(assets.text(Texts.NUMPAD)));

		// Add stored projects to list
		for (key in store.keys()) {
			gui.welcome.findComponent("project-list").addComponent(new ui.Project(key));
		}

		// TODO: can we make picking "New" uncover the welcome screen eveon on a running session
		// TODO: inhibit all worksurface actions for the while GUI is displayed
		Screen.instance.addComponent(gui);
		Screen.instance.addComponent(gui.overlay);

		// KEYBINDINGS!
		var keyBindings = new KeyBindings();

		// Saving
		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_S)], () -> {
			save((cast gui.tabs.selectedPage: ui.ViewportContainer).display.keyson, store);
		});

		// Toggle overlay (i.e welcome screen)
		// gui.viewport.display.paused = true;
		keyBindings.bind([KEY(KeyCode.TAB)], () -> {
			// gui.viewport.display.paused = !gui.viewport.display.paused;
			gui.overlay.hidden = !gui.overlay.hidden;
		});

		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_Z)], () -> {
			(cast gui.tabs.selectedPage: ui.ViewportContainer).display.queue.undo();
		});

		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_Y)], () -> {
			(cast gui.tabs.selectedPage: ui.ViewportContainer).display.queue.redo();
		});
	}

	public function save(keyboard: keyson.Keyson, store: ceramic.PersistentData) {
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
