package ui;

import haxe.ui.util.Color;
import haxe.ui.containers.Box;
import haxe.ui.events.UIEvent;

class Keycap extends Box {
	public var bodyColor(default, set): Null<Color> = 0xFFFFFF;
	public var legendColor(default, set): Null<Color> = 0x000000;

	var keycap: KeyRenderer;

	public function new() {
		super();
		final key = new keyson.Keyson.Key(0, "1U", [0, 0], "Palette");
		var keyboard = new keyson.Keyson.Keyboard();

		// TODO: Change keycap size on resize
		this.keycap = KeyMaker.createKey(keyboard, key, 125, 1, 1, bodyColor + 0xff000000);

		var clipper = new ceramic.Quad();
		clipper.width = keycap.width;
		clipper.height = keycap.height;
		clipper.transparent = true;
		keycap.clip = clipper;

		this.add(keycap);
		this.add(clipper);
	}

	function set_bodyColor(color: Color) {
		this.bodyColor = color;
		this.keycap.topColor = bodyColor + 0xff000000;
		this.keycap.bottomColor = KeyMaker.getKeyShadow(keycap.topColor);
		return this.bodyColor;
	}

	function set_legendColor(color: Color) {
		this.legendColor = color;
		if (this.legendColor == this.bodyColor)
		this.legendColor = 0xffffffff - color;
		final shape = this.keycap.children;
		trace(Reflect.fields(shape));
		Reflect.setField(shape, "color", legendColor + 0xff000000);
		Reflect.setField(shape, "color", 0xff000000);
//		this.keycap.legends[0].legendColor = legendColor + 0xff000000;
		trace("Legend color changing");
		return this.legendColor;
	}
}
