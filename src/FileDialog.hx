package;

import ceramic.Entity;
import ceramic.Dialogs;

class FileDialog extends Entity {
	@event function fileLoaded(body: String);

	public function openKeyson() {
		#if web
		var input: js.html.InputElement = cast js.Browser.document.createElement("input");
		input.type = "file";
		input.accept = ".json";

		input.onchange = () -> {
			var reader = new js.html.FileReader();
			reader.readAsText(input.files[0]);
			reader.onloadend = () -> {
				emitFileLoaded(reader.result);
			};
		};

		input.click();
		#else
		Dialogs.openFile("Load keyson file", [{name: "Keyson File", extensions: ["json"]}], (file) -> {
			emitFileLoaded(reader.result);
		});
		#end
	}
}
