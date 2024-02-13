package;

enum abstract Mode(String) from String to String {
	final Place = "place";
	final Edit = "edit";
	final Unit = "unit";
	final Legend = "legend";
	final Keyboard = "keyboard";
	final Palette = "palette";
}
