package;

import zui.Zui;
import zui.Id;
import kha.System;
import kha.graphics2.Graphics;

class MenuElement {
	static var _categories = ["File", "Edit", "Presets", "Tools", "Colors", "Keycaps", "Support"];
	static var _fileVisible = false;
	static var _editVisible = false;
	static var _clickX = 0;

	public function new(ui: Zui) {
		if (ui.window(Id.handle(), 0, 0, System.windowWidth(), System.windowHeight())) {
			ui.row([1/13, 1/20, 1/20, 1/20, 1/20, 1/20, 1/20, 1/20]);
			ui.text("theKeyboardEditor", Center, 0xff434c5e);

			for (category in _categories) {
				if (ui.button(category)) {
					switch (category) {
						case "File":
							if (!_fileVisible) {
								hideTabs();
								_fileVisible = true;
								_clickX = Std.int(ui.inputX);
							} else {
								hideTabs();
							}
						case "Edit":
							if (!_editVisible) {
								hideTabs();
								_editVisible = true;
								_clickX = Std.int(ui.inputX);
							} else {
								hideTabs();
							}
						case "Support":
							System.loadUrl("https://discord.gg/sNQ9crVsJK");
					}
				}
			}
		}

		if (_fileVisible) {
			var fileTab = new MenuTabElement(_clickX, null, "File", [
					"Test 1" => test1,
					"Test 2" => test2
			], ui);
			fileTab.handle.redraws = 60;
		} else if (_editVisible) {
			var editTab = new MenuTabElement(_clickX, null, "Edit", [
					"Test 1" => test1,
					"Test 2" => test2,
					"Test 3" => test3,
					"Test 4" => test4
			], ui);
			editTab.handle.redraws = 60;
		}
	}

	public static function hideTabs() {
		_fileVisible = false;
		_editVisible = false;
	}

	// Test functions
	public static function test1() {
		trace("test 1");
	}

	public static function test2() {
		trace("test 2");
	}

	public static function test3() {
		trace("test 3");
	}

	public static function test4() {
		trace("test 4");
	}
}
