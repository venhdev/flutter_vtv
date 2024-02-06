import 'package:flutter/material.dart';

import 'light_theme.dart';

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
