package;

import ceramic.Scene;
import ceramic.Quad;
import ceramic.KeyBindings;
import ceramic.KeyCode;
import haxe.ui.core.Screen;
import uuid.FlakeId;

class InKey extends Scene {
	public var uiOrganizer: UIOrganizer;

	/*
	 * Add any assets you want to load here
	 */
	override function preload() {
		assets.add(Fonts.FONTS__ROBOTO_REGULAR);
		// MODES
		assets.add(Images.ICONS__PLACE_MODE);
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
		// KEYBINDINGS!
		var keyBindings = new KeyBindings();
		//Initialize other things here
		//call the uiOrganizer into existence
		this.uiOrganizer = new UIOrganizer(this, store);
	}
}
