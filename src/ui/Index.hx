package ui;

import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;

@:xml('
<vbox width="100%" height="100%" style="spacing: 0">
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

	public function switchMode(mode: Mode) {
		var modes = cast(sidebarsStack.getComponentAt(sidebarsStack.selectedIndex), ui.SidebarCollection).modeSelector.modes;
		modes.selectedButton = modes.findComponent(mode);
	}

	@:bind(tabs, UIEvent.CHANGE)
	function onTabChange(_) {
		sidebarsStack.selectedIndex = tabs.pageIndex;
	}
}
