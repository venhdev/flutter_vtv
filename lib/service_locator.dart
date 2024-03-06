import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vtv/features/home/data/data_sources/category_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/helpers/secure_storage_helper.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'core/notification/firebase_cloud_messaging_manager.dart';
import 'core/notification/local_notification_manager.dart';
import 'features/auth/data/data_sources/auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecase/check_token.dart';
import 'features/auth/domain/usecase/login_with_username_and_password.dart';
import 'features/auth/domain/usecase/logout.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/home/data/data_sources/product_data_source.dart';
import 'features/home/data/repository/category_repository_impl.dart';
import 'features/home/data/repository/product_repository_impl.dart';
import 'features/home/domain/repository/category_repository.dart';
import 'features/home/domain/repository/product_repository.dart';
import 'features/home/data/data_sources/search_product_data_source.dart';
import 'features/home/data/repository/search_product_repository_impl.dart';
import 'features/home/domain/repository/search_product_repository.dart';

// Service locator
GetIt sl = GetIt.instance;

Future<void> initializeLocator() async {
  //! External
  final connectivity = Connectivity();
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  final fMessaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<Connectivity>(connectivity);

  //! Core - Helpers - Managers
  sl.registerSingleton<SharedPreferencesHelper>(SharedPreferencesHelper(sharedPreferences));
  sl.registerSingleton<SecureStorageHelper>(SecureStorageHelper(secureStorage));

  sl.registerSingleton<LocalNotificationManager>(LocalNotificationManager(flutterLocalNotificationsPlugin));
  sl.registerSingleton<FirebaseCloudMessagingManager>(FirebaseCloudMessagingManager(fMessaging));

  //! Data source
  sl.registerSingleton<AuthDataSource>(AuthDataSourceImpl(sl(), sl(), sl()));
  sl.registerSingleton<CategoryDataSource>(CategoryDataSourceImpl(sl()));
  sl.registerSingleton<ProductDataSource>(ProductDataSourceImpl(sl()));
  sl.registerSingleton<SearchProductDataSource>(SearchProductDataSourceImpl(sl()));

  //! Repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl(sl()));
  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl(sl()));
  sl.registerSingleton<SearchProductRepository>(SearchProductRepositoryImpl(sl()));
  

  //! UseCase
  sl.registerLazySingleton<LoginWithUsernameAndPasswordUC>(() => LoginWithUsernameAndPasswordUC(sl()));
  sl.registerLazySingleton<LogoutUC>(() => LogoutUC(sl()));
  sl.registerLazySingleton<CheckTokenUC>(() => CheckTokenUC(sl()));

  //! Bloc
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl()));
}

// <https://pub.dev/packages/get_it>