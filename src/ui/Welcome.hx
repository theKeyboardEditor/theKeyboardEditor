package ui;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.dialogs.Dialog;

@xml('
<vbox id="welcome" width="60%" height="65%">
	<style>
		#welcome {
			spacing: 0px;
		}

		#content {
			background-color: #1d2021;
			padding: 12px;
			spacing: 12px;
		}

		#welcome button, #welcome label {
			color: white;
		}

		#project-list {
			padding: 12px;
			spacing: 12px;
			background-color: $tertiary-background-color;
		}

		.project {
			padding: 24px;
			background-color: #1d2021;
		}

		.blue-button {
			background-color: $accent-color;
		}

		#news {
			background-color: $tertiary-background-color;
		}
	</style>
    <image width="100%" resource="header" />
	<hbox id="content" width="100%" height="100%">
		<vbox width="70%" height="100%" id="project-list">
		</vbox>
		<vbox width="30%" height="100%">
			<button id="new-project" styleName="blue-button" width="100%" height="35px" text="new project" />
			<button width="100%" height="35px" text="see community keyboards" />
			<vbox id="news" width="100%" height="100%">
				<label horizontalAlign="center" style="padding: 12px;" text="news" />
				<vbox style="padding-left: 12px;">
					<label text="no news is to be given" />
				</vbox>
			</vbox>
		</vbox>
	</hbox>
</vbox>
')
class Welcome extends VBox {
	public var scene: MainScene;

	@:bind(newProject, MouseEvent.CLICK)
	function projectNew(event: MouseEvent) {
		// this.overlay.visible = false;
		final dialog = new ui.dialogs.NewNameDialog();
		dialog.onDialogClosed = function(e: DialogEvent) {
			final name = dialog.name.value;
			if (StringTools.trim(name) == "")
				return;
			scene.openViewport(new keyson.Keyson(name));
		}
		dialog.showDialog();
	}
}
