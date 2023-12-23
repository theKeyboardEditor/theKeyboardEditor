package;

interface KeyRenderer {
	public var unitScale: Float;

	public function create(): ceramic.Visual;
	public function pos(x: Float, y: Float): Void;
}
