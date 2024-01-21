package;

import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.Preloader;
import haxe.ui.Toolkit;

class Project extends Entity {
	function new(settings: InitSettings) {
		super();

		settings.title = "InKey the colorful keyboard editor";
		settings.antialiasing = 2;
		settings.background = 0xFF282828;
		settings.targetWidth = 1920;
		settings.targetHeight = 1080;
		settings.scaling = RESIZE;
		settings.resizable = true;
		settings.defaultFont = Fonts.FONTS__ROBOTO_REGULAR;

		app.onceReady(this, ready);
	}

	function ready() {
		Toolkit.init();
		// Set InKey as the current scene (see InKey.hx)
		app.scenes.main = new Preloader(() -> new InKey());
		Toolkit.theme = 'keyboard-editor-theme';
	}
}