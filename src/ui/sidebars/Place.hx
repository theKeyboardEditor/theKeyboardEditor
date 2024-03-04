package ui.sidebars;

import viewport.Viewport;
import haxe.ui.containers.VBox;
import haxe.ui.components.Button;
import haxe.ui.events.UIEvent;

@xml('
<vbox width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<label text="Keys:" />
	<hbox height="80%" width="156px" horizontalAlign="center" verticalAlign="center">
		<scrollview width="153px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
			<vbox width="100%" horizontalAlign="center" verticalAlign="center">
				<button-bar id="keys" layout="grid" layoutColumns="2" horizontalAlign="center" verticalAlign="center"></button-bar>
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
class Place extends VBox {
	// HaxeUI ID => Keyson Shape
	var keyTypes: Map<String, String> = [
		"oneU" => "1U",
		"oneTwentyFiveU" => "1.25U",
		"oneFiveU" => "1.5U",
		"oneSeventyFiveU" => "1.75U",
		"twoU" => "2U",
		"twoTwentyFiveU" => "2.25U",
		"twoSeventyFiveU" => "2.75U",
		"twoUVertical" => "2U Vertical",
		"caps38oo" => "1.75U Stepped 1.5",
		"caps3ooo" => "1.75U Stepped 1.25",
		"ISO" => "ISO",
		"sixTwentyFiveU" => "6.25U",
		"BAE" => "BAE",
		"sevenU" => "7U",
		"AEK" => "AEK",
		"XT2U" => "XT_2U",
	];

	public var viewport(default, set): Viewport;

	public function new(?viewport: Viewport) {
		super();
		if (viewport != null) {
			this.viewport = viewport;
		}

		// TODO make shape and labels different one day
		for (key => value in keyTypes) {
			var button = new Button();
			button.id = key;
			button.text = value;
			button.width = button.height = 64;
			button.tooltip = 'select $value sized key for placing.';
			keys.addComponent(button);
		}
		preview.tooltip = 'Click to change keycaps (WIP)';

	}

	function set_viewport(viewport: Viewport) {
		this.viewport = viewport;

		// TODO can't make this to work
		preview.bodyColor = "#FCFCFC";

		return viewport;
	}

	@:bind(keys, UIEvent.CHANGE)
	function onSelected(_) {
		CopyBuffer.designatedKey = keyTypes[keys.selectedButton.id];
		StatusBar.inform('Selected ${CopyBuffer.designatedKey}');
	}

}
