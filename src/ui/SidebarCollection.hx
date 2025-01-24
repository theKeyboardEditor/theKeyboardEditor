package ui;

import haxe.ui.containers.HBox;
import haxe.ui.events.UIEvent;

@:xml('
<hbox width="224px" height="100%" styleName="left-box">
	<modeselector id="modeSelector" height="100%" />
	<stack width="160px" height="100%" id="sidebars">
		<place id="place-sidebar" />
		<edit id="edit-sidebar" />
		<unit id="unit-sidebar"/>
		<legend id="legend-sidebar" />
		<color id="color-sidebar" />
		<present id="present-sidebar" />
	</stack>
</hbox>
')
/**
 * A collection of different sidebars that we can switch between
 */
class SidebarCollection extends HBox {
	public var viewport: viewport.Viewport;

	@:bind(modeSelector.modes, UIEvent.CHANGE)
	function onModeChange(_) {
		sidebars.selectedIndex = modeSelector.modes.selectedIndex;
		viewport.activeMode = modeSelector.modes.selectedButton.id;
	}
}
