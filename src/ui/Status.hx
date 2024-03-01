package ui;

import haxe.ui.containers.HBox;

@:xml('
<hbox styleName="status" width="100%">
	<style>
		#container {
			background-color: $accent-color;
		}

		#action, #pos {
			color: white;
			background-color: $accent-color;
			padding-top: 6px;
			padding-bottom: 6px;
			padding-left: 12px;
			padding-right: 12px;
		}

	</style>
	<box id="container" width="100%">
		<label id="action" width="75%" text="Hello :3" />
		<label id="pos" width="25%" horizontalAlign="right" text="cursor pos: 0 x 0" />
	</box>
</hbox>
')
class Status extends HBox {
	
}
