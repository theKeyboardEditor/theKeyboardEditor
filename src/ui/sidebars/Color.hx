package ui.sidebars;

import viewport.Viewport;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Variant;

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
	public var viewport(default, set): Viewport;

	public function new(?viewport: Viewport) {
		super();
		// FIXME this is always null, why?
		if (viewport != null) {
			this.viewport = viewport;
			trace('new: ', viewport);
		}
	}

	function set_viewport(viewport: Viewport) {
		// Insert all palettes from the current keyson in the dropdown
		palettesList.dataSource.add("Import from JSON");
		for (palette in viewport.keyson?.palettes) {
			addPalette(palette);
		}

		// Grab default colors
		final defaultBodyColor = viewport.keyson?.units[viewport.currentUnit].defaults?.keyColor;
		final defaultLegendColor = viewport.keyson?.units[viewport.currentUnit].defaults?.legendColor;

		// Set the properties of the preview keycap
		preview.legendColor = Std.parseInt(defaultLegendColor);
		preview.bodyColor = Std.parseInt(defaultBodyColor);
		preview.tooltip = 'Click to apply default colors';
		// FIXME why does this work here and no up there in new() ?
		if (viewport != null) {
			this.viewport = viewport;
			trace('set: ', viewport);
		}

		return viewport;
	}

	// FIXME why does the list douplicate if no new palette is loaded?
	inline function addPalette(palette: keyson.Keyson.Palette) {
		trace('columns: ${((palette.swatches.length >> 7 & 1) * 4) + 4}');
		final ds = palettesList.dataSource;
		ds.insert(ds.size - 1, palette.name);
		// at 128 (== 2 ^ 7) colors we decrease the swatch size:
		if (palette.swatches.length < 64) {
			palettesStack.addComponent(new PaletteColorView4(palette, viewport));
			trace('columns: 4');
		} else if (palette.swatches.length < 160) {
			palettesStack.addComponent(new PaletteColorView6(palette, viewport));
			trace('columns: 6');
		} else if (palette.swatches.length < 320) {
			palettesStack.addComponent(new PaletteColorView8(palette, viewport));
			trace('columns: 8');
		} else if (palette.swatches.length < 640) {
			palettesStack.addComponent(new PaletteColorView12(palette, viewport));
		} else {
			palettesStack.addComponent(new PaletteColorView16(palette, viewport));
			trace('columns: 17');
		}
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
