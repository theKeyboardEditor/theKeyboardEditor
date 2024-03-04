package ui;

import haxe.ui.containers.HBox;
import haxe.ui.events.UIEvent;

@:xml('
<hbox width="224px" height="100%" styleName="left-box">
	<modeselector id="modeSelector" height="100%" />
	<stack width="160px" height="100%" id="sidebars">
		<place />
		<edit id="edit-sidebar" />
		<unit />
		<legend />
		<color id="color-sidebar" />
		<present />
	</stack>
</hbox>
')
/**
 * A collection of different sidebars that we can switch between
 */
class SidebarCollection extends HBox {
	@:bind(modeSelector.modes, UIEvent.CHANGE)
	function onModeChange(_) {
		sidebars.selectedIndex = modeSelector.modes.selectedIndex;
		Index.activeMode = modeSelector.modes.selectedButton.id;
	}
}
