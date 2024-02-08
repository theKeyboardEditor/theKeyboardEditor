package ui.sidebars;

import haxe.ui.containers.VBox;
import haxe.ui.components.Button;

@xml('
<vbox width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<label text="Colors:" />
	<hbox height="80%" width="156px" horizontalAlign="center" verticalAlign="center">
		<scrollview width="153px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
			<vbox width="100%" horizontalAlign="center" verticalAlign="center">
				<grid id="colors" columns="2" horizontalAlign="center" verticalAlign="center" />
			</vbox>
		</scrollview>
	</hbox>
	<label text="Selected:" />
	<hbox height="20%" horizontalAlign="center">
		<box style="background-color: #282828" width="128px" height="128px" horizontalAlign="center" verticalAlign="bottom">
			<button text="Palette: Sweetie-16" width="100%" height="100%" horizontalAlign="center" verticalAlign="center" style="background-color: #73EFF7; color: #0c0c0c;" tooltip="Click to change palette (WIP)"/>
		</box>
	</hbox>
</vbox>
')
class Palette extends VBox {
	public function new(viewport: viewport.Viewport) {
		super();
		final swatches = viewport.keyson?.colorTable.swatches ?? [];
		for (color in swatches) {
			var button = new Button();
			button.id = color.name;
			button.tooltip = color.name;
			button.width = button.height = 64;
			button.styleString = 'background-color: #${color.value.substring(4)};';
			colors.addComponent(button);
		}
	}
}
