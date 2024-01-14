package;

import ceramic.PersistentData;
import haxe.ui.ComponentBuilder;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;

class UI extends haxe.ui.containers.VBox {
	public var overlay: Box;
	public var tabbar: HBox;
	public var modeSelector: VBox;
	public var sidebar: Box;
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
		this.tabbar = ComponentBuilder.fromFile("ui/tabbar.xml");
		tabbarEvents();
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

	public function tabbarEvents() {
		this.tabbar.findComponent("picker").onChange = (e) -> {
			trace('File operation selected: ${e.relatedComponent.id}');
			switch (e.relatedComponent.id) {
				case "open":
					final dialog = new FileDialog();
					dialog.openJson("Keyson File");
					dialog.onFileLoaded(scene, (body: String) -> {
						this.scene.openViewport(keyson.Keyson.parse(body));
					});
				case "save":
					this.scene.save(scene.currentProject.keyson, store);
				case "import":
					final dialog = new FileDialog();
					dialog.openJson("KLE Json File");
					dialog.onFileLoaded(scene, (body: String) -> {
						this.scene.openViewport(keyson.KLE.toKeyson(body));
						// TODO while at it add a name to the newly created keyson
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
		this.scene.openViewport(new keyson.Keyson());
	}
}
