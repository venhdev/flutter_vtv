import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_state.dart';
import 'config/bloc_config.dart';
import 'config/themes/theme_provider.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'locator_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeLocator();
  Bloc.observer = GlobalBlocObserver(); // NOTE: debug
  final appState = AppState(sl<SharedPreferencesHelper>(), sl<Connectivity>());
  await appState.checkConnection();
  appState.subscribeConnection();

  final authCubit = sl<AuthCubit>()..onStarted();

  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => appState,
      ),
      BlocProvider(create: (context) => authCubit),
    ],
    child: const VTVApp(),
  ));
}
