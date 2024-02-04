package ui.dialogs;

import haxe.ui.containers.dialogs.Dialog;

class ImportNameDialog extends Dialog {
	public var name: haxe.ui.components.TextField;

	public function new() {
		super();
		this.title = "Name the imported keyboard";
		this.buttons = "Import";
		this.defaultButton = "Import";
		this.width = 300;
		name = new haxe.ui.components.TextField();
		name.percentWidth = 100;
		name.placeholder = "Keyboard Name";
		this.addComponent(name);
	}
}
