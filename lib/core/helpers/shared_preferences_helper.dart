import 'package:shared_preferences/shared_preferences.dart';

const String _keyStarted = 'started';
const String _keyTheme = 'theme';

class SharedPreferencesHelper {
  SharedPreferencesHelper(this._prefs);

  SharedPreferences get I => _prefs;

  final SharedPreferences _prefs;

  bool get isFirstRun => _prefs.getBool(_keyStarted) ?? true;

  Future<void> setStarted(bool value) async {
    await _prefs.setBool(_keyStarted, value);
  }

  bool get isDarkMode => _prefs.getBool(_keyTheme) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyTheme, value);
  }
}
