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
	public var midBox: HBox;
	public var leftBox: HBox;
	public var workBox: Box;
	public var tabbar: HBox;
	public var modeSelector: ButtonBar; // non padded button column
	public var sidebar(default, set): Box;
	public var viewport: ui.ViewportComponent;
	public var welcome: VBox;
	public var toolbar: String = 'palette'; // default (see below)

	// BUG If we initialize with void it fails to render the edit icons afterward forever!
	// But why?
	var scene: MainScene;
	var store: PersistentData;

	// creating a fresh VBox
	public function new(scene: MainScene, store: PersistentData) {
		super();
		this.scene = scene;
		this.store = store;

		// Create base container
		this.styleString = "spacing: 0;";
		this.percentWidth = this.percentHeight = 100;

		// Render elements
		this.tabbar = ComponentBuilder.fromFile("ui/tabbar.xml"); // HBox topmost
		tabbarEvents();
		this.addComponent(this.tabbar);
		// after adding the tab bar across the whole width
		// now add the rest from left to right beneath:
		midBox = new HBox();
		midBox.styleString = "spacing: 0; height: 100%; width: 64";
		this.addComponent(midBox); // HBox (content flows towards right
		leftBox = new HBox();
		leftBox.styleString = "spacing: 0; height: 100%; width: 64";
		midBox.addComponent(leftBox); // HBox (content flows towards right
		workBox = new Box(); // is a haxe.ui element
		workBox.styleString = "spacing: 0; height: 100%; width: 100%;";
		midBox.addComponent(workBox); // Box
		{
			this.modeSelector = ComponentBuilder.fromFile("ui/modeselector.xml"); // 64 px
			leftBox.addComponent(this.modeSelector); // ButtonBar
			this.sidebar = ComponentBuilder.fromFile("ui/sidebars/palette.xml"); // note it's not added yet! (160px)
		}
		{
			this.viewport = new ui.ViewportComponent();
			workBox.addComponent(this.viewport);
			this.viewport.percentWidth = 100;
			this.viewport.percentHeight = 100;
		}
		StatusBar.element = ComponentBuilder.fromFile("ui/status.xml");
		this.addComponent(StatusBar.element);

		this.overlay = createWelcome();
	}

	function set_sidebar(value: Box): Box {
		if (sidebar != null) { // don't remove an non existing sidebar
			leftBox.removeComponent(sidebar);
		}
		this.sidebar = value; // new to be set sidebar
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
					viewport.display.paused = true;
					dialog.onDialogClosed = function(e: DialogEvent) {
						final name = dialog.name.value;
						if (StringTools.trim(name) == "")
							return;
						this.scene.openViewport(new keyson.Keyson(name));
						viewport.display.paused = false;
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
				// TODO make download for local storage one day
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE Json File");
					dialog.onFileLoaded(scene, (body: String) -> {
						var dialog = new ImportNameDialog();
						viewport.display.paused = true;
						dialog.onDialogClosed = function(e: DialogEvent) {
							viewport.display.paused = false;
							final name = dialog.name.value;
							if (StringTools.trim(name) == "")
								return;
							this.scene.openViewport(keyson.KLE.toKeyson(name, body));
						}
						dialog.showDialog();
					});
					// TODO export to KLE somehow
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
		// this.scene.openViewport(new keyson.Keyson());
		final dialog = new NewNameDialog();
		viewport.display.paused = true;
		dialog.onDialogClosed = function(e: DialogEvent) {
			final name = dialog.name.value;
			if (StringTools.trim(name) == "")
				return;
			this.scene.openViewport(new keyson.Keyson(name));
			viewport.display.paused = false;
		}
		dialog.showDialog();
		viewport.display.paused = false;
	}

	@:bind(modeSelector, UIEvent.CHANGE)
	// TODO for toggle to ever work this must trigger regardless if change takes place
	public function switchMode(_: UIEvent) {
		trace('${toolbar} ? ${modeSelector.selectedButton.id}');
		// assuming our boxex will always be called the same
		this.sidebar = if (modeSelector.selectedButton.id == toolbar) { // we toggle  toolbars by default
			toolbar = "void";
			ComponentBuilder.fromFile("ui/sidebars/void.xml");
		} else if (modeSelector.selectedButton.id == "place") {
			toolbar = "place";
			ComponentBuilder.fromFile("ui/sidebars/place.xml");
		} else if (modeSelector.selectedButton.id == "unit") {
			toolbar = "unit";
			ComponentBuilder.fromFile("ui/sidebars/unit.xml");
		} else if (modeSelector.selectedButton.id == "legend") {
			toolbar = "legend";
			ComponentBuilder.fromFile("ui/sidebars/legend.xml");
		} else if (modeSelector.selectedButton.id == "keyboard") {
			toolbar = "keyboard";
			ComponentBuilder.fromFile("ui/sidebars/keyboard.xml");
		} else if (modeSelector.selectedButton.id == "palette") {
			toolbar = "palette";
			ComponentBuilder.fromFile("ui/sidebars/palette.xml");
		} else { // should anything go awry we default to void too
			toolbar = "void";
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
