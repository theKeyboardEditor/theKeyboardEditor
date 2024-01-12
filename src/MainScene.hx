package;

import ceramic.Scene;
import ceramic.Quad;
import ceramic.KeyBindings;
import ceramic.KeyCode;
import haxe.ui.core.Screen;

class MainScene extends Scene {
	public var openProjects: Array<viewport.Viewport> = [];
	public var currentProject: viewport.Viewport;
	public var gui: UI;

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
		assets.add(Images.HEADER);
		// JSON
		assets.add(Texts.NUMPAD);
		assets.add(Texts.ALLPAD);
	}

	/*
	 * Called when scene has finished preloading
	 */
	override function create() {
		// Render GUI
		gui = new UI();

		// Render keys
		openViewport(keyson.Keyson.parse(assets.text(Texts.ALLPAD)));
		openViewport(keyson.Keyson.parse(assets.text(Texts.NUMPAD)));

		// Grab the stored keyboards
		var store = new ceramic.PersistentData("keyboard");

		// Add stored projects to list
		for (key in store.keys()) {
			gui.welcome.findComponent("project-list").addComponent(new ui.Project(key));
		}

		// TODO can we make picking "New" uncover the welcome screen eveon on a running session
		Screen.instance.addComponent(gui);
		Screen.instance.addComponent(gui.overlay);
		// TODO inhibit all worksurface actions for the while GUI is displayed

		var keyBindings = new KeyBindings();

		// Savind
		keyBindings.bind([CMD_OR_CTRL, KEY(KeyCode.KEY_S)], () -> {
			save(currentProject.keyson, store);
		});

		// Toggle GUI
		keyBindings.bind([KEY(KeyCode.TAB)], () -> {
			gui.overlay.hidden = !gui.overlay.hidden;
		});

		gui.tabbar.findComponent("picker").onChange = (e) -> {
			trace('File operation selected: ${e.relatedComponent.id}');
			switch (e.relatedComponent.id) {
				case "open":
					final dialog = new FileDialog();
					dialog.openJson("Keyson File");
					dialog.onFileLoaded(this, (body: String) -> {
						openViewport(keyson.Keyson.parse(body));
					});
				case "save":
					save(currentProject.keyson, store);
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE Json File");
					dialog.onFileLoaded(this, (body: String) -> {
						openViewport(keyson.KLE.toKeyson(body));
					});
			}
		};

		final project: haxe.ui.components.TabBar = cast gui.tabbar.findComponent("projects");
		project.onChange = (e) -> {
			var view = openProjects.filter((f) -> f.keyson.name == project.selectedTab.value)[0];
			switchViewport(view);
		};
	}

	function openViewport(keyboard: keyson.Keyson) {
		var tab = new haxe.ui.components.Button();
		tab.text = keyboard.name;
		this.gui.tabbar.findComponent("projects").addComponent(tab);

		final viewport = new viewport.Viewport(keyboard);
		this.openProjects.push(viewport);
		switchViewport(viewport);
	}

	function closeViewport() {
		this.currentProject?.cursor.destroy();
		this.currentProject?.grid.destroy();
		this.currentProject?.destroy();
		// TODO: Find correct tab to delete - logo
		//this.gui.tabbar.findComponent("projects").disposeComponent();
	}

	function switchViewport(viewport: viewport.Viewport) {
		this.currentProject?.set_visible(false);
		this.currentProject = viewport;
		this.currentProject.create();
		this.add(currentProject);
		this.currentProject.visible = true;
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
