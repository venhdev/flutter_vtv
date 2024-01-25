import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyStarted = 'started';
const String _keyTheme = 'theme';

abstract class SharedPreferencesService {
  //! Started
  bool get isStarted;
  Future<void> setStarted(bool value);
  // Theme
  bool get isDarkMode;
  Future<void> setDarkMode(bool value);
}

@Singleton(as: SharedPreferencesService)
class SharedPreferencesServiceImpl implements SharedPreferencesService {
  SharedPreferencesServiceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  bool get isStarted => _prefs.getBool(_keyStarted) ?? true;

  @override
  Future<void> setStarted(bool value) async {
    await _prefs.setBool(_keyStarted, value);
  }
 
  @override
  bool get isDarkMode => _prefs.getBool(_keyTheme) ?? false;

  @override
  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyTheme, value);
  }
}
