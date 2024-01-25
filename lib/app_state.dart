import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/services/shared_preferences_service.dart';

class AppState extends ChangeNotifier {
  AppState(
    this._isStarted,
    this._pref,
  );

  bool _isStarted;
  bool get isStarted => _isStarted;

  final SharedPreferencesService _pref;

  Future<void> started() async {
    _isStarted = false;
    await _pref.setStarted(false);
    notifyListeners();
  }
}
