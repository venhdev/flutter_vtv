import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/login_with_username_and_password.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/retrieve_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../helpers/secure_storage_helper.dart';
import '../helpers/shared_preferences_helper.dart';

// Service locator
GetIt sl = GetIt.instance;

Future<void> initialLocator() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<Connectivity>(Connectivity());
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //! Core - Helpers
  sl.registerSingleton<SharedPreferencesHelper>(SharedPreferencesHelper(sl()));
  sl.registerSingleton<SecureStorageHelper>(SecureStorageHelper(sl()));

  //! Data source
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl()));

  //! Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl()));

  //! UseCase
  sl.registerLazySingleton<LoginWithUsernameAndPasswordUC>(() => LoginWithUsernameAndPasswordUC(sl()));
  sl.registerLazySingleton<RetrieveAuthUC>(() => RetrieveAuthUC(sl()));
  
  //! Bloc
  sl.registerFactory(() => AuthBloc(sl(), sl()));
}

// <https://pub.dev/packages/get_it>