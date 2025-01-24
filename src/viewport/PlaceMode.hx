package viewport;

import ceramic.State;
import keyson.Axis;

class PlaceMode extends State {
	var viewport: Viewport;

	public function new(viewport: Viewport) {
		super();
		this.viewport = viewport;
	}

	override function enter() {
		// Called when entering this state
		viewport.onPointerDown(this, viewportMouseDown);
	}

	function viewportMouseDown(_) {
		final shape = CopyBuffer.designatedKey ?? "1U";
		viewport.keyboardUnit = viewport.keyson.units[viewport.focusedUnit];

		// TODO calculate proper shape size and offset:
		final keyStepX = viewport.keyboardUnit.keyStep[Axis.X];
		final keyStepY = viewport.keyboardUnit.keyStep[Axis.Y];
		final capSizeX = viewport.keyboardUnit.capSize[Axis.X];
		final capSizeY = viewport.keyboardUnit.capSize[Axis.Y];

		viewport.gapX = Std.int((keyStepX - capSizeX) / keyStepX * viewport.unit * viewport.viewScale);
		viewport.gapY = Std.int((keyStepY - capSizeY) / keyStepY * viewport.unit * viewport.viewScale);

		var x = viewport.placer.x / viewport.unit;
		var y = viewport.placer.y / viewport.unit;
		viewport.queue.push(new actions.PlaceKey(viewport, viewport.keyboardUnit, shape, x, y));

	}

	override function exit():Void {
		viewport.offPointerDown();
	}
}
