package;

interface KeyRenderer {
	public var width(get, set): Float;
	public var height(get, set): Float;

	public function create(): ceramic.Visual;
	public function pos(x: Float, y: Float): Void;
}
