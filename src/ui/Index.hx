package ui;

import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;

@:xml('
<vbox width="100%" height="100%" style="spacing: 0">
	<style>
		.left-box {
			spacing: 0;
			height: 100%;
		}
		#sidebars {
			width: 160px;
			height: 100%;
		}
		#tabs {
			width: 100%;
			height: 100%;
			padding: 0;
			margin: 0;
			background-color: #1d2021;
		}
		#tabs .tabview-content {
			background-color: #282828;
		}
	</style>
	<hbox width="100%" height="100%" style="spacing: 0">
		<hbox styleName="left-box">
			<modeselector id="modeSelector" height="100%" />
			<stack id="sidebars">
				<place />
				<edit />
				<unit />
				<legend />
				<color id="color-sidebar" />
				<present />
			</stack>
		</hbox>
		<tabview id="tabs" closable="true" />
	</hbox>
	<status />
</vbox>
')
class Index extends VBox {
	public var activeMode: Mode = Place;
	public var mainScene: MainScene;

	@:bind(tabs, UIEvent.CHANGE)
	function onTabChange(_) {
		colorSidebar.viewport = (cast tabs.selectedPage: ui.ViewportContainer).display;
		trace('cast: ', colorSidebar.viewport);
	}

	@:bind(modeSelector.modes, UIEvent.CHANGE)
	function onModeChange(_) {
		this.activeMode = modeSelector.modes.selectedButton.id;
		sidebars.selectedIndex = modeSelector.modes.selectedIndex;
	}

	@:bind(modeSelector.picker, UIEvent.CHANGE)
	function pickerEvents(event: UIEvent) {
		switch (event.relatedComponent.id) {
			case "new":
				final dialog = new ui.dialogs.NewNameDialog();
				dialog.onDialogClosed = function(_) {
					final name = dialog.name.value;
					if (StringTools.trim(name) == "")
						return;
					mainScene.openViewport(new keyson.Keyson(name));
				}
				dialog.showDialog();
			case "open":
				final dialog = new FileDialog();
				dialog.openJson("Keyson File");
				dialog.onFileLoaded(mainScene, (body: String) -> {
					mainScene.openViewport(keyson.Keyson.parse(body));
				});
			case "save":
				mainScene.save((cast tabs.selectedPage: ui.ViewportContainer).display.keyson, mainScene.store);
			case "download":
				mainScene.download((cast tabs.selectedPage: ui.ViewportContainer).display.keyson);
			case "import":
				final dialog = new FileDialog();
				dialog.openJson("KLE Json File");
				dialog.onFileLoaded(mainScene, (body: String) -> {
					var dialog = new ui.dialogs.ImportNameDialog();
					dialog.onDialogClosed = function(_) {
						final name = dialog.name.value;
						if (StringTools.trim(name) == "")
							return;
						mainScene.openViewport(keyson.KLE.toKeyson(name, body));
					}
					dialog.showDialog();
				});
			// TODO about and help
			default:
				StatusBar.error("Unimplemented action");
		}
	}
}
