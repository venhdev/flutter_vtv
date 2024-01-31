import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_vtv/config/themes/theme_provider.dart';
import 'package:flutter_vtv/core/helpers/shared_preferences_helper.dart';
import 'package:flutter_vtv/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_state.dart';
import 'core/services/locator_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialLocator();
  final authBloc = sl<AuthBloc>()..add(AuthStarted());

  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AppState(sl<SharedPreferencesHelper>()),
      ),
      BlocProvider(create: (context) => authBloc),
    ],
    child: const VTVApp(),
  ));
}
