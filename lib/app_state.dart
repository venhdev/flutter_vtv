import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'core/helpers/shared_preferences_helper.dart';

class AppState extends ChangeNotifier {
  final SharedPreferencesHelper _prefHelper;
  final Connectivity _connectivity;

  AppState(this._prefHelper, this._connectivity);

  late bool _isFirstRun;
  late bool hasConnection;

  /// Initializes the app state.
  /// - Checks if the app is the first run.
  /// - Checks if the device has an internet connection.
  /// - Subscribes to the connectivity stream. (If lost connection will show a snackbar)
  Future<void> init() async {
    _isFirstRun = _prefHelper.isFirstRun;
    // hasConnection = await _connectivity.checkConnectivity() != ConnectivityResult.none;
    hasConnection = await _connectivity.checkConnectivity().then((connection) => connection.isNotEmpty);
    subscribeConnection();
  }

  Stream<List<ConnectivityResult>> get connectionStream => _connectivity.onConnectivityChanged;

  // subscribe to the connectivity stream
  void subscribeConnection() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connection) {
      hasConnection = connection.isNotEmpty;
      notifyListeners();
    });
  }

  bool get isFirstRun => _isFirstRun;

  /// Sets the app as started. (Not the first run)
  Future<void> started() async {
    _isFirstRun = false;
    await _prefHelper.setStarted(false);
    notifyListeners();
  }
}
