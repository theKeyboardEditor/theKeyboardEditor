package;

import haxe.ui.ComponentBuilder;

class UI extends haxe.ui.containers.VBox {
	public var tabbar: haxe.ui.containers.HBox;
	public var modeSelector: haxe.ui.containers.VBox;
	public var sidebar: haxe.ui.containers.Box;
	public var welcome: haxe.ui.containers.VBox;

	public function new() {
		super();
		// Create base container
		this.styleString = "spacing: 0;";
		this.percentWidth = this.percentHeight = 100;

		// Render elements
		tabbar = ComponentBuilder.fromFile("ui/tabbar.xml");
		this.addComponent(tabbar);

		var left = new haxe.ui.containers.HBox();
		left.styleString = "spacing: 0; height: 100%;";
		this.addComponent(left);
		{
			modeSelector = ComponentBuilder.fromFile("ui/modeselector.xml");
			left.addComponent(modeSelector);

			sidebar = ComponentBuilder.fromFile("ui/sidebar.xml");
			left.addComponent(sidebar);
		}

		StatusBar.element = ComponentBuilder.fromFile("ui/status.xml");
		this.addComponent(StatusBar.element);

		var full = new haxe.ui.containers.Box();
		full.percentWidth = 100;
		full.percentHeight = 100;

		welcome = ComponentBuilder.fromFile("ui/welcome.xml");
		welcome.horizontalAlign = "center";
		welcome.verticalAlign = "center";

		full.addComponent(welcome);
	}
}
