import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_vtv/core/notification/firebase_cloud_messaging_manager.dart';
import 'package:flutter_vtv/firebase_options.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_state.dart';
import 'config/bloc_config.dart';
import 'config/themes/theme_provider.dart';
import 'core/constants/api.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'core/notification/local_notification_manager.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'service_locator.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = GlobalBlocObserver(); // NOTE: debug

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeLocator();
  sl<LocalNotificationManager>().init();
  sl<FirebaseCloudMessagingManager>().init();

  final appState = AppState(sl<SharedPreferencesHelper>(), sl<Connectivity>());
  await appState.init();
  final authCubit = sl<AuthCubit>()..onStarted();

  // NOTE: only for debug
  final domain = sl<SharedPreferencesHelper>().I.getString('devDomain');
  if (domain != null) {
    devDOMAIN = domain;
  }

  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => appState),
      BlocProvider(create: (context) => authCubit),
      BlocProvider(create: (context) => sl<CartBloc>()..add(InitialCart())),
    ],
    child: const VTVApp(),
  ));
}
