package;

import kha.System;
import kha.Scheduler;
import kha.Assets;
import kha.Window;
#if kha_html5
import kha.Macros;
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end

/*
 * Used for window creation and calling the app class.
 */
class Main {
	public static function main() {
		System.start({title: "theKeyboardEditor", width: 1920, height: 1080}, function (_) {
			setFullWindowCanvas();
			new MainView();
		});
	}

	/*
	 * Makes the html window full screen, stolen from Kha wiki
	 */
	static function setFullWindowCanvas():Void {
		#if kha_html5
		//make html5 canvas resizable
		document.documentElement.style.padding = "0";
		document.documentElement.style.margin = "0";
		document.body.style.padding = "0";
		document.body.style.margin = "0";
		var canvas:CanvasElement = cast document.getElementById(Macros.canvasId());
		canvas.style.display = "block";

		var resize = function() {
			canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
			canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
			canvas.style.width = document.documentElement.clientWidth + "px";
			canvas.style.height = document.documentElement.clientHeight + "px";
		}
		window.onresize = resize;
		resize();
		#end
	}

}
