package;

interface KeyRenderer {
	public var unitScale: Float;

	public function create(): ceramic.Visual;
	public function pos(x:Float, y:Float): Void;

	//static function createRectangularKey(shape: String, width: Int, height: Int): Visual {
	//		inline final unit = 100;
	//		inline final gapX = Std.int((keyboard.board[0].keyStep[Axis.X] - keyboard.board[0].capSize[Axis.X]) / keyboard.board[0].keyStep[Axis.X] * unit);
	//		inline final gapY = Std.int((keyboard.board[0].keyStep[Axis.Y] - keyboard.board[0].capSize[Axis.Y]) / keyboard.board[0].keyStep[Axis.Y] * unit);

	//		// For 1U
	//		inline final width = unit - gapX;
	//		inline final height = unit - gapY;

	//		// TODO: Create some form of syntax that can define this information without this switch case creature
	//		switch k.shape {
	//			case "2U":
	//				width = unit * 2 - gapX;
	//				height = unit - gapY;
	//			case "2U vertical":
	//				width = unit - gapX;
	//				height = unit * 2 - gapY;
	//		}

	//		return new RectangularKeyRenderer(width, height);

	//}
}
