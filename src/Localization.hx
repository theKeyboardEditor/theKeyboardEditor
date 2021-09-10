package;

import kha.Assets;
import haxe.DynamicAccess;

/*
 * A class for translating between languages: because other languages than English exist
 * Also because sometimes I feel like a pirate, Y'arr!
 */
class Localization {
	public var currentLanguage = "English (US)";
	public var locales: Map<String, Map<String, String>> = [];

	public function new() {
		var _localesJSON:DynamicAccess<Dynamic> = haxe.Json.parse(Assets.blobs.locales_json.toString());
		var _tempLocaleJSON:DynamicAccess<Dynamic>;
	
		locales = [
			for (locale in Reflect.fields(_localesJSON)) {
				_tempLocaleJSON = haxe.Json.parse(Assets.blobs.get(Reflect.field(_localesJSON, locale)).toString());
				locale => [
					for (key in Reflect.fields(_tempLocaleJSON))
						key => Reflect.field(_tempLocaleJSON, key)
				];
			}
		];
	}

	public function tr(v: String) {
		if (currentLanguage != "English (US)" && locales.get(currentLanguage).get(v) != null) {
			return locales.get(currentLanguage).get(v);
		} else {
			return v;
		}
	}
	
	/*
	 * Converts a value from another language to english
	 * This is a hack to fix a flaw with the top menu code which won't work with other languages without this
	 * I'm sorry for my programming sins. Just kidding, I'm not ;)
	 */
	public function toEnglish(value: String) {
		var englishValue = "";

		for (key in locales.get(currentLanguage).keys()) {
			if (value == locales.get(currentLanguage).get(key)) {
				englishValue = key;
			}
		}

		return englishValue;
	}
	
	public function changeLanguage(language: String) {
		currentLanguage = language;
	}
}
