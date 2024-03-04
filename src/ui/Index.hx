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
}
