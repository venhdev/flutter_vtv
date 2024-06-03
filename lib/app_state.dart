import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import 'core/constants/global_variables.dart';

class AppState extends ChangeNotifier {
  final SharedPreferencesHelper _prefHelper;
  final Connectivity _connectivity;

  AppState(this._prefHelper, this._connectivity);

  bool? _isServerDown;
  bool? get isServerDown => _isServerDown;

  // control overlay when no wifi connection
  // the overlay builder in "scaffold_with_navbar.dart"
  final OverlayPortalController overlayController = OverlayPortalController();

  /// Initializes the app state.
  /// - Checks if the app is the first run.
  /// - Checks if the device has an internet connection.
  // [REMOVED] - Subscribes to the connectivity stream. (If lost connection will show a snackbar)
  Future<void> init() async {
    _isFirstRun = _prefHelper.isFirstRun;
    // hasConnection = await _connectivity.checkConnectivity() != ConnectivityResult.none;
    hasConnection = await _connectivity.checkConnectivity().then((connection) {
      return connection[0] != ConnectivityResult.none;
    });

    await _checkServerConnection();

    subscribeConnection();
  }

  //*---------------------Server Connection-----------------------*//
  Future<void> _checkServerConnection() async {
    _isServerDown = null;
    notifyListeners();

    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 2)));
    await dio.getUri(uriBuilder(path: '/')).then(
      (_) {},
      onError: (e) {
        if ((e as DioException).response != null) {
          _isServerDown = false;
        } else {
          _isServerDown = true;
        }
        notifyListeners();
      },
    );
  }

  // retry connection to the server
  Future<void> retryConnection() async {
    await _checkServerConnection();
  }

  //*---------------------Bottom Navigation Visibility-----------------------
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

  //*---------------------Connectivity-----------------------

  late bool hasConnection;
  Stream<List<ConnectivityResult>> get connectionStream => _connectivity.onConnectivityChanged;

  // subscribe to the connectivity stream
  void subscribeConnection() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connection) {
      hasConnection = connection[0] != ConnectivityResult.none;

      if (!hasConnection) {
        overlayController.show();
      } else if (hasConnection) {
        overlayController.hide();
      }
      
      notifyListeners();
    });
  }

  //*---------------------First run-----------------------
  late bool _isFirstRun;
  bool get isFirstRun => _isFirstRun;

  /// Sets the app as started. (Not the first run)
  Future<void> started() async {
    _isFirstRun = false;
    await _prefHelper.setStarted(false);
    notifyListeners();
  }
}
