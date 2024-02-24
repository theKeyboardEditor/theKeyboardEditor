package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.events.UIEvent;
import ceramic.Color;

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
	<label text="Active unit:" />
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
		var workSurface = viewport;
		var palette = viewport.keyson?.colorTable;
		// TODO show the active unit's default colors
		var defBodyColor = workSurface.keyson?.units[workSurface.currentUnit].keysColor;
		var defLegendColor = workSurface.keyson?.units[workSurface.currentUnit].legendColor;
		preview.legendColor = Std.parseInt('${defLegendColor}');
		preview.bodyColor = Std.parseInt('${defBodyColor}');
		preview.tooltip = 'Click for default colors.';
		for (color in palette.swatches ?? []) {
			var button = new Button();
			button.id = color.name;
			button.tooltip = color.name;
			button.text = ""; // reset text
			// TODO one day make show only used colors switch here
			final value = new ceramic.Color(Std.parseInt('0x${color.value.substring(4)}'));
			if ( bodiesPresent(workSurface, value) ) {
				button.text = "B"; // body color present
				if ( legendsPresent(workSurface, value) )
					button.text = "LB"; // legend too
			} else { // no body color
			if ( bodiesPresent(workSurface, value) )
				button.text = "L"; // legend only
			}
			button.width = button.height = 128 / 4;
			// determine how light is a color:
			if ( value.lightness >= 0.500 ) {
				// lighter than half the value
				button.styleString = 'background-color: #${color.value.substring(4)}; color: #00000F;';
			} else {
				// normal (darker)
				button.styleString = 'background-color: #${color.value.substring(4)}; color: #FCFCFF;';
			}
			button.onClick = e -> {
				final value = palette.fromName(button.id).value;
				if (e.shiftKey) {
					// preview.legendColor = Std.parseInt('0x${value.substring(4)}');
					viewport.colorSelectedKeyLegends(Std.parseInt('0x${value.substring(4)}'));
				} else {
					// preview.bodyColor = Std.parseInt('0x${value.substring(4)}');
					viewport.colorSelectedKeys(Std.parseInt('0x${value.substring(4)}'));
				}
			};
			colors.addComponent(button);
		}
	}

	// return true if  there is a THIS colored one or more bodies in selection
	private function bodiesPresent(workSurface: viewport.Viewport, color: ceramic.AlphaColor) {
		final keySet = workSurface.keyson?.units[workSurface.currentUnit].keys;
		var result: Bool = false;
		for ( k in keySet) {
			if ('0x${StringTools.hex(Std.parseInt(k.keysColor))}' == color.toString()) {
				result = true;
				break;
			}
		}
		return result;
	}

	// return true if  there is a THIS colored one or more legends in selection
	private function legendsPresent(workSurface: viewport.Viewport, color: ceramic.AlphaColor) {
		final keySet = workSurface.keyson?.units[workSurface.currentUnit].keys;
		var result: Bool = false;
		for (k in keySet) {
			for (l in k.legends) {
				if ('0x${StringTools.hex(Std.parseInt(l.legendColor))}' == color.toString()) {
					result = true;
					break;
				}
				if (result)
				break;
			}
		}
		return result;
	}
}
