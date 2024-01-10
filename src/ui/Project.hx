package ui;

@:build(haxe.ui.ComponentBuilder.build("project.xml"))
class Project extends haxe.ui.containers.HBox {
	public var name(default, set): String;

	override public function new(?name: String) {
		super();
		this.name = name ?? null;
	}

	public function set_name(name: String) {
		this.name = name;
		nameLabel.text = this.name;
		return name;
	}
}
