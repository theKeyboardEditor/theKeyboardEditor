package ui;

import haxe.ui.containers.HBox;

@:xml('
<hbox styleName="status" width="100%">
	<box styleName="status-container" width="100%">
		<label id="action" width="75%" text="Hello :3" />
		<label id="pos" width="25%" horizontalAlign="right" text="cursor pos: 0 x 0" />
	</box>
</hbox>
')
class Status extends HBox {}
