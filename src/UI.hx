package;

import ceramic.PersistentData;
import haxe.ui.ComponentBuilder;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.events.ItemEvent;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.containers.ButtonBar;
import haxe.ui.containers.dialogs.Dialog;

using StringTools;

class UI extends haxe.ui.containers.VBox {
	public var overlay: Box;
	public var leftBox: HBox;
	public var tabbar: HBox;
	public var modeSelector: ButtonBar;
	public var viewport: ui.ViewportContainer;
	public var sidebar(default, set): Box;
	public var welcome: VBox;

	var scene: MainScene;
	var store: PersistentData;

	public function new(scene: MainScene, store: PersistentData) {
		super();
		this.scene = scene;
		this.store = store;

		// Create base container
		this.styleString = "spacing: 0;";
		this.percentWidth = this.percentHeight = 100;

		// Render elements
		// TOP
		this.tabbar = ComponentBuilder.fromFile("ui/tabbar.xml");
		tabbarEvents();
		this.addComponent(this.tabbar);

		// MIDDLE
		var middle = new HBox();
		middle.styleString = "spacing: 0; width: 100%; height: 100%;";
		this.addComponent(middle);

		leftBox = new HBox();
		leftBox.styleString = "spacing: 0; height: 100%;";
		{
			this.modeSelector = ComponentBuilder.fromFile("ui/modeselector.xml");
			leftBox.addComponent(this.modeSelector);

			this.sidebar = ComponentBuilder.fromFile("ui/sidebars/place.xml"); // this is the default sidebar
		}
		middle.addComponent(leftBox);

		this.viewport = new ui.ViewportContainer();
		viewport.styleString = "width: 100%; height: 100%;";
		middle.addComponent(viewport);

		// BOTTOM
		StatusBar.element = ComponentBuilder.fromFile("ui/status.xml");
		this.addComponent(StatusBar.element);

		// This is put on top of all other elements
		this.overlay = createWelcome();
	}

	function set_sidebar(value: Box): Box {
		if (sidebar == value)
			return sidebar;
		if (sidebar != null) {
			leftBox.removeComponent(sidebar);
		}

		this.sidebar = value;
		leftBox.addComponent(sidebar);

		return sidebar;
	}

	public function createWelcome(): Box {
		var overlay = new Box();
		overlay.percentWidth = 100;
		overlay.percentHeight = 100;

		welcome = ComponentBuilder.fromFile("ui/welcome.xml");
		welcome.horizontalAlign = "center";
		welcome.verticalAlign = "center";
		overlay.addComponent(welcome);

		return overlay;
	}

	public function tabbarEvents() {
		this.tabbar.findComponent("picker").onChange = (e) -> {
			trace('File operation selected: ${e.relatedComponent.id}');
			switch (e.relatedComponent.id) {
				case "new":
					final dialog = new NewNameDialog();
					// viewport.display.paused = true;
					dialog.onDialogClosed = function(e: DialogEvent) {
						// viewport.display.paused = false;
						final name = dialog.name.value;
						if (StringTools.trim(name) == "")
							return;
						this.scene.openViewport(new keyson.Keyson(name));
					}
					dialog.showDialog();
				case "open":
					final dialog = new FileDialog();
					dialog.openJson("Keyson File");
					dialog.onFileLoaded(scene, (body: String) -> {
						this.scene.openViewport(keyson.Keyson.parse(body));
					});
				case "save":
					this.scene.save(viewport.display.keyson, store);
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE Json File");
					dialog.onFileLoaded(scene, (body: String) -> {
						var dialog = new ImportNameDialog();
						// viewport.display.paused = true;
						dialog.onDialogClosed = function(e: DialogEvent) {
							// viewport.display.paused = false;
							final name = dialog.name.value;
							if (StringTools.trim(name) == "")
								return;
							this.scene.openViewport(keyson.KLE.toKeyson(name, body));
						}
						dialog.showDialog();
					});
			}
		};
	}

	@:bind(tabbar.findComponent("projects"), UIEvent.CLOSE)
	public function closeProject(event: UIEvent) {
		this.scene.closeViewport(this.scene.openProjects[event.target.id]);
	}

	@:bind(welcome.findComponent("new-project"), MouseEvent.CLICK)
	public function welcomeEvents(event: MouseEvent) {
		this.overlay.visible = false;
		final dialog = new NewNameDialog();
		// viewport.display.paused = true;
		dialog.onDialogClosed = function(e: DialogEvent) {
			// viewport.display.paused = false;
			final name = dialog.name.value;
			if (StringTools.trim(name) == "")
				return;
			this.scene.openViewport(new keyson.Keyson(name));
		}
		dialog.showDialog();
	}

	@:bind(modeSelector, UIEvent.CHANGE)
	public function switchMode(_: UIEvent) {
		this.sidebar = switch (modeSelector.selectedButton.id) {
			case "place":
				ComponentBuilder.fromFile("ui/sidebars/place.xml");
			case "edit":
				ComponentBuilder.fromFile("ui/sidebars/edit.xml");
			case "unit":
				ComponentBuilder.fromFile("ui/sidebars/unit.xml");
			case "legend":
				ComponentBuilder.fromFile("ui/sidebars/legend.xml");
			case "keyboard":
				ComponentBuilder.fromFile("ui/sidebars/keyboard.xml");
			case "palette":
				ComponentBuilder.fromFile("ui/sidebars/palette.xml");
			default:
				ComponentBuilder.fromFile('ui/sidebars/void.xml');
		};
	}
}

class ImportNameDialog extends Dialog {
	public var name: haxe.ui.components.TextField;

	public function new() {
		super();
		this.title = "Name the imported keyboard";
		this.buttons = "Import";
		this.defaultButton = "Import";
		this.percentWidth = 15;
		name = new haxe.ui.components.TextField();
		name.percentWidth = 100;
		name.placeholder = "Keyboard Name";
		this.addComponent(name);
	}
}

class NewNameDialog extends Dialog {
	public var name: haxe.ui.components.TextField;

	public function new() {
		super();
		this.title = "Name the new keyboard";
		this.buttons = "Name";
		this.defaultButton = "Name";
		this.percentWidth = 15;
		name = new haxe.ui.components.TextField();
		name.percentWidth = 100;
		name.placeholder = "unknown";
		this.addComponent(name);
	}
}
