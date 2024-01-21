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

class UIOrganizer extends haxe.ui.containers.VBox {
	public var overlay: Box;
	public var midBox: HBox;
	public var leftBox: HBox;
	public var workBox: Box;
	public var fileBar: HBox; // where all file ops are processed
	public var designBar: VBox;  // where all edit and design ops are processed
	public var toolBar(default, set): Box; // where tools reside (floating)
	public var viewport: ui.ViewportComponent; // account ofr viewport size
	public var welcome: VBox;
	public var toolbar: String = 'palette'; // default (see below)
	// BUG If we initialize with void it fails to render the edit icons afterward forever!
	// But why?
	var scene: InKey;
	var store: PersistentData;

	// creating a fresh VBox
	public function new(scene: InKey, store: PersistentData) {
		super();
		this.scene = scene;
		this.store = store;

		// Remember we are already in a VBox here, that's why the top most boxes flow vertically!)
		// organize screenspace by tiling up
		/*_____fileBar_______________________________________
		 *_____#########_____midBox__________________________
		 *  |+ #toolBar#------------------------------------+
		 *l || #########                                    |
		 *e || #########                                    |
		 *f || #########            workBox                 |
		 *t || #########    (contains the Viewport)         |
		 *B || #########                                    |
		 *o || #########                                    |
		 *x || #########                          #######   |
		 *  ||_#########__________________________#gizmo#___|
		 *__|__#########__________________________#######____
		 *   StatusBar
		 * the toolbar floats on top under the gizmoGimbal layer
		 */
		this.styleString = "spacing: 0;";
		this.percentWidth = this.percentHeight = 100; // expand fully
		this.fileBar = ComponentBuilder.fromFile("ui/filebar.xml"); // HBox
		// tabbarEvents(); // move to Distributer
		this.addComponent(this.fileBar);
		midBox = new HBox();
		midBox.styleString = "spacing: 0; height: 100%; width: 64"; // fixed width
		this.addComponent(midBox); // HBox in between fileOps and statusBar
			leftBox = new HBox();
			leftBox.styleString = "spacing: 0; height: 100%; width: 64";
			midBox.addComponent(leftBox); // HBox (content flows towards right
			workBox = new Box(); // is a haxe.ui element
			workBox.styleString = "spacing: 0; height: 100%; width: 100%;";
			midBox.addComponent(workBox); // Box
			{
				this.designBar = ComponentBuilder.fromFile("ui/designbar.xml"); // 64 px
				leftBox.addComponent(this.designBar);
				this.toolBar = ComponentBuilder.fromFile("ui/toolbars/palette.xml"); // note it's not added yet! (160px)
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

	function set_toolBar(value: Box): Box {
		if (toolBar != null) { // don't remove an non existing toolBar
			leftBox.removeComponent(toolBar);
		}
		this.toolBar = value; // new to be set toolBar
		leftBox.addComponent(toolBar);
		return toolBar;
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
