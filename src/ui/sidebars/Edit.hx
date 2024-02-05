package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.containers.TabView;
import haxe.ui.events.MouseEvent;

@xml('
<vbox width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<scrollview width="153px" height="100%" contentWidth="100%" onmousewheel="event.cancel();">
		<vbox width="100%" horizontalAlign="center" verticalAlign="center">
			<hbox horizontalAlign="center">
				<!-- TODO: Move onClick event to UI.hx -->
				<button text="Undo" id="edit-undo" icon="icons/undo" width="64px" height="64px" iconPosition="top" tooltip="Undo last action"/>
				<button text="Redo" id="edit-redo" icon="icons/redo" width="64px" height="64px" iconPosition="top" tooltip="Redo last action"/>
			</hbox>
			<hbox horizontalAlign="center">
				<button text="Copy" icon="icons/copy" width="64px" height="64px" iconPosition="top" tooltip="Copy selected to buffer"/>
				<button text="Paste" icon="icons/paste" width="64px" height="64px" iconPosition="top" tooltip="Paste selected from buffer"/>
			</hbox>
			<hbox horizontalAlign="center">
				<button text="Cut" icon="icons/cut" width="133px" height="64px" iconPosition="top" tooltip="Cut selected to buffer"/>
			</hbox>
		</vbox>
	</scrollview>
</vbox>
')
class Edit extends VBox {
	public var tabs: TabView;

	@:bind(editUndo, MouseEvent.CLICK)
	function undo(_) {
		(cast tabs.selectedPage: ui.ViewportContainer).display.queue.undo();
	}

	@:bind(editRedo, MouseEvent.CLICK)
	function redo(_) {
		(cast tabs.selectedPage: ui.ViewportContainer).display.queue.redo();
	}
}
