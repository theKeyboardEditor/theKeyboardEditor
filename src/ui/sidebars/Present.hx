package ui.sidebars;

import haxe.ui.containers.VBox;

@:xml('
<vbox styleName="sidebar-body">
	<box styleName="sidebar-title">
		<label text="Present" />
	</box>
	<scrollview styleName="sidebar-main" contentWidth="100%" onmousewheel="event.cancel();">
		<vbox width="100%" horizontalAlign="center" verticalAlign="center">
			<hbox>
				<label text="Colors:" />
			</hbox>
			<hbox horizontalAlign="center">
				<button text="Body" width="64px" height="64px" tooltip="Change color" style="background-color: #94B0C2; color: #0c0c0c;"/>
				<button text="Plate" width="64px" height="64px"  tooltip="Change color" style="background-color: #566C86;"/>
			</hbox>
			<hbox horizontalAlign="left">
				<label text="Corners radii:" />
			</hbox>
			<vbox horizontalAlign="center">
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
			</vbox>
			<hbox horizontalAlign="left">
				<label text="Side widths:" />
			</hbox>
			<vbox horizontalAlign="left">
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
			</vbox>
			<hbox  horizontalAlign="left">
				<label text="Info:" />
			</hbox>
			<vbox horizontalAlign="center">
				<label text="Keyboard name:" verticalAlign="center" />
				<textfield width="133" placeholder="unknown" />
				<label text="Author name:" verticalAlign="center" />
				<textfield width="133" placeholder="provide a name" />
				<label text="License:" verticalAlign="center" />
				<textfield width="133" placeholder="IDGAF v2.1" />
				<label text="Comment:" verticalAlign="center" />
				<textfield width="133" placeholder="Created by human" />
			</vbox>
		</vbox>
	</scrollview>
</vbox>
')
class Present extends VBox {}
