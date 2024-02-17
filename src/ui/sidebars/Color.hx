package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.events.UIEvent;

@xml('
<vbox id="color-sidebar" width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<label text="Colors:" />
	<hbox height="80%" width="156px" horizontalAlign="center" verticalAlign="center">
		<scrollview width="153px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
			<vbox width="100%" horizontalAlign="center" verticalAlign="center">
				<button-bar id="colors" layout="grid" layoutColumns="4" horizontalAlign="center" verticalAlign="center" />
			</vbox>
		</scrollview>
	</hbox>
	<label text="Selected:" />
	<hbox height="20%" horizontalAlign="center">
		<box style="background-color: #282828" width="128px" height="128px" horizontalAlign="center" verticalAlign="bottom">
			<keycap id="preview" width="100%" height="100%" bodyColor="#00ff00" />
		</box>
	</hbox>
</vbox>
')
class Color extends VBox {
	var palette: keyson.Keyson.Palette;

	public function new(viewport: viewport.Viewport) {
		super();

		palette = viewport.keyson?.colorTable;
		for (color in palette.swatches ?? []) {
			var button = new Button();
			button.id = color.name;
			button.tooltip = color.name;
			button.width = button.height = 128 / 4;
			button.styleString = 'background-color: #${color.value.substring(4)};';
			colors.addComponent(button);
		}
	}

	@:bind(colors, UIEvent.CHANGE)
	function onSelected(_) {
		final value = palette.fromName(colors.selectedButton.id).value;
		preview.bodyColor = Std.parseInt('0x${value.substring(4)}');
	}
}
