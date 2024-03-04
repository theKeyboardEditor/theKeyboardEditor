package ui;

import haxe.ui.components.Button;
import haxe.ui.containers.ScrollView;

// TODO can we make this section be parsed depending on the palette.swatches.length?
@:xml('
<scrollview width="100%" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
	<vbox width="100%" horizontalAlign="center" verticalAlign="center">
		<button-bar id="colors" layout="grid" layoutColumns="4" horizontalAlign="center" verticalAlign="center" />
	</vbox>
</scrollview>
')
class PaletteColorView extends ScrollView {
	var columns(default, set): Int = 4;

	public function new(palette: keyson.Keyson.Palette, ?viewport: viewport.Viewport) {
		super();

		// Calculate the amount of columns
		// TODO: Don't hard code this
		this.columns = if (palette.swatches.length < 64) {
			4;
		} else if (palette.swatches.length < 160) {
			6;
		} else if (palette.swatches.length < 320) {
			8;
		} else if (palette.swatches.length < 640) {
			12;
		} else {
			16;
		}

		for (color in palette.swatches ?? []) {
			var button = new Button();
			button.id = color.name;
			button.tooltip = color.name;
			button.width = button.height = 128 / columns;
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

	function set_columns(columns: Int) {
		this.columns = columns;
		(cast colors.layout : haxe.ui.layouts.VerticalGridLayout).columns = columns;
		return columns;
	}
}
