package ui.sidebars;

import haxe.ui.containers.VBox;

@:xml('
<vbox styleName="sidebar-body">
	<box styleName="sidebar-title">
		<label text="Present" />
	</box>
	<scrollview styleName="sidebar-main" contentWidth="100%">
		<label text="404 sidebar not found" />
	</scrollview>
</vbox>
')
class Present extends VBox {}
