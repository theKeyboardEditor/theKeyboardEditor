package;

enum abstract Mode(String) from String to String {
	final Place = "place-mode";
	final Edit = "edit-mode";
	final Unit = "unit-mode";
	final Legend = "legend-mode";
	final Color = "color-mode";
	final Present = "present-mode";
}
