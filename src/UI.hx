package;

import ceramic.PersistentData;
import haxe.ui.ComponentBuilder;
import haxe.ui.containers.TabView;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;

using StringTools;

class UI extends haxe.ui.containers.VBox {
	public var tabs: TabView;
	public var overlay: Box;
	public var leftBox: HBox;
	public var tabbar: HBox;
	public var modeSelector: ui.ModeSelector;
	public var sidebar(default, set): Box;
	public var welcome: ui.Welcome;

	var scene: MainScene;
	var store: PersistentData;

	public function new(scene: MainScene, store: PersistentData) {
		super();
		this.scene = scene;
		this.store = store;

		// Create base container
		this.styleString = "spacing: 0;";
		this.percentWidth = this.percentHeight = 100;

		// MIDDLE
		var middle = new HBox();
		middle.styleString = "spacing: 0; width: 100%; height: 100%;";
		this.addComponent(middle);

		tabs = new TabView();
		tabs.styleString = "width: 100%; height: 100%; padding: 0; background-color: #1d2021;";
		tabs.findComponent('tabview-content').styleString = "background-color: #282828;";
		tabs.closable = true;

		leftBox = new HBox();
		leftBox.styleString = "spacing: 0; height: 100%;";
		{
			this.modeSelector = new ui.ModeSelector();
			this.modeSelector.percentHeight = 100;
			modeSelector.guiScene = this;
			modeSelector.mainScene = scene;
			modeSelector.store = store;
			leftBox.addComponent(this.modeSelector);

			// This is the default sidebar
			// Note to future developers: when sidebar is set it automatically gets added
			this.sidebar = modeSelector.switchMode("place");
		}
		middle.addComponent(leftBox);
		middle.addComponent(tabs);

		// BOTTOM
		StatusBar.element = ComponentBuilder.fromFile("ui/status.xml");
		this.addComponent(StatusBar.element);

		// This is put on top of all other elements
		this.overlay = createWelcome();
	}

	function set_sidebar(value: Box): Box {
		if (sidebar == value) {
			return sidebar;
		}
		if (sidebar != null) {
			leftBox.removeComponent(sidebar);
		}

		this.sidebar = value;
		leftBox.addComponent(sidebar);

		return sidebar;
	}

	function createWelcome(): Box {
		var overlay = new Box();
		overlay.percentWidth = 100;
		overlay.percentHeight = 100;

		welcome = new ui.Welcome();
		welcome.horizontalAlign = "center";
		welcome.verticalAlign = "center";
		welcome.scene = scene;

		overlay.addComponent(welcome);

		return overlay;
	}
}
