import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_vtv/config/themes/theme_provider.dart';
import 'package:flutter_vtv/core/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_state.dart';
import 'core/services/locator_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await configureDependencies();
  final pref = di<SharedPreferencesService>();

  // wait for 2 seconds
  // await Future.delayed(const Duration(seconds: 2));

  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AppState(pref.isStarted, pref),
      ),
    ],
    child: const VTVApp(),
  ));
}
