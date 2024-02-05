package;

import ceramic.Entity;
import ceramic.Timer;
import ceramic.InitSettings;
import ceramic.Preloader;
import haxe.ui.Toolkit;

class Project extends Entity {
	function new(settings: InitSettings) {
		super();

		settings.title = "insert editor name here";
		settings.antialiasing = 2;
		settings.background = 0xFF282828;
		settings.targetWidth = 1920;
		settings.targetHeight = 1080;
		settings.scaling = RESIZE;
		settings.resizable = true;
		settings.defaultFont = Fonts.FONTS__ROBOTO_REGULAR;
		autoFps(settings);

		app.onceReady(this, ready);
	}

	function ready() {
		Toolkit.init();
		// Set MainScene as the current scene (see MainScene.hx)
		app.scenes.main = new Preloader(() -> new MainScene());
		Toolkit.theme = 'keyboard-editor-theme';
	}

	function autoFps(settings: InitSettings) {
		var lastFastFpsTime: Float = Timer.now;
		settings.targetFps = 60;

		Timer.interval(this, 0.5, () -> {
			if (Timer.now - lastFastFpsTime > 5.0) {
				settings.targetFps = 15;
			}
		});

		screen.onPointerDown(this, _ -> {
			lastFastFpsTime = Timer.now;
			settings.targetFps = 60;
		});
	}
}
