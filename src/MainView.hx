package;

import keyson.Keyson;
import kha.graphics2.Graphics;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.KeyCode;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import kha.Scheduler;
import haxe.ui.core.Screen;
import haxe.ui.ComponentBuilder;
import haxe.ui.backend.kha.SDFPainter;

/*
 * The main view for theKeyboardEditor
 */
class MainView {
	// Render Surfaces
	var screen: Screen;
	var g: SDFPainter;
	var view: haxe.ui.containers.VBox;

	// Viewport Constants
	inline static final speed: Int = 6;

	// Viewport Offsets
	var viewportX: Int = 200;
	var viewportY: Int = 50;

	// State
	var keyboard: Keyson;
	var inputState: InputState;

	public function new() {
		this.inputState = new InputState();
		Assets.loadEverything(loadingFinished);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	/**
	 * Ran after all assets are loaded
	 */
	private function loadingFinished() {
		this.keyboard = Keyson.parse(Assets.blobs.keyboard_json.toString());

		// Initialize keyboard
		if (Keyboard.get() != null) {
			Keyboard.get().notify(onDown, onUp);
		}

		// HaxeUI Initialization
		haxe.ui.Toolkit.theme = 'dark';
		haxe.ui.Toolkit.init();

		this.screen = Screen.instance;

		// Create base box
		view = new haxe.ui.containers.VBox();
		view.percentWidth = view.percentHeight = 100;

		// Render elements
		var toolbar = ComponentBuilder.fromFile("ui/toolbar.xml");
		view.addComponent(toolbar);
		var sidebar = ComponentBuilder.fromFile("ui/sidebar.xml");
		view.addComponent(sidebar);

		screen.addComponent(view);

		// And now render!
		System.notifyOnFrames(render);
	}

	/**
	 * Used to render out each frame
	 */
	public function render(frames: Array<Framebuffer>): Void {
		g = new SDFPainter(frames[0]);

		g.begin(true, 0xFF282828);

		for (key in keyboard.board[0].keys) {
			drawKey(g, key, {x: this.viewportX, y: this.viewportY});
		}
		screen.renderTo(g);

		g.end();
	}

	/**
	 * Runs 60 times a second
	 */
	public function update() {
		if (inputState.up) {
			viewportY -= speed;
		}

		if (inputState.down) {
			viewportY += speed;
		}

		if (inputState.left) {
			viewportX -= speed;
		}

		if (inputState.right) {
			viewportX += speed;
		}
	}

	/**
	 * Ran once the key is down
	 */
	public function onDown(k: KeyCode) {
		this.inputState.fromKeyCode(k, true);
	}

	/**
	 * Ran once the key is up
	 */
	public function onUp(k: KeyCode) {
		this.inputState.fromKeyCode(k, false);
	}

	/**
	 * Draws a key based on the keyson.Key object
	 */
	private function drawKey(g: SDFPainter, key: keyson.Key, offset: {x: Int, y: Int}, width: Int = 1) {
		// Keycap Bottom
		g.sdfRect(54 * key.position[Axis.X] + offset.x, 54 * key.position[Axis.Y] + offset.y, 54 * width, 54, {
			tr: 7,
			br: 7,
			tl: 7,
			bl: 7
		}, 1, 0x18000000, 2.2, 0xffCCCCCC, 0xffCCCCCC, 0xffCCCCCC, 0xffCCCCCC);
		// Keycap Top
		g.sdfRect(54 * key.position[Axis.X] + offset.x + 6, 54 * key.position[Axis.Y] + offset.y + 3, 42 * width, 42, {
			tr: 5,
			br: 5,
			tl: 5,
			bl: 5
		}, 1, 0x18000000, 2.2, 0xffFCFCFC, 0xffFCFCFC, 0xffFCFCFC, 0xffFCFCFC);
	}
}

/**
 * We define the X and Y axes exclusively for convenience here
 * It will compile down to just X = 0, Y = 1
 */
enum abstract Axis(Int) to Int {
	var X;
	var Y;
}
