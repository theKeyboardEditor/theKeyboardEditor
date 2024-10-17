package ui.sidebars;

import viewport.Viewport;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Variant;

@xml('
<vbox id="color-sidebar" styleName="sidebar-body">
	<box styleName="sidebar-title">
		<label text="Color" />
	</box>
	<vbox styleName="sidebar-main">
		<dropdown width="100%" id="palettes-list" text="Palettes" />
		<stack id="palettes-stack" width="156px" height="100%" horizontalAlign="center" verticalAlign="center" />
	</vbox>
</vbox>
')
class Color extends VBox {
	public var viewport(default, set): Viewport;

	public function new(?viewport: Viewport) {
		super();
		if (viewport != null) {
			this.viewport = viewport;
		}
	}

	function set_viewport(viewport: Viewport) {
		this.viewport = viewport;

		// Insert all palettes from the current keyson in the dropdown
		for (palette in viewport.keyson?.palettes) {
			addPalette(palette);
		}
		palettesList.dataSource.add("Import from JSON");

		// Grab default colors
		final defaultBodyColor = viewport.keyson?.units[viewport.focusedUnit].defaults?.keyColor;
		final defaultLegendColor = viewport.keyson?.units[viewport.focusedUnit].defaults?.legendColor;

		return viewport;
	}

	inline function addPalette(palette: keyson.Keyson.Palette) {
		final ds = palettesList.dataSource;
		ds.insert(ds.size - 1, palette.name);
		palettesStack.addComponent(new PaletteColorView(palette, viewport));
	}

	@:bind(palettesList, UIEvent.CHANGE)
	function onPaletteChange(e: UIEvent) {
		final value: String = switch (e.value) {
			case VariantType.VT_String(s): s;
			default: "";
		};

		switch (value) {
			case "Import from JSON":
				var dialog = new FileDialog();
				dialog.openJson("Keyson .JSON to extract palettes from");
				dialog.onFileLoaded(null, (contents) -> {
					final palettes = keyson.Keyson.parse(contents).palettes;
					for (palette in palettes) {
						addPalette(palette);
						viewport.keyson?.palettes.push(palette);
					}
				});
			default:
				palettesStack.selectedIndex = palettesList.selectedIndex;
		}
	}
}
