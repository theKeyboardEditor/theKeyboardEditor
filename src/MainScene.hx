package;

import ceramic.Scene;
import ceramic.Quad;
import ceramic.KeyBindings;
import ceramic.KeyCode;
import haxe.ui.core.Screen;
import uuid.FlakeId;

class MainScene extends Scene {
	public var openProjects: Map<String, viewport.Viewport> = []; // The Int64 is an random identifier for the specific viewport
	public var currentProject: viewport.Viewport;
	public var gui: UI;
	public var flakeGen: FlakeId; // Used for generating the previously stated identifiers

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
		assets.add(Images.ICONS__COLOR_MODE);
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
		this.flakeGen = new FlakeId();

		// Render keys
		openViewport(keyson.Keyson.parse(assets.text(Texts.ALLPAD)));
		openViewport(keyson.Keyson.parse(assets.text(Texts.NUMPAD)));

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

		// Savind
		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_S)], () -> {
			save(currentProject.keyson, store);
		});

		final project: haxe.ui.components.TabBar = cast gui.tabbar.findComponent("projects");
		project.selectedIndex = project.tabCount - 1;
		project.onChange = (e) -> {
			var view = openProjects[project.selectedTab.id];
			switchViewport(view);
		};

		// Toggle overlay (i.e welcome screen)
		this.currentProject.paused = true;
		keyBindings.bind([KEY(KeyCode.TAB)], () -> {
			this.currentProject.paused = !currentProject.paused;
			gui.overlay.hidden = !gui.overlay.hidden;
		});
	}

	public function openViewport(keyboard: keyson.Keyson) {
		// Generate an identifier
		final flake = Std.string(this.flakeGen.nextId());
		// Create a tab on the top
		var tab = new haxe.ui.components.Button();
		tab.id = flake;
		tab.text = keyboard.name;
		this.gui.tabbar.findComponent("projects").addComponent(tab);
		// Create a new viewport
		final viewport = new viewport.Viewport(keyboard); //TODO better naming is needed
		this.openProjects[flake] = viewport;
		switchViewport(viewport); 
	}

	public function closeViewport(viewport: viewport.Viewport) {
		viewport?.cursor.destroy();
		viewport?.grid.destroy();
		viewport?.destroy();
		// TODO: Find correct tab to delete - logo
		// this.gui.tabbar.findComponent("projects").disposeComponent();
	}

	public function switchViewport(viewport: viewport.Viewport) { // TODO that's 4 Viewports in one line?
		// TODO update the tabs to refect the active project
		this.currentProject?.set_visible(false);
		this.currentProject?.cursor?.set_visible(false);

		this.currentProject = viewport;
		this.currentProject.create();
		this.add(currentProject);

		this.currentProject.visible = true;
		this.currentProject.cursor.visible = true;
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
