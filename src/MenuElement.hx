package;

import zui.Zui;
import zui.Id;
import kha.System;
import kha.graphics2.Graphics;

/*
 * As the name (hopefully) suggests, this is the topbar of theKeyboardEditor
 * This had to be custom made as zui doesn't contain a topbar element just yet
 * Some say if you click on the "Support" button a thousand times, the unholy spirit of my bad code appears, boo!
 */
class MenuElement {
	var _categories = [];
	static var _fileVisible = false; // This is true if the "File" tab is open
	static var _editVisible = false; // This is true if the "Edit" tabs is open, I probably don't need to keep repeating this though :p
	static var _clickX = 0; // The location of the category button you push

	public function new(ui: Zui, loc: Localization) {
		_categories = [loc.tr("File"), loc.tr("Edit"), loc.tr("Presets"), loc.tr("Toolbars"), loc.tr("Palettes"), loc.tr("Keycaps"), loc.tr("Support")];
		
		if (ui.window(Id.handle(), 0, 0, System.windowWidth(), System.windowHeight())) {
			ui.row([1/10, 1/10, 1/10, 1/10, 1/10, 1/10, 1/10, 1/10]);
			ui.text("theKeyboardEditor", Center, 0xff434c5e);

			// Goes through each category, renders it and checks if any of them have been pressed.
			for (category in _categories) {
				if (ui.button(category)) {
					switch (loc.toEnglish(category)) {
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
					loc.tr("Test 1") => test1,
					loc.tr("Test 2") => test2
			], ui);
			fileTab.handle.redraws = 60;
		} else if (_editVisible) { // edit operations: Undo, Redo, History (list), Copy, Cut, Paste, Delete, Duplicate, Select all, Invert selection, Deselect
			var editTab = new MenuTabElement(_clickX, 28, "Edit", [
					loc.tr("Test 1") => test1,
					loc.tr("Test 2") => test2,
					loc.tr("Test 3") => test3,
					loc.tr("Test 4") => test4
			], ui);
			editTab.handle.redraws = 60;
		}
	}

	//TODO:
	// Presets: <empty>, numpad, 104 ANSI, 105 ISO, 60%, Planck, 40%, possibly others
	// Toolbars: Key Shapes, Legend Ops, Color Ops, Advanced
	// Palletes: we better find some at least part way serious palettes
	// Keycaps: (global Keycap set/theme):SA, DSA, DCS, Cherry, Chicklet, Flat, Grid (can be set per key too, should affect only un-defined keys)

	// Hides all of the existing tabs, so none of them get jealous.
	public static function hideTabs() {
		_fileVisible = false;
		_editVisible = false;
	}

	// Test functions which are on death row for software piracy.
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
