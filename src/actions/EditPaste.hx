package actions;

import viewport.Viewport;
import ceramic.TouchInfo;
import keyson.Keyson;

class EditPaste extends Action {
	final viewport: Viewport;
	final device: keyson.Keyboard; // the receiving unit
	final x: Float; // in 1U keyson units
	final y: Float;

	override public function new(viewport: Viewport, device: keyson.Keyboard, x: Float, y: Float) {
		super();
		this.viewport = viewport;
		this.device = device;
		// TODO make this x and y be offsets for the whole ordeal
		this.x = x;
		this.y = y;
	};

	override public function act(type: ActionType) {
/*		if (type != Redo) {
			// is there any difference?
		} else {
*/			// we already store the key object on redo
		for (member in CopyBuffer.selectedObjects.copy()) {
			// add to keyson:
			this.device.insertKey(member.sourceKey);
			// recreate editing event:
			member.onPointerDown(member, (t: TouchInfo) -> {
				this.viewport.keyMouseDown(t, member);
			});
			// add to Ceramic:
			this.viewport.workSurface.add(member);
		}
		trace('Paste: ${CopyBuffer.selectedObjects}');
		super.act(type);
	}

	override public function undo() {
		for (member in CopyBuffer.selectedObjects) {
			// clear keyson:
			this.device.removeKey(member.sourceKey);
			// clear Ceramic:
			this.viewport.workSurface.remove(member);
		}
		CopyBuffer.selectedObjects = [];
		super.undo();
	}
}
