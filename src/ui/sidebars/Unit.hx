package ui.sidebars;

import haxe.ui.containers.VBox;

@:xml('
<vbox width="160" height="100%" style="padding: 4px; background-color: #1d2021;">
	<label text="Devices:" />
	<hbox height="100%" width="156px" horizontalAlign="center" verticalAlign="center">
		<scrollview width="153px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
			<vbox width="100%" horizontalAlign="center" verticalAlign="center">
				<hbox  horizontalAlign="left">
					<label text="Units:" />
				</hbox>
				<vbox horizontalAlign="center">
					<number-stepper width="133" pos="1" step="1" min="1" max="32" disabled="true"/>
					<!-- this actually never should get enabled -->
				</vbox>
				<hbox  horizontalAlign="left">
					<label text="Unit:" />
				</hbox>
				<vbox horizontalAlign="center">
					<number-stepper width="133" pos="0" step="1" min="0" max="1" />
					<button text="Create" width="100%" disabled="true" />
					<!-- increment max units only as a new one gets created, then disble the create button again -->
				</vbox>
				<hbox>
					<label text="Colors:" />
				</hbox>
				<hbox  horizontalAlign="center">
					<button text="Body"  width="64px" height="64px" tooltip="Change color" style="background-color: #94B0C2; color: #0c0c0c;"/>
					<button text="Plate"  width="64px" height="64px"  tooltip="Change color" style="background-color: #566C86;"/>
				</hbox>
				<hbox  horizontalAlign="left">
					<label text="Key step" />
				</hbox>
				<vbox horizontalAlign="center">
					<number-stepper width="133" pos="19.05" step=".01" min="0" max="512" precision="2" />
					<number-stepper width="133" pos="19.05" step=".01" min="0" max="512" precision="2" />
				</vbox>
				<hbox  horizontalAlign="center">
					<label text="Keycap size:" />
				</hbox>
				<vbox horizontalAlign="left">
					<number-stepper width="133" pos="18.5" step=".1" min="0" max="512" precision="2" />
					<number-stepper width="133" pos="18.5" step=".1" min="0" max="512" precision="2" />
				</vbox>
				<hbox  horizontalAlign="left">
					<label text="Unit angle:" />
				</hbox>
				<vbox horizontalAlign="center">
					<number-stepper width="133" pos="0" step=".5" min="0" max="359.99" precision="2" />
				</vbox>
				<hbox  horizontalAlign="left">
					<label text="Corners radii:" />
				</hbox>
				<vbox horizontalAlign="center">
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				</vbox>
				<hbox  horizontalAlign="left">
					<label text="Side widths:" />
				</hbox>
				<vbox horizontalAlign="left">
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
					<number-stepper width="133" pos="8" step=".5" min="0" max="200" precision="2" />
				</vbox>
			</vbox>
		</scrollview>
	</hbox>
</vbox>
')
class Unit extends VBox {}
