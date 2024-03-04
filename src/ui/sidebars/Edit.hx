package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;

@xml('
<vbox width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<label text="Operations:" />
	<scrollview width="153px" height="100%" contentWidth="100%" onmousewheel="event.cancel();">
		<vbox width="100%" horizontalAlign="center" verticalAlign="center">
			<hbox horizontalAlign="center">
				<!-- TODO: Move onClick event to UI.hx -->
				<button text="Undo" id="edit-undo" icon="icons/undo" width="64px" height="64px" iconPosition="top" tooltip="Undo last action"/>
				<button text="Redo" id="edit-redo" icon="icons/redo" width="64px" height="64px" iconPosition="top" tooltip="Redo last action"/>
			</hbox>
			<hbox horizontalAlign="center">
				<button text="Copy" id="edit-copy" icon="icons/copy" width="64px" height="64px" iconPosition="top" tooltip="Copy selected to buffer"/>
				<button text="Paste" id="edit-paste" icon="icons/paste" width="64px" height="64px" iconPosition="top" tooltip="Paste selected from buffer"/>
			</hbox>
			<hbox horizontalAlign="center">
				<button text="Cut" id="edit-cut" icon="icons/cut" width="133px" height="64px" iconPosition="top" tooltip="Cut selected to buffer"/>
			</hbox>
		</vbox>
	</scrollview>
</vbox>
')
class Edit extends VBox {
	public var viewport: viewport.Viewport;

	@:bind(editUndo, MouseEvent.CLICK)
	function undo(_) {
		viewport.queue.undo();
	}

	@:bind(editRedo, MouseEvent.CLICK)
	function redo(_) {
		viewport.queue.redo();
	}

	@:bind(editCopy, MouseEvent.CLICK)
	function copy(_) {
		viewport.copy();
	}

	@:bind(editCut, MouseEvent.CLICK)
	function cut(_) {
		viewport.cut();
	}

	@:bind(editPaste, MouseEvent.CLICK)
	function paste(_) {
		viewport.paste();
	}
}
