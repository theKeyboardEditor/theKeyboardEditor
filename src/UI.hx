package;

import haxe.ui.ComponentBuilder;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;

class UI extends haxe.ui.containers.VBox {
	public var overlay: Box;
	public var tabbar: HBox;
	public var modeSelector: VBox;
	public var sidebar: Box;
	public var welcome: VBox;

	public function new() {
		super();
		// Create base container
		this.styleString = "spacing: 0;";
		this.percentWidth = this.percentHeight = 100;

		// Render elements
		this.tabbar = ComponentBuilder.fromFile("ui/tabbar.xml");
		this.addComponent(this.tabbar);

		var left = new HBox();
		left.styleString = "spacing: 0; height: 100%;";
		this.addComponent(left);
		{
			this.modeSelector = ComponentBuilder.fromFile("ui/modeselector.xml");
			left.addComponent(this.modeSelector);

			this.sidebar = ComponentBuilder.fromFile("ui/sidebar.xml");
			left.addComponent(this.sidebar);
		}

		StatusBar.element = ComponentBuilder.fromFile("ui/status.xml");
		this.addComponent(StatusBar.element);

		this.overlay = createWelcome();
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
}
