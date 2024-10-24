package ui.sidebars;

import haxe.ui.containers.VBox;

@:xml('
<vbox styleName="sidebar-body">
	<box styleName="sidebar-title">
		<label text="Legend" />
	</box>
	<scrollview styleName="sidebar-main" contentWidth="100%" onmousewheel="event.cancel();">
		<hbox horizontalAlign="left">
			<label text="Selection:" />
		</hbox>
		<vbox width="100%" >
			<button text="Add new legend" width="100%" />
		</vbox>
		<vbox width="100%" horizontalAlign="center" verticalAlign="center">
			<!-- height of 680 allows for somewhat decent view at 1024x758 resolution -->
			<accordion width="146px" height="680">
				<!-- The two default elements every keyboard will have: -->
				<vbox id="global" text="Global" style="padding: 2px;">
					<scrollview width="140px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
						<dropdown text="Select a font:">
							<data>
								<item text="<default>" />
								<item text="Noto" />
								<item text="Roboto" />
								<item text="Tahoma" />
								<item text="Consolas" />
								<item text="Din-D" />
								<item text="Vera-Sans" />
							</data>
						</dropdown>
						<hbox horizontalAlign="left">
							<label text="Font size:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="9" step="1" min="5" max="144" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Text position:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Rotation anchor:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Legend angle:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step="22.5" min="0" max="359" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="All Legends:" />
						</hbox>
						<vbox width="100%" >
							<button text="Default" width="100%" />
							<button text="Propagate" width="100%" />
						</vbox>
					</scrollview>
				</vbox>
				<vbox id="unit-0" text="[Numpad]" style="padding: 2px;">>
					<scrollview width="140px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
						<dropdown text="Select a font:">
							<data>
								<item text="<none>" />
								<item text="Noto" />
								<item text="Roboto" />
								<item text="Tahoma" />
								<item text="Consolas" />
								<item text="Din-D" />
								<item text="Vera-Sans" />
							</data>
						</dropdown>
						<hbox horizontalAlign="left">
							<label text="Font size:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="9" step="1" min="5" max="144" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Text position:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Rotation anchor:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Legend angle:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step="22.5" min="0" max="359" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Unit legends:" />
						</hbox>
						<vbox width="100%" >
							<button text="Clear" width="100%" />
							<button text="Propagate" width="100%" />
						</vbox>
					</scrollview>
				</vbox>
				<!-- end of The two default elements every keyboard will have -->
				<vbox id="legend-0" text="[Q]" style="padding: 2px;">>
					<scrollview width="140px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
						<label text="Legend text:" verticalAlign="center" />
						<textfield width="128" placeholder="Q" />
						<dropdown text="Select a font:">
							<data>
								<item text="<none>" />
								<item text="Noto" />
								<item text="Roboto" />
								<item text="Tahoma" />
								<item text="Consolas" />
								<item text="Din-D" />
								<item text="Vera-Sans" />
							</data>
						</dropdown>
						<hbox horizontalAlign="left">
							<label text="Font size:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="9" step="1" min="5" max="144" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Text position:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Rotation anchor:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Legend angle:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step="22.5" min="0" max="359" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="This Legend:" />
						</hbox>
						<vbox width="100%" >
							<button text="Delete" width="100%" />
							<button text="Duplicate" width="100%" />
							<button text="Apply to all" width="100%" />
						</vbox>
					</scrollview>
				</vbox>
				<vbox id="legend-1" text="[|]" style="padding: 2px;">>
					<scrollview width="140px" height="100%" contentWidth="100%" autoHideScrolls="true" onmousewheel="event.cancel();">
						<label text="Legend text:" verticalAlign="center" />
						<textfield width="128" placeholder="|" />
						<dropdown text="Select a font:">
							<data>
								<item text="<none>" />
								<item text="Noto" />
								<item text="Roboto" />
								<item text="Tahoma" />
								<item text="Consolas" />
								<item text="Din-D" />
								<item text="Vera-Sans" />
							</data>
						</dropdown>
						<hbox horizontalAlign="left">
							<label text="Font size:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="9" step="1" min="5" max="144" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Text position:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="8" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Rotation anchor:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
							<number-stepper width="128" pos="0" step=".1" min="-32767" max="32768" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="Legend angle:" />
						</hbox>
						<vbox horizontalAlign="left">
							<number-stepper width="128" pos="0" step="22.5" min="0" max="359" precision="2" />
						</vbox>
						<hbox horizontalAlign="left">
							<label text="This Legend:" />
						</hbox>
						<vbox width="100%" >
							<button text="Delete" width="100%" />
							<button text="Duplicate" width="100%" />
							<button text="Apply to all" width="100%" />
						</vbox>
					</scrollview>
				</vbox>
			</accordion>
		</vbox>
	</scrollview>
</vbox>
')
class Legend extends VBox {}
