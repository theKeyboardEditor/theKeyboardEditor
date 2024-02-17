package ui.sidebars;

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
			<button text="Preview" width="100%" height="100%" horizontalAlign="center" verticalAlign="center" tooltip="Click to change keycap style (WIP)"/>
		</box>
	</hbox>
</vbox>
')
class Place extends VBox {
	// HaxeUI ID => Keyson Shape
	// TODO make shape and labels different one day
	static final keyTypes: Map<String, String> = [
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

	override public function new() {
		super();
		for (key => value in keyTypes) {
			var button = new Button();
			button.id = key;
			button.text = value;
			button.width = button.height = 64;
			tooltip = 'select $value sized key for placing.';
			keys.addComponent(button);
		}
	}

	@:bind(keys, UIEvent.CHANGE)
	function onSelected(_) {
		CopyBuffer.selectedKey = keyTypes[keys.selectedButton.id];
		StatusBar.inform('Selected ${CopyBuffer.selectedKey}');
	}
}
