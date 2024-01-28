package;

import ceramic.TouchInfo;

class KeyRenderer extends ceramic.Visual {
	@content public var topColor: Int = 0xffFCFCFC;
	@content public var bottomColor: Int = 0xFFCCCCCC;

	public var border: ceramic.Border;
	public var pivot: viewport.Pivot;
	public var Viewport: viewport.Viewport;

	public function select() {
		border.visible = !border.visible;
		pivot.visible = border.visible; // we always copy border visibility!
	}
	override public function computeContent() {
		super.computeContent();
		this.onPointerDown(this,keyMouseDown);
	}
	// MOUSE ACTIONS

	public function keyMouseDown(info:TouchInfo) {
		 trace('info: ${info}');
		//StatusBar.inform('Detected:[${info.buttonId}] at: ${Viewport.placer.x / Viewport.unit - .5}, ${Viewport.placer.y / Viewport.unit - .5}');
		//StatusBar.inform('At: ${placer.x / unit - .5}, ${placer.y / unit - .5}');
	}
}
