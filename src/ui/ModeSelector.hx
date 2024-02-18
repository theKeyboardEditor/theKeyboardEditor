package ui;

import haxe.ui.containers.Box;
import haxe.ui.containers.VerticalButtonBar;
import haxe.ui.ComponentBuilder;
import haxe.ui.events.UIEvent;

@xml('
<button-bar direction="vertical" styleName="modeSelector">
	<menu-item-picker id="picker" showText="false" showIcon="false" width="64px" panelWidth="200" animatable="false" verticalAlign="center">
        <item-renderer id="itemPickerRenderer">
            <image resource="icons/kebab-dropdown" horizontalAlign="center" />
        </item-renderer>
        <data>
            <item id="new" text="New" />
            <item id="open" text="Open" />
            <item id="save" text="Save" />
            <item id="download" text="Download" />
            <item id="import" text="Import KLE" />
            <item id="export" disabled="true" text="Export" />
        </data>
    </menu-item-picker>

    <button id="place-mode" text="Place" icon="icons/place-mode" width="32px" height="32px" iconPosition="top" />
    <button id="edit-mode" text="Edit" icon="icons/edit-mode" width="32px" height="32px" iconPosition="top" />
    <button id="unit-mode" text="Unit" icon="icons/unit-mode" width="32px" height="32px" iconPosition="top" />
    <button id="legend-mode" text="Legend" icon="icons/legend-mode" width="32px" height="32px" iconPosition="top" />
    <button id="color-mode" text="Color" icon="icons/color-mode" width="32px" height="32px" iconPosition="top" />
    <button id="present-mode" text="Present" icon="icons/keyboard-mode" width="32px" height="32px" iconPosition="top" />
</button-bar>
')
class ModeSelector extends VerticalButtonBar {
	public var store: ceramic.PersistentData;
	public var mainScene: MainScene;
	public var guiScene: UI;
	public var barMode: Mode;

	@:bind(this, UIEvent.CHANGE)
	function onSelection(_: UIEvent) {
		if (barMode == selectedButton.id)
			return;
		this.guiScene.sidebar = switchMode(selectedButton.id);
		StatusBar.inform('Selected mode:[${this.barMode}]');
	}

	public function switchMode(id: Mode): Box {
		this.barMode = id;
		return switch (id) {
			case Place:
				new ui.sidebars.Place();
			case Edit:
				var edit = new ui.sidebars.Edit();
				edit.tabs = guiScene.tabs;
				edit;
			case Unit:
				ComponentBuilder.fromFile("ui/sidebars/unit.xml");
			case Legend:
				ComponentBuilder.fromFile("ui/sidebars/legend.xml");
			case Color:
				new ui.sidebars.Color((cast guiScene.tabs.selectedPage: ViewportContainer).display);
			case Present:
				ComponentBuilder.fromFile("ui/sidebars/present.xml");
			default:
				ComponentBuilder.fromFile('ui/sidebars/void.xml');
		};
	}

	@:bind(picker, UIEvent.CHANGE)
	function pickerEvents(event: UIEvent) {
		switch (event.relatedComponent.id) {
			case "new":
				final dialog = new ui.dialogs.NewNameDialog();
				dialog.onDialogClosed = function(_) {
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
				this.mainScene.save((cast guiScene.tabs.selectedPage: ui.ViewportContainer).display.keyson, store);
			case "download":
				this.mainScene.download((cast guiScene.tabs.selectedPage: ui.ViewportContainer).display.keyson);
//				final keyson = (cast guiScene.tabs.selectedPage: ui.ViewportContainer).display.keyson;
//				FileDialog.download(haxe.Json.stringify(keyson, "\t"), keyson.name, "application/json");
			case "import":
				final dialog = new FileDialog();
				dialog.openJson("KLE Json File");
				dialog.onFileLoaded(mainScene, (body: String) -> {
					var dialog = new ui.dialogs.ImportNameDialog();
					dialog.onDialogClosed = function(_) {
						final name = dialog.name.value;
						if (StringTools.trim(name) == "")
							return;
						mainScene.openViewport(keyson.KLE.toKeyson(name, body));
					}
					dialog.showDialog();
				});
			//TODO about and help
			default:
				StatusBar.error("Unimplemented action");
		}
	}
}
