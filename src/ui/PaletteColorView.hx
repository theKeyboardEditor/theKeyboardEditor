package ui;

import haxe.ui.components.Button;
import haxe.ui.containers.ScrollView;

@:xml('
<scrollview width="100%" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
	<vbox width="100%" horizontalAlign="center" verticalAlign="center">
		<button-bar id="colors" layout="grid" layoutColumns="4" horizontalAlign="center" verticalAlign="center" />
	</vbox>
</scrollview>
')
class PaletteColorView extends ScrollView {
	public function new(palette: keyson.Keyson.Palette, ?viewport: viewport.Viewport) {
		super();

		for (color in palette.swatches ?? []) {
			var button = new Button();
			button.id = color.name;
			button.tooltip = color.name;
			button.width = button.height = 128 / 4;
			button.styleString = 'background-color: #${color.value.substring(4)};';

			if (viewport != null) {
				button.onClick = e -> {
					final value = palette.fromName(button.id).value;
					if (e.shiftKey) {
						viewport.colorSelectedKeyLegends(Std.parseInt('0x${value.substring(4)}'));
					} else {
						viewport.colorSelectedKeys(Std.parseInt('0x${value.substring(4)}'));
					}
				};
			}

			colors.addComponent(button);
		}
	}
}
