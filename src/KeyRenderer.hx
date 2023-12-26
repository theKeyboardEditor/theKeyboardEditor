package;

interface KeyRenderer {
	public var x(default, set): Float;
	public var y(default, set): Float;
	public var width(get, set): Float;
	public var height(get, set): Float;

	public function create(): ceramic.Visual;
	public function pos(x: Float, y: Float): Void;
    public function select(_: ceramic.TouchInfo): Void;
}
