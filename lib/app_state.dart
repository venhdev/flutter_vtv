import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

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
    hasConnection = await _connectivity.checkConnectivity().then((connection) {
      return connection[0] != ConnectivityResult.none;
    });
    subscribeConnection();
  }

  // //.---------------------Bottom Navigation Visibility-----------------------
  // bool _isBottomNavigationVisible = true;

  // bool get isBottomNavigationVisible => _isBottomNavigationVisible;

  // void hideBottomNav() {
  //   if (_isBottomNavigationVisible == false) return;
  //   _isBottomNavigationVisible = false;
  //   notifyListeners();
  // }

  // void showBottomNav() {
  //   if (_isBottomNavigationVisible == true) return;
  //   _isBottomNavigationVisible = true;
  //   notifyListeners();
  // }

  // void setBottomNavigationVisibility(bool isVisible) {
  //   _isBottomNavigationVisible = isVisible;
  //   notifyListeners();
  // }

  //.---------------------Connectivity-----------------------
  Stream<List<ConnectivityResult>> get connectionStream => _connectivity.onConnectivityChanged;

  // subscribe to the connectivity stream
  void subscribeConnection() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connection) {
      hasConnection = connection[0] != ConnectivityResult.none;
      notifyListeners();
    });

    log('done subscribeConnection: $hasConnection');
  }
  //.---------------------Connectivity-----------------------

  //.---------------------First run-----------------------
  bool get isFirstRun => _isFirstRun;

  /// Sets the app as started. (Not the first run)
  Future<void> started() async {
    _isFirstRun = false;
    await _prefHelper.setStarted(false);
    notifyListeners();
  }
  //.---------------------First run-----------------------
}
