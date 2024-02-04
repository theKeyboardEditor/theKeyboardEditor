package ui.dialogs;

import haxe.ui.containers.dialogs.Dialog;

class NewNameDialog extends Dialog {
	public var name: haxe.ui.components.TextField;

	public function new() {
		super();
		this.title = "Name the new keyboard";
		this.buttons = "Name";
		this.defaultButton = "Name";
		this.width = 300;
		name = new haxe.ui.components.TextField();
		name.percentWidth = 100;
		name.placeholder = "unknown";
		this.addComponent(name);
	}
}
