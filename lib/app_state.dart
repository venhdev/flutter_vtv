import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/shared_preferences_helper.dart';

class AppState extends ChangeNotifier {
  AppState(
    this._pref,
  ) : _isStarted = _pref.isStarted;

  bool _isStarted;
  bool get isStarted => _isStarted;

  final SharedPreferencesHelper _pref;

  Future<void> started() async {
    _isStarted = false;
    await _pref.setStarted(false);
    notifyListeners();
  }
}
