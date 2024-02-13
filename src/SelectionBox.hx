package;

import ceramic.Quad;
import ceramic.Arc;
import ceramic.RoundedRect;
import ceramic.Visual;

class SelectionBox extends Visual {
	@content public var outlineColor = 0xFFB13E53; // sweetie-16 red (UI theme 2ndary accent color!)
	@content public var fillColor = 0x270000FF; // note the ARGB alpha channel!

	@content var outline = 2; // in pixels
	@content var roundedCorners = 12; // in pixels

	var r1: Arc;
	var r2: Arc;
	var r3: Arc;
	var r4: Arc;

	var b1: Quad;
	var b2: Quad;
	var b3: Quad;
	var b4: Quad;
	var fill: RoundedRect;
	@content var r: Float;

	override public function set_width(width: Float): Float {
		if (this.width == width)
			return width;
		super.set_width(width);
		contentDirty = true;
		return width;
	}

	override public function set_height(height: Float): Float {
		if (this.height == height)
			return height;
		super.set_height(height);
		contentDirty = true;
		return height;
	}
	override public function new() {
		contentDirty = true;
		super();
	}

	override public function computeContent() {
		if (height == 0 || width == 0) return;

		r = roundedCorners;
		if (height < width) {
			if (height < roundedCorners * 2) r = height / 2;
		} else {
			if (width < roundedCorners * 2)  r = width / 2;
		}

		// all content is to be replaced from scratch
		this.clear();

		//NOTICE: the outline is within the rounded rectangle shape!
		this.r1 = new Arc();
		this.r1.pos(r, r);
		this.r1.radius = r;
		this.r1.color = outlineColor;
		this.r1.angle = 90;
		this.r1.rotation = 270;
		this.r1.borderPosition = INSIDE;
		this.r1.thickness = outline;
		this.r1.alpha = 1;
		this.r1.depth = 4;
		this.add(this.r1);

		this.r2 = new Arc();
		this.r2.pos(width - r, r);
		this.r2.radius = r;
		this.r2.color = outlineColor;
		this.r2.angle = 90;
		this.r2.rotation = 0;
		this.r2.borderPosition = INSIDE;
		this.r2.thickness = outline;
		this.r2.alpha = 1;
		this.r2.depth = 4;
		this.add(this.r2);

		this.r3 = new Arc();
		this.r3.pos(r, height - r);
		this.r3.radius = r;
		this.r3.color = outlineColor;
		this.r3.angle = 90;
		this.r3.rotation = 180;
		this.r3.borderPosition = INSIDE;
		this.r3.thickness = outline;
		this.r3.alpha = 1;
		this.r3.depth = 4;
		this.add(this.r3);

		this.r4 = new Arc();
		this.r4.pos(width - r, height - r);
		this.r4.radius = r;
		this.r4.color = outlineColor;
		this.r4.angle = 90;
		this.r4.rotation = 90;
		this.r4.borderPosition = INSIDE;
		this.r4.thickness = outline;
		this.r4.alpha = 1;
		this.r4.depth = 4;
		this.add(this.r4);

		this.b1 = new Quad();
		this.b1.pos(r, 0);
		this.b1.size(this.width-r*2, outline);
		this.b1.color = outlineColor; // sweetie-16 red (UI theme 2ndary accent color!)
		this.b1.alpha = 1;
		this.b1.depth = 4;
		this.add(this.b1);

		this.b2 = new Quad();
		this.b2.pos(r, this.height - outline / 1);
		this.b2.size(this.width-r*2, outline);
		this.b2.color = outlineColor; // sweetie-16 red (UI theme 2ndary accent color!)
		this.b2.alpha = 1;
		this.b2.depth = 4;
		this.add(this.b2);

		this.b3 = new Quad();
		this.b3.pos(0, r);
		this.b3.size(outline, this.height - r * 2);
		this.b3.color = outlineColor; // sweetie-16 red (UI theme 2ndary accent color!)
		this.b3.alpha = 1;
		this.b3.depth = 4;
		this.add(this.b3);

		this.b4 = new Quad();
		this.b4.pos(width - outline / 1, r);
		this.b4.size(outline, this.height - r * 2);
		this.b4.color = outlineColor;
		this.b4.alpha = 1;
		this.b4.depth = 4;
		this.add(this.b4);

		// The shape is transparent - the color's ALPHA channel is copied over
		this.fill = new RoundedRect();
		this.fill.size(this.width, this.height);
		this.fill.radius(r);
		this.fill.color = fillColor;
		this.fill.depth = 0;
		this.fill.pos(0, 0);
		this.fill.alpha = (fillColor>>24)/256;
		this.add(this.fill);

		super.computeContent();
	}
}
