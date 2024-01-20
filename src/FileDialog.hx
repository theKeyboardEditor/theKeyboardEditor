package;

import ceramic.Entity;
import ceramic.Dialogs;

class FileDialog extends Entity {
	@event function fileLoaded(body: String);
//TODO make save dialog one day too
	public function openJson(title: String) {
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
		Dialogs.openFile(title, [{name: title, extensions: ["json"]}], (file) -> {
			emitFileLoaded(file);
		});
		#end
	}
}
