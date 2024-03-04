package ui;

import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;

@:xml('
<vbox width="100%" height="100%" style="spacing: 0">
	<style>
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
		<stack width="224px" height="100%" id="sidebars-stack" selectedIndex="0" />
		<tabview id="tabs" closable="true" />
	</hbox>
	<status />
</vbox>
')
class Index extends VBox {
	public static var activeMode: Mode = Place;
	public var mainScene: MainScene;

	@:bind(tabs, UIEvent.CHANGE)
	function onTabChange(_) {
		sidebarsStack.selectedIndex = tabs.pageIndex;
	}

	//@:bind(modeSelector.picker, UIEvent.CHANGE)
	//function pickerEvents(event: UIEvent) {
	//	switch (event.relatedComponent.id) {
	//		case "new":
	//			final dialog = new ui.dialogs.NewNameDialog();
	//			dialog.onDialogClosed = function(_) {
	//				final name = dialog.name.value;
	//				if (StringTools.trim(name) == "")
	//					return;
	//				mainScene.openViewport(new keyson.Keyson(name));
	//			}
	//			dialog.showDialog();
	//		case "open":
	//			final dialog = new FileDialog();
	//			dialog.openJson("Keyson File");
	//			dialog.onFileLoaded(mainScene, (body: String) -> {
	//				mainScene.openViewport(keyson.Keyson.parse(body));
	//			});
	//		case "save":
	//			mainScene.save((cast tabs.selectedPage: ui.ViewportContainer).display.keyson, mainScene.store);
	//		case "download":
	//			mainScene.download((cast tabs.selectedPage: ui.ViewportContainer).display.keyson);
	//		case "import":
	//			final dialog = new FileDialog();
	//			dialog.openJson("KLE Json File");
	//			dialog.onFileLoaded(mainScene, (body: String) -> {
	//				var dialog = new ui.dialogs.ImportNameDialog();
	//				dialog.onDialogClosed = function(_) {
	//					final name = dialog.name.value;
	//					if (StringTools.trim(name) == "")
	//						return;
	//					mainScene.openViewport(keyson.KLE.toKeyson(name, body));
	//				}
	//				dialog.showDialog();
	//			});
	//		// TODO about and help
	//		default:
	//			StatusBar.error("Unimplemented action");
	//	}
	//}
}
