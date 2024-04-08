import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vtv/features/home/data/data_sources/category_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vtv_common/vtv_common.dart';

import 'core/notification/firebase_cloud_messaging_manager.dart';
import 'features/auth/data/data_sources/auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecase/check_token.dart';
import 'features/auth/domain/usecase/login_with_username_and_password.dart';
import 'features/auth/domain/usecase/logout.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/cart/data/data_sources/cart_data_source.dart';
import 'features/cart/data/repository/cart_repository_impl.dart';
import 'features/cart/domain/repository/cart_repository.dart';
import 'features/home/data/data_sources/local_product_data_source.dart';
import 'features/home/data/data_sources/review_data_source.dart';
import 'features/notification/data/data_sources/notification_data_source.dart';
import 'features/notification/data/repository/notification_repository_impl.dart';
import 'features/notification/domain/repository/notification_repository.dart';
import 'features/order/domain/repository/voucher_repository.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/home/data/data_sources/product_data_source.dart';
import 'features/home/data/data_sources/search_product_data_source.dart';
import 'features/home/data/repository/product_repository_impl.dart';
import 'features/home/data/repository/search_product_repository_impl.dart';
import 'features/home/domain/repository/product_repository.dart';
import 'features/home/domain/repository/search_product_repository.dart';
import 'features/order/data/data_sources/order_data_source.dart';
import 'features/order/data/data_sources/voucher_data_source.dart';
import 'features/order/data/repository/order_repository_impl.dart';
import 'features/order/data/repository/voucher_repository_impl.dart';
import 'features/order/domain/repository/order_repository.dart';
import 'features/profile/data/data_sources/profile_data_source.dart';
import 'features/profile/data/repository/profile_repository_impl.dart';
import 'features/profile/domain/repository/profile_repository.dart';

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

  sl.registerSingleton<LocalNotificationUtils>(LocalNotificationUtils(flutterLocalNotificationsPlugin));
  sl.registerSingleton<FirebaseCloudMessagingManager>(FirebaseCloudMessagingManager(fMessaging));

  //! Data source
  sl.registerSingleton<AuthDataSource>(AuthDataSourceImpl(sl(), sl(), sl()));
  sl.registerSingleton<ProfileDataSource>(ProfileDataSourceImpl(sl(), sl()));

  sl.registerSingleton<CategoryDataSource>(CategoryDataSourceImpl(sl()));
  sl.registerSingleton<ProductDataSource>(ProductDataSourceImpl(sl(), sl()));
  sl.registerSingleton<SearchProductDataSource>(SearchProductDataSourceImpl(sl()));
  sl.registerSingleton<ReviewDataSource>(ReviewDataSourceImpl(sl()));
  sl.registerSingleton<NotificationDataSource>(NotificationDataSourceImpl(sl(), sl()));

  sl.registerSingleton<CartDataSource>(CartDataSourceImpl(sl(), sl()));
  sl.registerSingleton<OrderDataSource>(OrderDataSourceImpl(sl(), sl()));
  sl.registerSingleton<VoucherDataSource>(VoucherDataSourceImpl(sl()));

  sl.registerSingleton<LocalProductDataSource>(LocalProductDataSourceImpl(sl()));

  //! Repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(sl()));

  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl(sl(), sl(), sl(), sl()));
  sl.registerSingleton<SearchProductRepository>(SearchProductRepositoryImpl(sl()));

  sl.registerSingleton<NotificationRepository>(NotificationRepositoryImpl(sl()));
  sl.registerSingleton<CartRepository>(CartRepositoryImpl(sl()));
  sl.registerSingleton<OrderRepository>(OrderRepositoryImpl(sl(), sl()));
  sl.registerSingleton<VoucherRepository>(VoucherRepositoryImpl(sl()));

  //! UseCase
  sl.registerLazySingleton<LoginWithUsernameAndPasswordUC>(() => LoginWithUsernameAndPasswordUC(sl()));
  sl.registerLazySingleton<LogoutUC>(() => LogoutUC(sl()));
  sl.registerLazySingleton<CheckTokenUC>(() => CheckTokenUC(sl()));

  //! Bloc
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => CartBloc(sl(), sl()));
}

// <https://pub.dev/packages/get_it>
