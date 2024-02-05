package ui;

import haxe.ui.containers.Box;
import haxe.ui.containers.VerticalButtonBar;
import haxe.ui.ComponentBuilder;
import haxe.ui.events.UIEvent;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.Dialogs;

@xml('
<button-bar direction="vertical" styleName="modeSelector">
<style>
	.modeSelector {
	width: 64px;
	height: 100%;
	background-color: #282828;
	}
	.modeSelector button {
	width: 64px;
	height: 64px;
	}
	.modeSelector button:down {
	border-left: 3px solid $accent-color;
	} 
	.menu-item-picker {
	background-color: #1d2021;
	border: none;
	}
	.item-picker-container {
	border: none;
	}
</style>
	<menu-item-picker id="picker" showText="false" showIcon="false" width="64px" panelWidth="200" animatable="false" verticalAlign="center">
        <item-renderer id="itemPickerRenderer">
            <image resource="icons/kebab-dropdown" horizontalAlign="center" />
        </item-renderer>
        <data>
            <item id="new" text="New" />
            <item id="open" text="Open" />
            <item id="save" text="Save" />
            <item id="download"  text="Download" />
            <item id="import" text="Import KLE" />
            <item id="export" disabled="true" text="Export" />
        </data>
    </menu-item-picker>

    <button id="place" text="Place" icon="icons/place-mode" width="32px" height="32px" iconPosition="top" />
    <button id="edit" text="Edit" icon="icons/edit-mode" width="32px" height="32px" iconPosition="top" />
    <button id="unit" text="Unit" icon="icons/unit-mode" width="32px" height="32px" iconPosition="top" />
    <button id="legend" text="Legend" icon="icons/legend-mode" width="32px" height="32px" iconPosition="top" />
    <button id="keyboard" text="Keyboard" icon="icons/keyboard-mode" width="32px" height="32px" iconPosition="top" />
    <button id="palette" text="Palette" icon="icons/palette-mode" width="32px" height="32px" iconPosition="top" />
</button-bar>
')
class ModeSelector extends VerticalButtonBar {
	public var store: ceramic.PersistentData;
	public var mainScene: MainScene;
	public var guiScene: UI;

	@:bind(this, UIEvent.CHANGE)
	function switchMode(_: UIEvent) {
		this.guiScene.sidebar = switch (selectedButton.id) {
			case "place":
				ComponentBuilder.fromFile("ui/sidebars/place.xml");
			case "edit":
				var edit = new ui.sidebars.Edit();
				edit.tabs = guiScene.tabs;
				edit;
			case "unit":
				ComponentBuilder.fromFile("ui/sidebars/unit.xml");
			case "legend":
				ComponentBuilder.fromFile("ui/sidebars/legend.xml");
			case "keyboard":
				ComponentBuilder.fromFile("ui/sidebars/keyboard.xml");
			case "palette":
				ComponentBuilder.fromFile("ui/sidebars/palette.xml");
			default:
				ComponentBuilder.fromFile('ui/sidebars/void.xml');
		};
	}

	@:bind(picker, UIEvent.CHANGE)
	function pickerEvents(event: UIEvent) {
		switch (event.relatedComponent.id) {
			case "new":
				final dialog = new ui.dialogs.NewNameDialog();
				dialog.onDialogClosed = function(e: DialogEvent) {
					final name = dialog.name.value;
					if (StringTools.trim(name) == "")
						return;
					mainScene.openViewport(new keyson.Keyson(name));
				}
				dialog.showDialog();
			case "open":
				final dialog = new FileDialog();
				dialog.openJson("Keyson File");
				dialog.onFileLoaded(mainScene, (body: String) -> {
					mainScene.openViewport(keyson.Keyson.parse(body));
				});
			case "save":
				this.mainScene.save(cast(guiScene.tabs.selectedPage, ui.ViewportContainer).display.keyson, store);
			case "download":
				final keyson = cast(guiScene.tabs.selectedPage, ui.ViewportContainer).display.keyson;
				FileDialog.download(haxe.Json.stringify(keyson, "\t"), keyson.name, "application/json");
			case "import":
				final dialog = new FileDialog();
				dialog.openJson("KLE Json File");
				dialog.onFileLoaded(mainScene, (body: String) -> {
					var dialog = new ui.dialogs.ImportNameDialog();
					dialog.onDialogClosed = function(e: DialogEvent) {
						final name = dialog.name.value;
						if (StringTools.trim(name) == "")
							return;
						mainScene.openViewport(keyson.KLE.toKeyson(name, body));
					}
					dialog.showDialog();
				});
			default:
				StatusBar.error("Unimplemented action");
		}
	}
}
