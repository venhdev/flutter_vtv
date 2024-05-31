import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/dev.dart';

import 'app.dart';
import 'app_state.dart';
import 'config/firebase_options.dart';
import 'config/themes/theme_provider.dart';
import 'core/handler/customer_handler.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'service_locator.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Bloc.observer = GlobalBlocObserver(); // NOTE: dev

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeLocator();

  // get singleton instance from service locator
  final localNotificationHelper = sl<LocalNotificationHelper>();
  final authCubit = sl<AuthCubit>()..onStarted();

  sl<FirebaseCloudMessagingManager>().requestPermission();
  sl<FirebaseCloudMessagingManager>().listen(
    onForegroundMessageReceived: (remoteMessage) {
      if (remoteMessage == null) return;
      localNotificationHelper.showRemoteMessageNotification(remoteMessage);
    },
    onTapMessageOpenedApp: (remoteMessage) {
      CustomerHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
    },
  );
  sl<LocalNotificationHelper>().initializePluginAndHandler(
    onDidReceiveNotificationResponse: (notification) {
      if (notification.payload == null) return;
      final RemoteMessage remoteMessage = RemoteMessageSerialization.fromJson(notification.payload!);
      CustomerHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
    },
  );

  final appState = AppState(sl<SharedPreferencesHelper>(), sl<Connectivity>());
  await appState.init();

  // NOTE: dev
  final savedHost = sl<SharedPreferencesHelper>().I.getString('host');
  if (savedHost != null) {
    host = savedHost;
  } else {
    final curHost = await DevUtils.initHostWithCurrentIPv4('192.168.1.100');
    if (curHost != null) {
      host = curHost;
      sl<SharedPreferencesHelper>().I.setString('host', curHost);
    }
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
