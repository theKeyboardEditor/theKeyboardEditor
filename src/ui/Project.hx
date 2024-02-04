package ui;

@xml('
<hbox styleName="project" width="100%">
    <vbox width="100%">
        <label id="nameLabel" />
        <label text="last modified 01/01/1970" />
    </vbox>
    <button styleName="blue-button" width="90px" height="35px" text="open" />
</hbox>
')
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
