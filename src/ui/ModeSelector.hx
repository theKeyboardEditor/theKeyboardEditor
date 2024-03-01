package ui;

import haxe.ui.containers.VerticalButtonBar;

@xml('
<vbox style="spacing: 0">
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
	<button-bar selectedIndex="0" direction="vertical" id="modes" styleName="modeSelector">
		<button id="place-mode" text="Place" icon="icons/place-mode" width="32px" height="32px" iconPosition="top" />
		<button id="edit-mode" text="Edit" icon="icons/edit-mode" width="32px" height="32px" iconPosition="top" />
		<button id="unit-mode" text="Unit" icon="icons/unit-mode" width="32px" height="32px" iconPosition="top" />
		<button id="legend-mode" text="Legend" icon="icons/legend-mode" width="32px" height="32px" iconPosition="top" />
		<button id="color-mode" text="Color" icon="icons/color-mode" width="32px" height="32px" iconPosition="top" />
		<button id="present-mode" text="Present" icon="icons/keyboard-mode" width="32px" height="32px" iconPosition="top" />
	</button-bar>
</vbox>
')
class ModeSelector extends VerticalButtonBar {}
