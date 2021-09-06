package;

import zui.Zui;
import zui.Id;
import kha.System;
import kha.graphics2.Graphics;

class MenuElement {
	static var _categories = ["File", "Edit", "Presets", "Toolbars", "Palettes", "Keycaps", "Support"];
	static var _fileVisible = false;
	static var _editVisible = false;
	static var _clickX = 0;

	public function new(ui: Zui) {
		if (ui.window(Id.handle(), 0, 0, System.windowWidth(), System.windowHeight())) {
			ui.row([1/10, 1/10, 1/10, 1/10, 1/10, 1/10, 1/10, 1/10]);
			ui.text("theKeyboardEditor", Center, 0xff434c5e);

			for (category in _categories) {
				if (ui.button(category)) {
					switch (category) {
						case "File":
							if (!_fileVisible) {
								hideTabs();
								_fileVisible = true;
								_clickX = Std.int(1*System.windowWidth()/10);
							} else {
								hideTabs();
							}
						case "Edit":
							if (!_editVisible) {
								hideTabs();
								_editVisible = true;
								_clickX = Std.int(2*System.windowWidth()/10);
							} else {
								hideTabs();
							}
						case "Support":
							System.loadUrl("https://discord.gg/sNQ9crVsJK");
					}
				}
			}
		}

		if (_fileVisible) { // file operations: Save, Load, Dowload, Upload, Import KLE, Export KLE, Export BOM.CSV
			var fileTab = new MenuTabElement(_clickX, 28, "File", [
					"Test 1" => test1,
					"Test 2" => test2
			], ui);
			fileTab.handle.redraws = 60;
		} else if (_editVisible) { // edit operations: Undo, Redo, History (list), Copy, Cut, Paste, Delete, Duplicate, Select all, Invert selection, Deselect
			var editTab = new MenuTabElement(_clickX, 28, "Edit", [
					"Test 1" => test1,
					"Test 2" => test2,
					"Test 3" => test3,
					"Test 4" => test4
			], ui);
			editTab.handle.redraws = 60;
		}
	}
//TODO:
// Presets: <empty>, numpad, 104 ANSI, 105 ISO, 60%, Planck, 40%, possibly others
// Toolbars: Key Shapes, Legend Ops, Color Ops, Advanced
// Palletes: we better find some at least part way serious palettes
// Keycaps: (global Keycap set/theme):SA, DSA, DCS, Cherry, Chicklet, Flat, Grid (can be set per key too, should affect only un-defined keys)

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
