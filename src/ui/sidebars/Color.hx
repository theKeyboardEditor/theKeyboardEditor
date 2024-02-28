package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Variant;
import ceramic.Color;

@xml('
<vbox id="color-sidebar" width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<dropdown width="100%" id="palettes-list" text="Palettes" />
	<stack id="palettes-stack" width="156px" height="80%" horizontalAlign="center" verticalAlign="center" />
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
		// Insert all palettes from the current keyson in the dropdown
		for (palette in viewport.keyson?.palettes) {
			palettesList.dataSource.add(palette.name);
			palettesStack.addComponent(new PaletteColorView(palette, viewport));
		}
		palettesList.dataSource.add("Import from JSON");

		// Grab default colors
		final defaultBodyColor = viewport.keyson?.units[viewport.currentUnit].defaults.keyColor;
		final defaultLegendColor = viewport.keyson?.units[viewport.currentUnit].defaults.legendColor;

		// Set the properties of the preview keycap
		preview.legendColor = Std.parseInt(defaultLegendColor);
		preview.bodyColor = Std.parseInt(defaultBodyColor);
		preview.tooltip = 'Click for default colors';
	}

	@:bind(palettesList, UIEvent.CHANGE)
	function onPaletteChange(e: UIEvent) {
		final value: String = switch (e.value) {
			case VariantType.VT_String(s): s;
			default: "";
		};

		switch (value) {
			case "Import from JSON":
				{
					// doThings();
				}
			default:
				{
					palettesStack.selectedIndex = palettesList.selectedIndex;
				}
		}
	}
}
