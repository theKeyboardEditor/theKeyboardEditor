package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.events.UIEvent;
import ceramic.Color;

@xml('
<vbox id="color-sidebar" width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<dropdown width="100%" text="Palettes">
		<data>
			<item text="Allpad" />
			<item text="Numpad" />
			<item text="Import from JSON" />
		</data>
	</dropdown>
	<hbox height="80%" width="156px" horizontalAlign="center" verticalAlign="center">
		<scrollview width="153px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
			<vbox width="100%" horizontalAlign="center" verticalAlign="center">
				<button-bar id="colors" layout="grid" layoutColumns="4" horizontalAlign="center" verticalAlign="center" />
			</vbox>
		</scrollview>
	</hbox>
	<hbox height="20%" horizontalAlign="center">
		<box style="background-color: #282828" width="128px" height="128px" horizontalAlign="center" verticalAlign="bottom">
			<keycap id="preview" width="100%" height="100%" bodyColor="#00ff00" />
		</box>
	</hbox>
</vbox>
')
class Color extends VBox {
	public function new(viewport: viewport.Viewport) {
		super();
		final palette = viewport.keyson?.palettes[0];

		final defBodyColor = viewport.keyson?.units[viewport.currentUnit].defaults.keyColor;
		final defLegendColor = viewport.keyson?.units[viewport.currentUnit].defaults.legendColor;

		preview.color = Std.parseInt('${defLegendColor}');
		preview.bodyColor = Std.parseInt('${defBodyColor}');
		preview.tooltip = 'Click for default colors.';

		for (color in palette.swatches ?? []) {
			var button = new Button();
			button.id = color.name;
			button.tooltip = color.name;
			button.width = button.height = 128 / 4;

			final value = new ceramic.Color(Std.parseInt('0x${color.value.substring(4)}'));
			final bodiesPresent = bodiesPresent(viewport, value);
			final legendsPresent = legendsPresent(viewport, value);

			if (bodiesPresent && legendsPresent) {
				button.text = "LB";
			} else if (bodiesPresent) {
				button.text = "B";
			} else if (legendsPresent) {
				button.text = "L";
			};

			if (value.lightness >= 0.500) {
				button.styleString = 'background-color: #${color.value.substring(4)}; color: #00000F;';
			} else {
				button.styleString = 'background-color: #${color.value.substring(4)}; color: #FCFCFF;';
			}

			button.onClick = e -> {
				final value = palette.fromName(button.id).value;
				if (e.shiftKey) {
					// preview.color = Std.parseInt('0x${value.substring(4)}');
					viewport.colorSelectedKeyLegends(Std.parseInt('0x${value.substring(4)}'));
				} else {
					// preview.bodyColor = Std.parseInt('0x${value.substring(4)}');
					viewport.colorSelectedKeys(Std.parseInt('0x${value.substring(4)}'));
				}
			};

			colors.addComponent(button);
		}
	}

	// Returns true if there is a THIS colored one or more bodies in selection
	function bodiesPresent(viewport: viewport.Viewport, color: ceramic.AlphaColor) {
		final keySet = viewport.keyson?.units[viewport.currentUnit].keys;
		for (k in keySet) {
			if ('0x${StringTools.hex(Std.parseInt(k.color))}' == color.toString())
				return true;
		}
		return false;
	}

	// Returns true if there is a THIS colored one or more legends in selection
	function legendsPresent(viewport: viewport.Viewport, color: ceramic.AlphaColor) {
		final keySet = viewport.keyson?.units[viewport.currentUnit].keys;
		for (k in keySet) {
			for (l in k.legends) {
				if ('0x${StringTools.hex(Std.parseInt(l.color))}' == color.toString())
					return true;
			}
		}
		return false;
	}
}
